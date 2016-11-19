function d = cp_sample_user(Is)
% This function samples a user from user population to make an event using
% Isabel Valera's model [1]
% Inputs:
%   Is: a N*P matrix, containing the product intensities for different users
% Outputs:
%   d: the sampled user to do event
%
%**************************************************************************
% [1] Valera, Isabel, Manuel Gomez-Rodriguez, and Krishna Gummadi."Modeling
%     Diffusion of Competing Products and Conventions in Social Media."
%     NIPS Workshop in Networks. 2014.
%**************************************************************************
    u_Is = sum(Is,2);   
    u = rand()*sum(u_Is);
    sumIs = 0;
    for d=1:length(u_Is)
       sumIs = sumIs + u_Is(d);
       if sumIs >= u
           break;
       end
    end

end