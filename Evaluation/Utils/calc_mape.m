function [ avg_MAPE ] = calc_mape( a, mu, est_a, est_mu )
%This function gets as input the real and estimated as and mus and
%calculates the average relative error of estimated parameters
%   
N_u = length(a);
N_p = size(mu , 2);

a_inds = (find( a>0));
mu_inds = (find(mu>0));

%% Considering all elements
 a_mape   = sum(sum(abs( a( a_inds) - est_a ( a_inds))./ a( a_inds)));
mu_mape   = sum(sum(abs(mu(mu_inds) - est_mu(mu_inds))./mu(mu_inds)));
avg_MAPE = (a_mape + mu_mape)/(length(a_inds) + length(mu_inds));


end

