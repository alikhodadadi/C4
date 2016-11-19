%% Model Generator of Hawkes Method
% This function creates a model containing the |a| and $\mu$ matrices to be
% used in Hawkes model to generate events
% INPUTS:
%   N: number of nodes
%   P: number of products
%   sp: the sparsity of the network (default = 0.1)
%   max_mu: the exogenous (baseline) intensity are sampled uniformly
%       on [0 max_mu) (default = 0.1)
%   max_a: the mutualy-exciting parameters are sampled  uniformly on [0
%        max_a) (default = 0.1)
%   stationary: if it is 1 then model.a is scaled down to force the process
%       to be stationary (default = 1)
% outputs:
%   a struct model contating follwing fields:
%       nodes: number of nodes
%       edges: number of edges
%       mu: exogenous (baseline) intensity
%       a: mutuually-exciting coefficients, the ith shows the influence of
%       node i on other nodes.
%       outnetwork: A cell containing outgoing edges from each node
%       innetwork: A cell containing incomming edges to each node

function model = ModelGenerator(N, P, sp, max_mu, max_a, stationary)
if nargin < 2
    disp('usage: modelGenerator(N, max_mu, max_a, sp, stationary)');
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
    stationary = 1;
end

model = struct;
model.nodes =  N;
model.products = P;%number of products

model.mu = rand(N, P) * max_mu;
model.a = sparse(N, N);
model.outnetwork = cell(N,1);
model.innetwork = cell(N,1);

% sampling edges
M = floor(sp * N^2);
edges = rand(M,3);
edges(:,1:2) = ceil(N*edges(:,1:2));
for m = 1 : M
    model.a(edges(m, 1), edges(m, 2)) = max_a * edges(m, 3);
end

% connectivity structure
model.edges = 0;
for n=1:N
    model.outnetwork{n} = find(model.a(:,n) ~= 0);
    model.edges = model.edges + length(model.outnetwork{n});
    model.innetwork{n} = find(model.a(n,:) ~= 0)';
end

% forcing the process to be stationary
if stationary
    egs = eigs(model.a);
    if abs(egs(1)) > 1
        model.a = model.a * rand() / egs(1);
    end
end

end


