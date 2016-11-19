function I = cp_intensity(i_model, events, t, n, w, g)
% This function calculates the intensity of each node at time t given n
% previous events, using Isabel Valera method [1].
% Inputs:
%   i_model: a model containing the a and \mu and structure
%   events: the set of events 
%   t: the time for which we want to calculate Intensity
%   n: the number of  first events we use to calculate the intensity in t
% Outputs:
%   I: a N*P matrix showing the intensity of nodes for each product at time
%      t. The i'th row shows the intensity of node i at time t for
%      different  products.
%**************************************************************************
% [1] Valera, Isabel, Manuel Gomez-Rodriguez, and Krishna Gummadi."Modeling
%     Diffusion of Competing Products and Conventions in Social Media."
%     NIPS Workshop in Networks. 2014.
%**************************************************************************

    if nargin < 4
       n = length(events.times); 
    end
    if nargin < 5
        w = 1;
    end
    if nargin < 6
       g = @(x,w) w*exp(-w*x);
    end
	I = i_model.mu;
	
    adj = i_model.structure;
    for i=n-20:n
        if(i>0)
            ui = events.nodes(i);
            ti = events.times(i);
            pi = events.products(i);
            u_neigbs = find(adj(:,ui));
            I(ui,:) = I(ui,:)+ transpose(i_model.a(:, pi, ui))*g(t-ti, w);
           for j=1:length(u_neigbs)
               I(u_neigbs(j), :) = I(u_neigbs(j), :) + transpose(i_model.b(:, pi, u_neigbs(j)))*g(t-ti, w);
           end
        end
    end
end
