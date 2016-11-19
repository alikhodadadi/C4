function events = ic_simulator_events(model, t0, N, w, g)
% This function generates N events, from t0, using the events history,
% using independent cascade model (IC). 
% Inputs:
%   model: a struct containing the model parameters.
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
    I =  HawkesIntensity(model, events, t, n, w, g);
    
    %calculate the overal intensity of each node
    u_Is = sum(I,2);

    sumI = sum(u_Is);
    
    t = t+exprnd(1./sumI);
    iter = iter + 1;
    if(mod(iter,100)==0) 
        disp(['(events so far:', num2str(n),', time so far:', num2str(t), ')']);
    end
    
 %   if(t>=T) 
 %       break;
 %   end

    Is = HawkesIntensity(model, events, t, n, w, g);
    sumIs = sum(sum(Is,2));

    u = rand();    
    if(u*sumI<sumIs)
        d = sample_user(Is);
        p = Indep_sample_product(Is(d,:)');
        if n == length(events.times)
            tmp = events.times;
            events.times = zeros(2*n);
            events.times(1:n) = tmp;
            tmp = events.nodes;
            events.nodes = zeros(2*n);
            events.nodes(1:n) = tmp;
            %
            tmp = events.products;
            events.products = zeros(2*n);
            events.products(1:n) = tmp;
        end
        n = n + 1;
        events.times(n) = t;
        events.nodes(n) = d;
        %
        events.products(n) = p;
    end
end
% events.times = events.times(1:n);
% events.nodes = events.nodes(1:n);
% events.products = events.products(1:n);

end
