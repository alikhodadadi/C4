function p = ic_sample_product(user_Is)
% This function samples a product for a user given his product intensities,
% using the independent cascade model (IC).
% Inputs:
%   user_Is: a P*1 vector containing different intensities for a user where
%            P is the number of products.
% Outputs:
%   p: the samples product
    u = rand()*sum(user_Is);
    sumIs = 0;
    for p=1:length(user_Is)
       sumIs = sumIs + user_Is(p);
       if sumIs >= u
           break;
       end
    end
end