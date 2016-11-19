function I_u = UserIntensity_t(mu_u, a_u, event_times, event_nodes, event_products, t)
% This function calculates the intensity of node u at time t given
% previous events
% Inputs:
%   mu_u:  A 1*P vector conaining the \mu for user u 
%   t: the time for which we want to calculate Intensity
% Outputs:
%   I: a 1*P vector showing the intensity of node u for each product at time
%      t. 
  
    
	I_u = mu_u;
    
    i=1;
    while (1)
        if(i> length(event_nodes))
            break;
        end
        ui = event_nodes(i);
        ti = event_times(i);
        pi = event_products(i);
        
        if(ti>= t)
            break;
        end
        
        I_u(pi) = I_u(pi) + a_u(ui)*g(t-ti);
        i = i +1;
    end
end
