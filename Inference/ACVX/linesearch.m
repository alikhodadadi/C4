function [ t ] = linesearch(var, d_var, f, fgrad, param)
% this function implements the linesearch method which is a part of newton
% method.
    %%----Initialize----%%
    a = param.linesearch_a;
    b = param.linesearch_b;
    t = param.linesearch_t0;

	f_current = f(var);
    f_next = f(var + t * d_var);
    
    %%----Check f_next is in domain----%%
    while (f_next<0 || min(var + t * d_var)<0)
        t = t * b;
        f_next = f(var + t * d_var);
    end

    %%----Backtrack----%%
    grad_f = fgrad(var);
    while f_next > f_current + a * t * dot(grad_f, d_var)
        t = b * t;
        f_current = f_next;
        f_next = f(var + t * d_var);
    end
end

