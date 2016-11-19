function [lglk] = Competitive_loglike(data, a, mu)
% This function calculates the likelihood of data using the a and mu
% parameters

P = data.numprod;
U = data.numuser;
times = data.time;
nodes = data.node;
prods = data.prod;
beta = data.beta;

tmax = data.tmax;
N = length(times);

res = 0;
for n=1:N
    if(mod(n, 1000)==0)
        disp('%%+++++++ competitive +++++%%');
        disp(n);
        
    end
    un = nodes(n);
    tn = times(n);
    pn = prods(n);
           
    ss =  sum(mu(un,:),2);
    if n > 1
        ss = ss + a(un, nodes(1:n-1)) * g(tn-times(1:n-1));
    end
    res = res + log(ss);
    %For the likelihood of mark
    ss = mu(un,pn);
     
    if(n>1)
        ind = find(prods(1:n-1)==pn);
        if(~isempty(ind))
            ss = ss + a(un, nodes(ind))* g(tn-times(ind));
        end
    end
    
    res = res + beta * ss;
    
    lamb_ps = mu(un,:)';
    for p=1:P
        ind = find(prods(1:n-1)==p);
        if(~isempty(ind))
            lamb_ps(p) = lamb_ps(p) + a(un, nodes(ind))* g(tn-times(ind));
        end
    end
    res = res - logsumexp(beta * lamb_ps);
    res = res - sum(a(:, un)*g_int(tmax-tn));
end
res = res - tmax * sum(sum(mu));
lglk = -res;
end
