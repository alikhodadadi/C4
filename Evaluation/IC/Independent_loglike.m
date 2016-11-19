function [lglk] = Independent_loglike(data, a, mu)
% This function calculates the likelihood
% its inputs are the set of cascades, influence matrix and mu matrix
% its differnece with loglike function is in its inputs, the loglike
% function accepts a structture vmodel as input, this function 
%accepts the a and mu matrixes instead of vmodel

P = data.numprod;
U = data.numuser;
times = data.time;
nodes = data.node;
prods = data.prod;
tmax = data.tmax;
N = length(times);

res = 0;
for n=1:N
    if(mod(n, 1000)==0)
        disp('%%+++++++ independent +++++%%');
        disp(n);
        
    end
    un = nodes(n);
    tn = times(n);
    pn = prods(n);
    
    ss =  mu(un,pn);       
    if n > 1
        ind = find(prods(1:n-1)== pn);
        if(~isempty(ind))
            ss = ss + a(un, nodes(ind))* g(tn-times(ind));
        end
    end
    res = res + log(ss);
    res = res - sum(a(:, un)*g_int(tmax-tn));
end
res = res - tmax * sum(sum(mu));
lglk = -res;
end


