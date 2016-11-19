function model = cp_model_generator(N, P, sp, max_mu, max_a, max_b)
% The model generator which generates the parameter of  Isabel Valera model
% [1]
% inputs:
%   N: number of nodes
%   P: number of products
%   sp: the sparsity of the network (default = 0.1)
%   max_mu: the exogenous (baseline) intensity are sampled uniformly
%       on [0 max_mu) (default = 0.1)
%   max_a: the mutualy-exciting parameters for the past events of every
%   node,are sampled  uniformly on [0 max_a) (default = 0.1) max_b: the
%   mutualy-exciting parameters for the past events of neighbors, are
%   sampled  uniformly on [0 max_a) (default = 0.1)
% outputs:
%   a struct model contating follwing fields:
%       nodes: number of nodes
%       edges: number of edges
%       mu: exogenous (baseline) intensity
%       a: mutuually-exciting coefficients, showing the influence of
%          usage of a product by a user on his intensity 
%       b: mutuually-exciting coefficients, showing the influence of
%          usage of a product by neighbors of a user on his intensity
%
%**************************************************************************
% [1] Valera, Isabel, Manuel Gomez-Rodriguez, and Krishna Gummadi."Modeling
%     Diffusion of Competing Products and Conventions in Social Media."
%     NIPS Workshop in Networks. 2014.
%**************************************************************************

if nargin < 2
    disp('usage: cp_model_generator(N, P, sp, max_mu, max_a, max_b)');
    return;
end
if nargin < 3
    sp = 0.1;
end
if nargin < 4
    max_mu = 0.1;
end
if nargin < 5
    max_a = 0.1;
end
if nargin < 6
    max_b = 0.1;
end
model = struct;
model.nodes =  N;
model.products = P;%number of products
model.mu = rand(N, P) * max_mu;
% construct the a and b matrixes
model.a = rand(P, P, N).* max_a;
model.b = rand(P, P, N).* max_b;
% sampling edges
M = floor(sp * N^2);
edges = rand(M,2);
edges(:,1:2) = ceil(N*edges(:,1:2));
model.structure = zeros(N ,N);
for m = 1 : M
    model.structure(edges(m, 1), edges(m, 2)) = 1;
end
end


