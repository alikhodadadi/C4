function events = cp_simulator(i_model, t0, T,events, w, g)
% This function generates events, from t0 till T, using the events history,
% by cp method [1]. 
% Inputs:
%   i_model: a struct containing the model parameters of Isabel Valera
%   t0:     start time of simulation
%   T:  end time of simulation
%   events: a struct containig the events, if it be empty, the model
%       generates events from scratch, otherwise it uses the events as the
%       history
%
%
%**************************************************************************
% [1] Valera, Isabel, Manuel Gomez-Rodriguez, and Krishna Gummadi."Modeling
%     Diffusion of Competing Products and Conventions in Social Media."
%     NIPS Workshop in Networks. 2014.
%**************************************************************************
if nargin < 5
    w = 1;
end
if nargin < 6
   g = @(x,w) w*exp(-w*x);
end
if nargin < 4
    events = struct;
    init_size = 10000;
    events.times    = zeros(init_size,1);
    events.nodes    = zeros(init_size,1);
    events.products = zeros(init_size,1);
    n = 0;
else 
    n = length(find(events.times < t0));
end

t = t0;
iter = 0;
while t < T
    I = cp_intensity(i_model, events, t, n, w, g);
    % 
    I(I<0)=0;
    %%-- calculate the overal intensity of each node ---%%
    u_Is = sum(I,2);
    %%--- calculates the overall intensity    ---%%
    sumI = sum(u_Is);
    t = t + exprnd(1./sumI);
    iter = iter + 1;
    if(mod(iter,100)==0) 
        disp(['(iterations so far:', num2str(iter),', time so far:', num2str(t), ')']);
    end
    if(t>=T) 
        break;
    end
    Is = cp_intensity(i_model, events, t, n, w, g);
    Is(Is<0)=0;
    sumIs = sum(sum(Is,2)); 
    u = rand();    
    if(u*sumI<sumIs)
        d = cp_sample_user(Is);
        p = cp_sample_product(Is(d,:)');
        if n == length(events.times)
            tmp               = events.times;
            events.times      = zeros(2*n,1);
            events.times(1:n) =          tmp;
            
            tmp               = events.nodes;
            events.nodes      = zeros(2*n,1);
            events.nodes(1:n) =          tmp;
            %
            tmp                  = events.products;
            events.products      =    zeros(2*n,1);
            events.products(1:n) =             tmp;
        end        
        n = n + 1;
        events.times(n)    = t;
        events.nodes(n)    = d;
        events.products(n) = p;
    end
end
events.times    =    events.times(1:n);
events.nodes    =    events.nodes(1:n);
events.products = events.products(1:n);
end

