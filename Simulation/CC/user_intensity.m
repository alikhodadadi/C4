function I_u = user_intensity(mu_u, a_u, event_times, event_nodes, event_products, t, n)
% This function calculates the intensity of node u at time t given n
% previous events
% Inputs:
%   mu_u:  A 1*P vector conaining the \mu for user u 
%   t: the time for which we want to calculate Intensity
%   n: the number of  first events we use to calculate the intensity in t
% Outputs:
%   I: a 1*P vector showing the intensity of node u for each product at time
%      t. 

    if nargin < 7
       n = length(events.times); 
    end
    
	I_u = mu_u;
	
    for i=n-20:n
        if(i>0)
        ui = event_nodes(i);
        ti = event_times(i);
        pi = event_products(i);  
        I_u(pi) = I_u(pi) + a_u(ui)*g(t-ti);
        end
    end
end
