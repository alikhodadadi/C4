function events = cp_simulator_events(i_model, t0, N, w, g)
% This function generates N events, from t0, using the events history,
% by cp method [1]. 
% Inputs:
%   i_model:a struct containing the model parameters of Isabel Valera
%   t0:     start time of simulation
%   N:      number of events to be simulated
%   events: a struct containig the events, if it be empty, the model
%       generates events from scratch, otherwise it uses the events as the
%       history
% Outputs:
%   events: the struct containing the time, user, and products of generated
%           events.
%
%**************************************************************************
% [1] Valera, Isabel, Manuel Gomez-Rodriguez, and Krishna Gummadi."Modeling
%     Diffusion of Competing Products and Conventions in Social Media."
%     NIPS Workshop in Networks. 2014.
%**************************************************************************

if nargin < 4
    w = 1;
end
if nargin < 5
   g = @(x,w) w*exp(-w*x);
end
events = struct;
events.times    = zeros(N,1);
events.nodes    = zeros(N,1);
events.products = zeros(N,1);

t = t0;
iter = 0;
n = 0;
while n < N
    I = cp_intensity(i_model, events, t, n, w, g);
    % 
    I(I<0)=0;
    %%--- calculate the overal intensity of each node --%%
    u_Is = sum(I,2);
    %%--- calculates the overall intensity      --%
    sumI = sum(u_Is);
    t = t+exprnd(1./sumI);
    iter = iter + 1;
    if(mod(iter,100)==0) 
        disp(['(iterations so far:', num2str(iter),', time so far:', num2str(t), ')']);
    end 
    Is = cp_intensity(i_model, events, t, n, w, g);
    Is(Is<0)=0;
    sumIs = sum(sum(Is,2));
    u = rand();    
    if(u*sumI<sumIs)
        d = cp_sample_user(Is);
        p = cp_sample_product(Is(d,:)');    
        n = n + 1;
        events.times(n) = t;
        events.nodes(n) = d;
        events.products(n) = p;
    end
end
end

