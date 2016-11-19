function grad = fgrad(var, barrier_t, data, u)
% This function calculated the Gradeint of function f using current value of
%   parameters in var for CC method.
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

T = data.tmax;
P = data.numprod;
U = data.numuser;
beta =  data.beta;

ngbs_u = find(data.adj(u,:));
ngbs_u_num = length(ngbs_u);

mu_u = var(1:P)';
alpha_u = zeros(1,U);
alpha_u(ngbs_u) = var(P+1:end)';

times = data.time;
nodes = data.node;
prods = data.prod;

mu_u_diff = zeros(1,P);
alpha_u_diff = zeros(1, ngbs_u_num);

inds  = find(nodes == u);% find the events of node u
for i = 1:length(inds)
    n = inds(i);
    tn = times(n);
    pn = prods(n);
    
    I_u = user_intensity(mu_u, alpha_u, times, nodes, prods, tn, n-1);
    tj = exp(times(1:n-1)-tn);
    
    mu_u_diff = mu_u_diff + 1/sum(I_u);
    mu_u_diff(pn) = mu_u_diff(pn) + beta;
    
    
    ss = repmat(I_u',[1,P]) - repmat(I_u,[P,1]) ;
    mu_u_diff = mu_u_diff - beta./sum(exp(beta*ss));
    
    sum_I_u = sum(I_u);
    temp = zeros(P,ngbs_u_num);
    % for the ease of calculations only considers the last 20 events
    for j =n-20:n-1
        if(j>0)
        uj = find(ngbs_u == nodes(j));
        pj = prods(j);
        if(~isempty(uj))
            temp(pj, uj) = temp(pj, uj) + tj(j);
        end
        end
    end
    
    alpha_u_diff = alpha_u_diff + sum( temp)./sum_I_u;
    alpha_u_diff = alpha_u_diff + beta*temp(pn, :);
    [~, q_max_inten] = max(I_u); 
    alpha_u_diff = alpha_u_diff - beta* temp(q_max_inten, :);
end
mu_u_diff = mu_u_diff - T;

integral = 1 - exp(-(T - times));
node_integral = zeros(1,ngbs_u_num);
for i=1:length(times)
    ui = find(ngbs_u == nodes(i));
    if(~isempty(ui))
        node_integral(ui) = node_integral(ui) + integral(i); 
    end
end
alpha_u_diff = alpha_u_diff - node_integral;
grad = [-mu_u_diff'; -alpha_u_diff'];
grad = grad + (1./barrier_t) * [-1./mu_u'; -1./alpha_u(ngbs_u)'];
end