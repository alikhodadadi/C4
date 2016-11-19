function [ I ] = cc_eval_intensity(events, model, beta, t0, T,  w, g)
if nargin < 5
   T = ceil(max(events.times));
end
if nargin < 6
   w = 1;
end
if nargin < 7
   g = @(x,w) w*exp(-w*x);
end

I = repmat(sum(model.mu)', 1,T-t0);
P = model.products;
for t = t0+1:T
    n = length(find(events.times <=t));
    lambs = cc_intensity(model, events, t, n, w, g);
    Ints = repmat(sum(lambs,2),1,P).*(exp(beta*lambs)./repmat(sum(exp(beta*lambs),2),1,P));
    I(:,t-t0) = sum(Ints)';
end
end