function [ avg_MSE ] = calc_mse( a, mu, est_a, est_mu )
%This function gets as input the real and estimated as and mus and
%calculates the average MSE of estimated parameters
%   
N_u = length(a);
N_p = size(mu , 2);

%% Considering all elements
a_mse  = sum(sum((a - est_a).^2));
mu_mse = sum(sum((mu - est_mu).^2));
avg_MSE = (a_mse + mu_mse)/(N_u*(N_u + N_p));

% %% Considering only neighbors
% a_inds = find(a> 0);
% a_mse  = sum(sum((a(a_inds) - est_a(a_inds)).^2));
% mu_mse = sum(sum((mu - est_mu).^2));
% avg_MSE = (a_mse + mu_mse)/((length(a_inds) + N_u*N_p));
end

