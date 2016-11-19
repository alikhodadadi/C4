function hess = fhess(var, barrier_t, data, u, p)
% This function calculates the Hessian of function f using current value of
%   parameters in var for the CP Method [1].
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
%   grad: the gradient vector of the function f for user u
%**************************************************************************
% [1] Valera, Isabel, Manuel Gomez-Rodriguez, and Krishna Gummadi."Modeling
%     Diffusion of Competing Products and Conventions in Social Media."
%     NIPS Workshop in Networks. 2014.
%**************************************************************************

beta = 1;% the parameter of valera method
T = data.tmax;
P = data.numprod;
U = data.numuser;
ngbs_u = find(data.adj(u,:));
ngbs_u_num = length(ngbs_u);

mu_up = var(1)';
a_up = var(2:P+1)';
b_up = var(P+2:end)';

times = data.time;
nodes = data.node;
prods = data.prod;


mu_mu_up_diff = 0;
a_a_up_diff = zeros(P, P);
b_b_up_diff = zeros(P, P);
mu_a_up_diff = zeros(1, P);
mu_b_up_diff = zeros(1, P);
a_b_up_diff = zeros(P, P);

inds  = find(nodes == u & prods == p);% find the events of node u & prod p
for i = 1:length(inds)
    n = inds(i);
    tn  = times(n);
    I_up = cp_user_prod_intensity(mu_up, a_up, b_up, data, u, p, tn, n-1);
    tj = exp(times(1:n-1)-tn);
     
    %%----- Calculating the difference of mu_up against mu_up -----%%
    mu_mu_up_diff = mu_mu_up_diff - 1/(I_up)^2;
    
    %%------ Calculating the other differences ----------%%
    temp_a = zeros(1, P);
    temp_b = zeros(1, P);
    for j =n-20:n-1
        if(j>0)
            uj = nodes(j);
            pj = prods(j);
            
            if(uj == u)
                temp_a(pj) = temp_a(pj) + tj(j);
            end
            if(ismember(uj, ngbs_u))
                temp_b(pj) = temp_b(pj) + tj(j);
            end
        end
    end
    %%------ difference of a_up against a_up -----------%%
    a_a_up_diff = a_a_up_diff - (temp_a'*temp_a)./(I_up^2);
    
    %%------ difference of b_up against b_up -----------%%
    b_b_up_diff = b_b_up_diff - (temp_b'*temp_b)./(I_up^2);
    
    %%------ difference of mu_up against a_up ----------%%
    mu_a_up_diff = mu_a_up_diff - temp_a./(I_up^2);
    
    %%------ difference of mu_up against b_up ----------%%
    mu_b_up_diff = mu_b_up_diff - temp_b./(I_up^2);
    
    %%------ difference of a_up against b_up -----------%%
    a_b_up_diff = a_b_up_diff - (temp_a'*temp_b)./(I_up^2);    
end

hess = -[mu_mu_up_diff, mu_a_up_diff, mu_b_up_diff; 
         mu_a_up_diff', a_a_up_diff , a_b_up_diff ;
         mu_b_up_diff', a_b_up_diff', b_b_up_diff];

barr_a = zeros(1,P);
barr_b = zeros(1,P);
barr_a(p) = 1/(a_up(p)^2);
barr_b(p) = 1/(b_up(p)^2);

hess = hess + (1./barrier_t) * diag([1./(mu_up^2), barr_a, barr_b]);

hess = hess + 2*beta*eye(length(hess));
end