function  [value, value_without_barrier] = f(var, barrier_t, data, u, p)
% Function to be optimized in barrier method for CP method [1]:
% The partial log-Likelihood of the events of a user u and product p, 
%   which is given to the function in data + the penalty of barrier method 
%   for constraints.
% Inputs:
%   data: a struct containing the followings:
%       data.adj: the adjacency row of selected user for which we want to
%       calculate partial likelihood 
%       data.time: the vector of times of events 
%       data.node: the vector of nodes of events 
%       data.prod: the vector of products of events 
%       data.tmax: maximum time for which we want to calculate the likelihood 
%           of occuring events in (0, tmax)
%       data.numprod: the total number of products
%       data.numuser: the total number of users
%   u: the user for  which the likelihood is calculate
%   p: the product for which the likelihood is calculated
%   var: a vector containing the mu and alpha vectors for the selected user
%       in a sequence after each other
%   barrier_t: the t parameter of barrier method
% Outputs:
%   value: The final value containing the loglikelihood + penalty of
%       barrier method for constraints
%   value_without_barrier: The partial log-likelihoof value
%**************************************************************************
% [1] Valera, Isabel, Manuel Gomez-Rodriguez, and Krishna Gummadi."Modeling
%     Diffusion of Competing Products and Conventions in Social Media."
%     NIPS Workshop in Networks. 2014.
%**************************************************************************

beta = 1;
P = data.numprod;
U = data.numuser;
ngbs_u = find(data.adj(u,:));

mu_up = var(1);
a_up  = var(2:P+1)';
b_up  = var(P+2:end)';

times = data.time;
nodes = data.node;
prods = data.prod;
tmax = data.tmax;
inds  = find(nodes == u & prods == p);% find the events of node u and product p
log_sum_lambda = 0; %log(sum(mu_u))+ mu_u(products(1)) - log(sum(exp(mu_u')));

for i = 1:length(inds)
    n = inds(i);
    tn = times(n);
    pn = prods(n);
    
    ss = mu_up;
    if(n>1)
        % find the previous events of u
        ind = find(nodes(1:n-1)== u);
        if(~isempty(ind))
            ss = ss + a_up(prods(ind)) * g(tn-times(ind));
        end
        
        %finding the previous events of neighbors of u
        n_ind = ismember(nodes(1:n-1), ngbs_u);
        if(~isempty(prods(n_ind)))
            ss = ss + b_up(prods(n_ind)) * g(tn-times(n_ind));
        end
    end
    log_sum_lambda = log_sum_lambda + log(ss);
    
end

log_sum_lambda = log_sum_lambda - tmax * mu_up;

ind = find(nodes == u);
log_sum_lambda = log_sum_lambda - a_up(prods(ind)) * g_int(tmax-times(ind));

ind2 = ismember(nodes, ngbs_u);
log_sum_lambda  = log_sum_lambda - b_up(prods(ind2)) * g_int(tmax-times(ind2));

value_without_barrier = - log_sum_lambda;
value = value_without_barrier - (1./barrier_t)*( log(mu_up) + sum(log(a_up(p)))+ sum(log(b_up(p))) );
value = value + beta*(mu_up^2 + sum(a_up.^2)+ sum(b_up.^2));
end