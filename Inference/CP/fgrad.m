function grad = fgrad(var, barrier_t, data, u, p)
% This function calculated the Gradeint of function f using current value of
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

beta = 1; % parameter of Valera mthod.
T = data.tmax;
P = data.numprod;
U = data.numuser;

ngbs_u = find(data.adj(u,:));
ngbs_u_num = length(ngbs_u);

mu_up = var(1);
a_up = var(2:P+1)';
b_up = var(P+2:end)';


times = data.time;
nodes = data.node;
prods = data.prod;

inds  = find(nodes == u & prods==p);% the events of node u and product p

%% Calculating the differencial for mu_up
mu_up_diff = 0;
for i = 1:length(inds)
    n = inds(i);
    tn = times(n);
    
    I_up = cp_user_prod_intensity(mu_up, a_up, b_up, data, u, p, tn, n-1);
    mu_up_diff = mu_up_diff + 1/I_up;
end
mu_up_diff = mu_up_diff - T;

%% Calculating the differencial for a_up
a_up_diff = zeros(1, P);
inds  = find(nodes == u & prods == p);% find the events of node u
for i = 1:length(inds)
    n = inds(i);
    tn = times(n);
    
    I_up = cp_user_prod_intensity(mu_up, a_up, b_up, data, u, p, tn, n-1);
    tj = exp(times(1:n-1)-tn);
    
    temp = zeros(1,P);
    for j =n-20:n-1
        if(j>0)
        pj = prods(j);
        uj = nodes(j);
        if(uj==u)
            temp(pj) = temp(pj) + tj(j);
        end
        end
    end
    
    a_up_diff = a_up_diff + temp./I_up;
end
inds = find( nodes == u);
integral = 1 - exp(-(T - times(inds)));

u_prods_integral = zeros(1,P);
for i=1:length(inds)
    n = inds(i);
    pi = prods(n);
    u_prods_integral(pi) = u_prods_integral(pi) + integral(i); 
end

a_up_diff = a_up_diff - u_prods_integral;

%% Calculating the differencial for b_up
b_up_diff = zeros(1, P);
inds  = find(nodes == u & prods == p);% find the events of node u& prod p
for i = 1:length(inds)
    n = inds(i);
    tn = times(n);
    
    I_up = cp_user_prod_intensity(mu_up, a_up, b_up, data, u, p, tn, n-1);
    
    tj = exp(times(1:n-1)-tn);
    
    temp = zeros(1,P);
    for j =n-20:n-1
        if(j>0)
            uj = nodes(j);
            pj = prods(j);
            
        if(ismember(uj, ngbs_u))
            temp(pj) = temp(pj) + tj(j);
        end
        end
    end
    
    b_up_diff = b_up_diff + temp./I_up;
end

integral = 1 - exp(-(T - times));
un_prods_integral = zeros(1,P);

ind = find(ismember(nodes, ngbs_u));
for i=1:length(ind)
    n = ind(i);
    pi = prods(n);
    un_prods_integral(pi) = un_prods_integral(pi) + integral(n);
end
b_up_diff = b_up_diff - un_prods_integral;

grad = [-mu_up_diff'; -a_up_diff';-b_up_diff'];

barr_a = zeros(P,1);
barr_b = zeros(P,1);
barr_a(p) = 1/a_up(p);
barr_b(p) = 1/b_up(p);

grad = grad + (1./barrier_t) * [-1/mu_up; -barr_a; -barr_b];

grad = grad + 2*beta*[mu_up;a_up';b_up'];

end