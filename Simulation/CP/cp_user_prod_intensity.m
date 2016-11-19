function I_up = cp_user_prod_intensity(mu_up, a_up, b_up, data, u, p, t, n)
% This function calculates the intensity of node u for product p, at time t
% given n previous events, using Isabel Valera's model. 
%Inputs:
%   mu_up:  the exogeneous intensity ( \mu ) for user u and product p
%    a_up:  a 1*N vector containing the influence of neighbors on node p
%   t: the time for which we want to calculate Intensity
%   n: the number of  first events we use to calculate the intensity at t
%   data: the events which will be used to calculate the intensity
%   u: the user for him we calculate the intesities
% Outputs:
%   I_up:  the intensity of node u for product p
%**************************************************************************
% [1] Valera, Isabel, Manuel Gomez-Rodriguez, and Krishna Gummadi."Modeling
%     Diffusion of Competing Products and Conventions in Social Media."
%     NIPS Workshop in Networks. 2014.
%**************************************************************************
if nargin < 8
    n = length(events.times); 
end
adj_u = data.adj(u,:);
ngbs_u = find(adj_u);
times = data.time;
nodes = data.node;
prods = data.prod;
I_up = mu_up;
for i = n-20:n
    if(i>0)
        ui = nodes(i);
        ti = times(i);
        pi = prods(i);
        if(ui==u)
            I_up = I_up + a_up(pi)*g(t-ti);
        else
            ind = find(ngbs_u == ui);
            if(~isempty(ind))
                I_up = I_up + b_up(pi)*g(t-ti);
            end
        end
    end
end
end
