%% Intensity of Correlated Cascades Model
% This function calculates the intensity of each user at time t given n
% previous events in the CC model.
%
% *Inputs*:
%   model: a model containing the a and $$\mu$$ and structure
%   events: the set of events 
%   t: the time for which we want to calculate Intensity
%   n: the number of  first events we use to calculate the intensity at t
%
% *Outputs*:
%   I: a N*P matrix showing the intensity of nodes for each product at time
%      t. The i'th row shows the intensity of node i at time t for
%      different  products.

function I = cc_intensity(model, events, t, n, w, g)
    if nargin < 4
       n = length(events.times); 
    end
    if nargin < 5
        w = 1;
    end
    if nargin < 6
       g = @(x,w) w*exp(-w*x);
    end
	I = model.mu;
    for i= n-20:n
        if i>0
            ui = events.nodes(i);
            ti = events.times(i);
            pi = events.products(i);
            I(:,pi) = I(:,pi) + model.a(:,ui)*g(t-ti, w);
        end
    end
end
