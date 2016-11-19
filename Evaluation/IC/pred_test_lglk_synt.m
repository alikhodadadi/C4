% this script tries to predict the log likelihood of test events
if ~(exist('batchTest','var') && batchTest == true)
    clear;
    fclose all;
    clc;
    fclose all;
    clc;
    %%Load Data
    net = 'core';
    sample = 1;
    train_percent = 0.2;
end
%% ------ Add Required Folders to Path----------------------%%
addpath(genpath(fullfile(pwd, 'Utility'   )), '-BEGIN');
addpath(genpath(fullfile(pwd)),'Evaluation','IC','-BEGIN');
disp('IC Evaluation Started...');

%% -------------- Load Data --------------------------------%%
load(fullfile(pwd, 'Data', 'Synth', 'Evaluation', [net 'synth_events.mat']));
testdata = compet_cascades{1};
%% -------------- Load Learned Parameters -------------------%%
file = fullfile(pwd,'Results','Synth', 'Inference', ...
        ['synth_IC_results_' num2str(net) '_sample' num2str(sample) '_' num2str(train_percent) '.mat']);
load(file);

%% ------------ Read Data --------------------------%%
num_event = 1*length(testdata.times);
adj = ceil(vmodel.a);
data.adj = adj; % adjacency matrix of friendship network
data.time = testdata.times(1:num_event);% vector of event times
data.node = testdata.nodes(1:num_event); % vector of event nodes
data.prod = testdata.products(1:num_event); % vector of event products

data.tmax = testdata.times(num_event);   % maximum time of events (i.e. T)
data.numprod = N_p;    % number of products
data.numuser = N_u; % number of users
data.beta = exp_coeff; % exp_coeff = 5

%% ---------- Calculate the Likelihood of Test Data ---------------%%
tic
[lglk] = Independent_loglike(data, learned_a, learned_mu)./num_event;
toc
disp (lglk);