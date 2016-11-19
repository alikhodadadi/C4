%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------ Isabel Valera Regularized Method ----------------------------
% 
% Copyright by Ali Khodadadi and Zarezade, 
% khodadadi@ce.sharif.edu, zarezade@ce.sharif.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script learnes the parameters of CP model for real data using train
% data and saves the results. It can be executed separately or is executed
% from the external runBatch.m 
% For any question please mail us.

if ~(exist('batchTest','var') && batchTest == true)
    clear;
    fclose all;
    clc;
    
    %% Add Required Folders to Path
    addpath(genpath(fullfile(pwd, '..', 'Utility'   )), '-BEGIN');
    addpath(genpath(fullfile(pwd, '..', 'Simulation')), '-BEGIN');
    addpath(genpath(fullfile(pwd, 'ACVX')), '-BEGIN');
    addpath(genpath(fullfile(pwd, 'CP')),'-BEGIN');

    %% Load Data
    load(fullfile(pwd, '..', 'Data', 'url.mat')); % twitter dataset


    train_percent = 0.8;
end

%% Print to the display
fprintf('++++++++++++++++++++++++++++++++++++++++++ \n');
fprintf('+      CP Method                         + \n');
fprintf('+      train_percent: %3.2f               + \n', train_percent);
fprintf('++++++++++++++++++++++++++++++++++++++++++ \n');


%% Read Data
num_event = floor(train_percent*length(traindata.time));
data.adj = adj.*(1-eye(length(adj)))+ eye(length(adj)); % adjacency matrix of friendship network
data.time = traindata.time(1:num_event)- traindata.time(1); % vector of event times
data.node = traindata.node(1:num_event); % vector of event nodes
data.prod = traindata.prod(1:num_event); % vector of event products

data.tmax = traindata.time(num_event);   % maximum time of events (i.e. T)
data.numprod = traindata.numprod;    % number of products
data.numuser = traindata.numuser; % number of users

%% Set Parameters
param.linesearch_a = 0.01;
param.linesearch_b = 0.1;
param.linesearch_t0 = 1;

param.newton_eps = 1e-3;
param.newton_maxitr = 25;

param.barrier_eps = 1e-5;
param.barrier_mu = 100;

%% Optimization 

learned_mu = zeros(data.numuser, data.numprod); % the vector of mus
learned_a  = zeros(data.numprod, data.numprod, data.numuser); % the vector of as
learned_b  = zeros(data.numprod, data.numprod, data.numuser); % the vector of as

optvals  = zeros(data.numuser,data.numprod); % the vector likelihood of optimal variables

P = data.numprod;
param.numcons = 2*P + 1;% number of inequality constrains of current user

% the optimization is done for each user separately

cp = gcp('nocreate');
 if(isempty(cp))
     %delete(gcp);
     parpool()
 end
parfor u =1:data.numuser
    ngbs_u = find(adj(u,:)); % neighbors of current user
    
    for p=1:P
    fprintf('\n ******** User: %d, Product: %d *******\n',u ,p);
    %%---- set the initial value of var (it should be in domain of f)----%%
    initvar = 1e-6*[1;ones(P,1); ones(P,1)];
    
    %%----doing the optimization for user u & product p----%%
    f_up = @(x,t) f(x,t,data,u,p);
    fgrad_up = @(x,t) fgrad(x,t,data,u,p);
    fhess_up = @(x,t) fhess(x,t,data,u,p);
    [optvar, optval] = barrier(initvar, f_up, fgrad_up, fhess_up, param);
    
    %%----stroing the results in vectors ----%%
    optvals(u, p) = optval; 
    learned_mu(u,p) = optvar(1);
    learned_a (p,:,u) = optvar(2:data.numprod+1);
    learned_b (p,:,u) = optvar(data.numprod+2:end);
    end
end

%%-----saving the results ------%%
if  ~(exist('batchTest','var') && batchTest == true)
    saveFile = fullfile(pwd, '..','Results','Inference',  ...
        [ dataset '_CP_results_' num2str(train_percent) '.mat']);
else
   saveFile = fullfile(pwd,'Results','Inference',  ...
        [ dataset '_CP_results_' num2str(train_percent) '.mat']);
end
save(saveFile, 'learned_a','learned_b','learned_mu', 'optvals');