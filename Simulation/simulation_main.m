%This script tests the competiting model against independent to this end we
%generate a model and generate evnets from these two models.
clc;
%% Add Required Folders to Path
addpath(genpath(fullfile(pwd, 'Simulation', 'IC')), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Simulation', 'CC')), '-BEGIN');
%% Define some variables
sparsity = 0.3;
max_mu = 0.01;
max_a  = 0.1;
vmodel = ModelGenerator(N_u, N_p, sparsity, max_mu, max_a);
compet_cascades = cell(sample_count,1);
%% ++++++++++++ Load Synthetic Network ++++++++++++++++++++%%
file = fullfile(pwd, 'Data','Synth','Networks', [net '_kron.mat']);
load(file);

%% ++++++++++++ Changing the model parameters ++++++++++++%%    
n_adj = adj.*(1-eye(length(adj)))+ eye(length(adj));% self excitation
vmodel.a = n_adj.*rand(N);% generating a random influence matrix

%% ++++++++++++ Producing the events +++++++++++++++++++++%%
for c = 1:sample_count
   disp(['Generating csacade ', num2str(c)]);
   compet_cascades{c} = cc_simulator_events(vmodel, 0, N_events, exp_coeff);
end
%% ++++++++++++ Saving the results +++++++++++++++++++++%%
saveFile = fullfile(pwd,'Data', 'Synth', [net '_synth_events.mat']);
save(saveFile, 'compet_cascades', 'vmodel', 'exp_coeff', 'N_u', 'N_p', 'N_events');