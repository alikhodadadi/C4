function [ I ] = ic_eval_intensity(events, model, t0, T, w, g)
if nargin < 4
   T = ceil(max(events.times));
end
if nargin < 5
   w = 1;
end
if nargin < 6
   g = @(x,w) w*exp(-w*x);
end


I = repmat(sum(model.mu)', 1,T-t0);
size(I)
P = model.products;

for t = t0+1:T
    n = length(find(events.times <=t));
    Ints = sum(cc_intensity(model, events, t, n, w, g));
    I(:,t-t0) = Ints';
end
end