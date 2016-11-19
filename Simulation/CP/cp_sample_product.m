function p = cp_sample_product(user_Is)
% This function samples a product for a user given his product intensities
% using Isabel Valera's model [1]
% Inputs:
%   user_Is: a P*1 vector containing different intensities for a user where
%            P is the number of products.
% Outputs:
%   p: the samples product
%
%**************************************************************************
% [1] Valera, Isabel, Manuel Gomez-Rodriguez, and Krishna Gummadi."Modeling
%     Diffusion of Competing Products and Conventions in Social Media."
%     NIPS Workshop in Networks. 2014.
% *************************************************************************
    u = rand()*sum(user_Is);
    sumIs = 0;
    for p=1:length(user_Is)
       sumIs = sumIs + user_Is(p);
       if sumIs >= u
           break;
       end
    end

end