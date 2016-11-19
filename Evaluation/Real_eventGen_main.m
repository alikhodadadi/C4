%%This script generates events using learned parameter from each model 
%%and then calculates the ranks
clc;

%% -------------- Add Required Folders to Path -------------------------%%
addpath( genpath(fullfile(pwd,'Simulation' )), '-BEGIN');
%% -------------- Load Test Data ---------------------------------------%% 
file = fullfile(pwd, 'Data', [ dataset '.mat']);
load(file); 
T_end = testdata.time(end) - testdata.time(1);
N = testdata.numuser;
P = testdata.numprod;
data = testdata;
data.time = testdata.time - testdata.time(1);
data.time(1)
train_percent = 1;
data.beta = exp_coeff;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ %
% +                 GENEARTE EVENTS                              + %
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:sample_count
%% +++++++++++++++++++++++ CC +++++++++++++++++++++++++++++++++++ %%
%%
    fprintf('%% -------- CC events generation started --------%%\n')
    % ------------ Load learned parameters ------------------ %    
    file = fullfile(pwd, 'Results','Real', 'Inference',  ...
    [ dataset '_CC_results_beta_' num2str(data.beta) '_' num2str(train_percent) '.mat']);
    load(file);

    % ------------ Create the model ------------------------- %
    model = struct;
    model.nodes =  N;
    model.products = P;%number of products
    model.mu = learned_mu;
    model.a = learned_a;
    beta = exp_coeff;        
    % ------------- Generate events ------------------------- %
  %  rng(0, 'twister');
    CC_events = cc_simulator(model, 0, T_end, beta);
    % ------------- Save events     ------------------------- %
    saveFile = fullfile(pwd, 'Data', 'Real','Evaluation', ...
    [dataset '_CC_gen_events_beta' num2str(beta) '_sample_' num2str(i) '.mat']);
    save(saveFile, 'CC_events', 'T_end', 'N', 'P');

%% ++++++++++++++++++++++++++++ IC ++++++++++++++++++++++++++++++++++%%
%% 
    fprintf('%% -------- IC events generation started --------%%\n')
    % ------------ Load learned parameters ------------------ % 
    file = fullfile(pwd, 'Results','Real', 'Inference',  ...
    [ dataset '_IC_results_' num2str(train_percent) '.mat']);
    load(file);

    % ------------ Create the model ------------------------- %
    model = struct;
    model.nodes =  N;
    model.products = P;%number of products
    model.mu = learned_mu;
    model.a = learned_a;
    % ------------- Generate events ------------------------- %
   % rng(0, 'twister');
    IC_events = IC_simulator( model, 0, T_end);
    
    % ------------- Save events     ------------------------- %
    saveFile = fullfile(pwd, 'Data', 'Real', 'Evaluation', ...
        [dataset '_IC_gen_events_sample_' num2str(i) '.mat']);
    save(saveFile, 'IC_events', 'T_end', 'N', 'P');

%% ++++++++++++++++++++++++++++ CP ++++++++++++++++++++++++++++++++++%%
%% 
    fprintf('%% -------- CP events generation started --------%% \n')
    % ------------ Load learned parameters ------------------ %
    file = fullfile(pwd, 'Results','Real', 'Inference',  ...
    [ dataset '_CP_results_' num2str(train_percent) '.mat']);
    load(file);
    % ------------ Create the model ------------------------- %
    i_model           =     struct;
    i_model.nodes     =          N;
    i_model.products  =          P;
    i_model.mu        = learned_mu;
    i_model.a         =  learned_a;
    i_model.b         =  learned_b;
    i_model.structure =        adj;
    % ------------- Generate events ------------------------- %
    rng(0, 'twister');
    CP_events = CP_simulator(i_model, 0, T_end);
    % ------------- Save events     ------------------------- %
    saveFile = fullfile(pwd, 'Data', 'Real','Evaluation', ...
        [dataset '_CP_gen_events_sample_' num2str(i) '.mat']);
    save(saveFile, 'CP_events', 'T_end', 'N', 'P');
end