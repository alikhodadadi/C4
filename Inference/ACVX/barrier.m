function [optvar, optval] = barrier(initvar, f, fgrad, fhess, param)
% This function implements the barrier method for minimizing function f,
% for which the gradient is calculated in function fgrad, and the hessian
% is calculated in fhess.

eps = param.barrier_eps;
mu  = param.barrier_mu;
numcons = param.numcons;

var = initvar;
if param.numcons == 0
    %%---Newton Unconstrained Optimization---%%
    f_t = @(x) f(x,inf);
    fgrad_t = @(x) fgrad(x,inf);
    fhess_t = @(x) fhess(x,inf);
    [optvar, optval] = newton(initvar, f_t, fgrad_t, fhess_t, param);
else
    %%---Barrier Constrained Optimization---%%
    t = numcons/(1e-5);
    itr = 1;
    while true
        fprintf('\n===Barrier Iteration #%d=====\n', itr)    
        f_t = @(x) f(x,t);
        fgrad_t = @(x) fgrad(x,t);
        fhess_t = @(x) fhess(x,t);
        [optvar, optval] = newton(var, f_t, fgrad_t, fhess_t, param);
        var = optvar;
        
        if(numcons/t < eps)
            break;
        end
        t = (mu) * t;
        itr = itr +1;
    end
end

fprintf('\n********Problem Solved!********\n')
end
