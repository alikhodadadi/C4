% this script tries to predict the log likelihood of test events for real
% data
if ~(exist('batchTest','var') && batchTest == true)
    fclose all;
    clc;
    train_percent = 0.2;
end
disp('Competitive_Exp Evaluation Started...');
%% ------------ Add Required Folders to Path ----------------------%%
addpath(genpath(fullfile(pwd, 'Utility'   )), '-BEGIN');
addpath(genpath(fullfile(pwd)), 'Evaluation', 'CC', '-BEGIN');

%% ------------ Load Data ---------------------------%%
load(fullfile(pwd,'Data', [dataset '.mat'])); % load dataset
%% ------------ Load Learned Parameters -------------%%
load(fullfile(pwd, 'Results','Real', 'Inference',  ...
    [ dataset '_CC_results_beta_' num2str(data.beta) '_' num2str(train_percent) '.mat']));
%% ------------ Read Data ---------------------------%%
test_percent = 1;
num_event = round(test_percent*length(testdata.time));
data.adj = adj.*(1-eye(length(adj)))+ eye(length(adj)); % adjacency matrix of friendship network + self excitation
data.time = testdata.time(1:num_event) - testdata.time(1) ; % vector of event times
data.node = testdata.node(1:num_event); % vector of event nodes
data.prod = testdata.prod(1:num_event); % vector of event products

data.tmax = testdata.time(num_event);   % maximum time of events (i.e. T)
data.numprod = testdata.numprod;    % number of products
data.numuser = testdata.numuser; % number of users
data.beta = exp_coeff;

%% ------------ Calculate the Likelihood of Test Data ----------------%%
tic
[lglk] = Competitive_loglike(data, learned_a, learned_mu)./num_event;
toc
disp (lglk);