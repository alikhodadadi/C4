function  [value, value_without_barrier] = f(var, barrier_t, data, u)
% Function to be optimized in barrier method for CC method:
% The partial log-Likelihood of the events of a user u which is given to the
% function in data + the penalty of barrier method for constraints.
% Inputs:
%   data: a struct containing the followings:
%       data.adj: the adjacency row of selected user for which we want to
%          calculate partial likelihood 
%       data.time: the vector of times of events 
%       data.node: the vector of nodes of events 
%       data.prod: the vector of products of events 
%       data.tmax: maximum time for which we want to calculate the likelihood 
%           of occuring events in (0, tmax)
%       data.numprod: the total number of products
%       data.numuser: the total number of users
%   u: the user for whom we do the calculations
%   var: a vector containing the mu and alpha vectors for the selected user
%       in a sequence after each other
%   barrier_t: the t parameter of barrier method
% Outputs:
%   value: The final value containing the loglikelihood + penalty of
%       barrier method for constraints
%   value_without_barrier: The partial log-likelihoof value
P = data.numprod;
U = data.numuser;
beta = data.beta;
ngbs_u = find(data.adj(u,:));

mu_u = var(1:P)';
a_u = zeros(1,U);
a_u(ngbs_u) = var(P+1:end)';

times = data.time;
nodes = data.node;
prods = data.prod;
tmax = data.tmax;
N = length(times);

inds  = find(nodes == u);% find the events of node u
log_sum_lambda = 0; %log(sum(mu_u))+ mu_u(products(1)) - log(sum(exp(mu_u')));

for i = 1:length(inds)
    n = inds(i);
    tn = times(n);
    pn = prods(n);
    
    ss = sum(mu_u);
    if(n>1)
        ss = ss +a_u(nodes(1:n-1))*g(tn-times(1:n-1));
    end
    log_sum_lambda = log_sum_lambda+log(ss);
    
    % For the likelihood of mark
    ss = mu_u(pn);
    if(n>1)
        ind = find(prods(1:n-1)== pn);
        if(~isempty(ind))
            ss = ss + a_u(nodes(ind))* g(tn-times(ind));
        end
    end
    log_sum_lambda = log_sum_lambda + beta * ss;
    
    lamb_ps = mu_u';
    for p=1:P
        ind = find(prods(1:n-1)==p);
        if(~isempty(ind))
            lamb_ps(p) = lamb_ps(p) + a_u(nodes(ind))* g(tn-times(ind));
        end
    end
    % For accuracy problems we use the logsumexp function instead of
    % trivial way
    log_sum_lambda = log_sum_lambda - logsumexp(beta * lamb_ps);
end
log_sum_lambda = log_sum_lambda - a_u(nodes(1:N))*g_int(tmax-times(1:N)); 
log_sum_lambda = log_sum_lambda - tmax * sum(mu_u);

value_without_barrier = -log_sum_lambda;
value = value_without_barrier - (1./barrier_t) *(sum(log(mu_u))+sum(log(a_u(ngbs_u))));
end