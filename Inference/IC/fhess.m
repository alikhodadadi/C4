function hess = fhess(var, barrier_t, data, u)
% This function calculated the Hessian of function f using current value of
%   parameters in var for IC method.
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
%   u: the user for whom we do the calculations
%   var: a vector containing the mu and alpha vectors for the selected user
%       in a sequence after each other
%   barrier_t: the t parameter of barrier method
%   
% Outputs:
%   hess: the Hessian matrix of the function f for user u

if nargin < 3
    barrier_t = 0;
end

T = data.tmax;
P = data.numprod;
U = data.numuser;
ngbs_u = find(data.adj(u,:));
ngbs_u_num = length(ngbs_u);


mu_u = var(1:P)';
alpha_u = zeros(1,U);
alpha_u(ngbs_u) = var(P+1:end)';

times = data.time;
nodes = data.node;
prods = data.prod;

%% Calculating the entities of Hessian matrix
mu_mu_u_diff = zeros(P,P);
inds  = find(nodes == u);% find the events of node u
for i = 1:length(inds)
    n = inds(i);
    tn  = times(n);
    pn = prods(n);
    
    I_u = UserIntensity(mu_u, alpha_u, times, nodes, prods, tn, n-1);
    
    
    %%----Calculating diff. of mu against mu----%%
    mu_mu_u_diff(pn, pn) = mu_mu_u_diff(pn, pn) - 1/(I_u(pn)^2);
end

%%----Calculating diff. of alphas against alphas----%%
alpha_alpha_u_diff = zeros(ngbs_u_num, ngbs_u_num);
inds  = find(nodes == u);% find the events of node u
for i = 1:length(inds)
    n = inds(i);
    tn  = times(n);
    pn  = prods(n);
    
    I_u = UserIntensity(mu_u, alpha_u, times, nodes, prods, tn, n-1);
    tj = exp(times(1:n-1)-tn);
    
    temp = zeros(1,ngbs_u_num);
    for j =n-20:n-1
        if(j>0)
            uj = find(ngbs_u == nodes(j)); 
            pj = prods(j);
            if(~isempty(uj) && pj == pn)
            temp(uj) = temp(uj) + tj(j);
            end
        end
    end
    
    alpha_alpha_u_diff = alpha_alpha_u_diff - temp'*temp/(I_u(pn)^2);
end

%%----Calculating diff. of mus against alphas----%%
mu_alpha_u_diff = zeros(P, ngbs_u_num);
inds  = find(nodes == u);% find the events of node u
for i = 1:length(inds)
    n   = inds(i);
    tn  = times(n);
    pn  = prods(n);
    
    I_u = UserIntensity(mu_u, alpha_u, times, nodes, prods, tn, n-1);
    
    tj = exp(times(1:n-1)-tn);
    
    temp = zeros(1,ngbs_u_num);
    for j =n-20:n-1
        if(j>0)
            uj = find(ngbs_u == nodes(j));%uj = nodes(j);
            pj = prods(j);
            if(~isempty(uj) && pj==pn)
                temp(uj) = temp(uj) + tj(j);
            end
        end
    end
    mu_alpha_u_diff(pn,:) = mu_alpha_u_diff(pn,:) - temp./(I_u(pn)^2);
end

hess = -[mu_mu_u_diff      mu_alpha_u_diff; 
         mu_alpha_u_diff'   alpha_alpha_u_diff];

hess = hess + (1./barrier_t) * diag([1./(mu_u.^2), 1./(var(P+1:end)'.^2)]);
end