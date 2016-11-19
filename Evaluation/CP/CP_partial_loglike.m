function [lglk] = Valera_partial_loglike(data, mu_up, a_up, b_up, u, p)
%This function calculated the partial likelihood of events of user u and
%product p using a , b and mu parameters of user u and product p. 
ngbs_u = find(data.adj(u,:));

times = data.time;
nodes = data.node;
prods = data.prod;
tmax = data.tmax;

res = 0;
inds  = find(nodes == u & prods == p);% find the events of node u and product p
for i = 1:length(inds)
    n = inds(i);
    tn = times(n);
    
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
    res = res + log(ss);
    
end

res = res - tmax * mu_up;

ind = find(nodes == u);
res = res - a_up(prods(ind)) * g_int(tmax-times(ind));

ind2 = ismember(nodes, ngbs_u);
res = res - b_up(prods(ind2)) * g_int(tmax-times(ind2));

lglk = - res;    
end
