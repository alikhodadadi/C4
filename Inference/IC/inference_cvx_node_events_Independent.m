function [learned_a, learned_mu ]= inference_cvx_node_events_Independent(cascades, structure, N, U, P)
new_a = zeros(U,U);
new_mu = zeros(U,P);
tic
for i =1%:U
    i
    ind_a = find(full(structure(i,:))> 0);
    N_a = length(ind_a);
    
    disp('Dalam..');
    cvx_begin
        variables  a_u(N_a) mu_u(1,P) nonegative;
        expression na(1,U)
        na(ind_a)= a_u;
        
         minimize(-loglike_node_events_Independent(cascades, na, mu_u, N, P, i))   
         subject to
         mu_u  >= 0;
         a_u   >= 0;
         a_u   <= 1;
    cvx_end 
    
    new_a(i,:) = na;
    %new_a(ind_a) = a_u;
    new_mu(i,:) = mu_u;
end
toc

new_a(new_a<0)=0;
new_mu(new_mu<0)=0;

learned_a  = new_a ;
learned_mu = new_mu;
end

