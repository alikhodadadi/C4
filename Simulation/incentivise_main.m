%This script evaluates the competiting model against independent for incentivization.
%to this end we generate a model and generate evnets from these two models.
clc;
%% ------------- Add Required Folders to Path ------------------------%%
addpath(genpath(fullfile(pwd, 'Simulation','IC')), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Simulation','CC')), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Plot'   )), '-BEGIN');
%% ------------- define variables ----------------------------------- %%
N_u = 5;
N_p = 3;
sparsity = 0.3;
max_mu = 0.01;
max_a  = 0.1 ;
vmodel = ModelGenerator(N_u, N_p, sparsity, max_mu, max_a);
vmodel.mu = zeros(N_u,3); % setting the mu
vmodel.mu(:,1) = vmodel.mu(:,1) + 0.2;
vmodel.mu(:,2) = vmodel.mu(:,2) + 0.5;
vmodel.mu(:,3) = vmodel.mu(:,3) + 0.3;

%% ------------- Setting the parameters ------------------------------ %%
betas = [0.1, 1, 10, 100];
T_incentive = 100;
T_end = 200;
itr_count = 1;
synthetic_events = cell(itr_count, 4);
for itr = 1:itr_count
    rng(0, 'twister');
    %%++++++++++( Changing the desired product parameters )+++++++%%
    n_vmodel = vmodel;
    n_vmodel.mu(:,3) = n_vmodel.mu(:,3) * 2;

    %%+++++++++( Producing the events of the competitive model )+++++%%
    for j = 1:length(betas)
        %rng(0, 'twister');
        beta =  betas(j);
        burnin_events = cc_simulator(vmodel, 0, T_incentive, beta);
        compet_events = cc_simulator(n_vmodel, T_incentive, T_end, beta, burnin_events);
        synthetic_events{itr, j} = compet_events;
        
        plot_events( 'CC', compet_events, beta, T_end, N_u, N_p );
        plot_intensities( 'CC', compet_events, vmodel, n_vmodel, T_incentive, T_end, beta );
    end
    
    %%++++++++++( Producing the events of the independent model )++++++%%
    %rng(0, 'twister'); 
    burnin_events = ic_simulator(vmodel, 0, T_incentive);
    indep_events = ic_simulator(n_vmodel, T_incentive, T_end, burnin_events);
    synthetic_events{itr, 5} = indep_events;    
    
     plot_events( 'IC',  indep_events, beta, T_end, N_u, N_p );
     plot_intensities(  'IC',  indep_events, vmodel, n_vmodel, T_incentive, T_end, beta );
end