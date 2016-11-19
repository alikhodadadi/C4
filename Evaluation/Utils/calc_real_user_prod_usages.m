function [ prod_usages ] = calc_real_user_prod_usages( data )
% This function calculates the total number of usages of each product for
% each user using the data.
num_prods = data.numprod;
num_users = data.numuser;
prod_usages = zeros(num_users, num_prods);
for i =1:length(data.times)
    u = data.nodes(i);
    p = data.prods(i);
    prod_usages (u,p) = prod_usages (u,p) +1;
end
end 

