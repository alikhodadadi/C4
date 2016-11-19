function res = loglike_node_events_Independent(cascades, a_u, mu_u, N_e, P, u)
% This function accepts the cascades and for user u calculates the
% likelihood of its events given the cascades
% Inputs:
%       cascades: a struct containing all cascades
%       a_u: a row vector of influence of nodes on node u
%       mu_u: a row vector of external intensity of node u for purchasing P
%       products
%       N_e: the number of first events that should be used to calculate
%       likelihood
%       P: the number of Products
%       u: the node for which we calculate the likelihood
% Outputs:
%       res: the computed likelihood

    C = length(cascades);
    res = 0;
    for c=1:C
       times = cascades{c}.times;
       nodes = cascades{c}.nodes;
       products = cascades{c}.products;
       
       % Only selects the first N_e events
       times = times(1:N_e);
       products = products(1:N_e);
       nodes = nodes(1:N_e);
       
       inds  = find(nodes == u);% find the events of node u
       T = times(N_e); % Sets the time_window of observation till N_e event
        
       for i=1:length(inds) % calculates based on events of node u
           n = inds(i);
           un = nodes(n);
           tn = times(n);
           pn = products(n);
           
           
           % The first part of likelihood
           ss = mu_u(pn); 
           if n > 1
               ind = find(products(1:n-1)== pn);
               if(~isempty(ind))
                   ss = ss + a_u(nodes(ind))* g(tn-times(ind));
               end
           end
           res = res + log(ss);
           
       end
       res = res - a_u(nodes(1:N_e))*g_int(T-times(1:N_e));%calculate the integral 
       res = res - T * sum(mu_u);
    end
end