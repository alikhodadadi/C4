function [optvar, optval] = newton(initvar, f, fgrad, fhess, param)
% this function implements the newton method for optimization of function f
% using its Gradient and Hessian functions provided in fgrad and fhess
% respectively.
    eps = param.newton_eps;
    maxitr = param.newton_maxitr;
    var = initvar;
    itr = 1;
    f_history = [];
    b_history = [];
    while true
        fprintf('\n Newton Iteration #%d \n', itr)
        
        %%----Find gradient and Hessian----%%
        
        f_grad = fgrad(var);
        f_hess = fhess(var);

        %%----Correct Hessian ----%%
        if(rcond(f_hess)<1e-12)
            warning('RCOND is less than 1e-12, use approximate inv instead of inv')
            h = approxinv(f_hess);
        else
            h = inv(f_hess);
        end

        %%----Find Newton direction----%%
        dnt_var = - h * f_grad;
        lamda_square = -dot(f_grad, dnt_var);

        %%----Check stopping condition----%%
        if(lamda_square/2 <= eps || itr > maxitr)
            break;
        end

        %%----Find Newton step----%%
        t = linesearch(var, dnt_var, f, fgrad, param);

        %%----Update----%%
        var = var + t * dnt_var;
        [b_history(itr), f_history(itr)]  = f(var); % value of f without barrier
        itr = itr + 1;
    end
    
%     subplot(3,1,1); plot(b_history);
%     subplot(3,1,2); plot(f_history);
%     subplot(3,1,3); plot(b_history + f_history);
   %   plot(f_history);
    % plot(b_history);
     % drawnow
  %  pause
    optvar = var;
   % optval = f(var);
   [~, optval] = f(var);
end

