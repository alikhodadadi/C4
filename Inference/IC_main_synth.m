%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------ Independent Cascade Model ----------------------------
% 
% Copyright by Ali Khodadadi and Zarezade, 
% khodadadi@ce.sharif.edu, zarezade@ce.sharif.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script learnes the parameters of IC model for synthetic data using train
% data and saves the results. It can be executed separately or is executed
% from the external runBatch.m 
% For any question please mail us.

if ~(exist('batchTest','var') && batchTest == true)
    clear;
    fclose all;
    clc;
    disp('Independent Method Started...');

    %% Add Required Folders to Path
    addpath(genpath(fullfile(pwd, '..', 'Utility'   )), '-BEGIN');
    addpath(genpath(fullfile(pwd, '..', 'Simulation')), '-BEGIN');
    addpath(genpath(fullfile(pwd, 'ACVX')), '-BEGIN');
    addpath(genpath(fullfile(pwd, 'IC')),'-BEGIN');
    
    %% Load Data
    net = 'hier';
    file = fullfile(pwd, '..', 'Data', 'Synth',  [net '_synth_events.mat']);
    load(file);
    
    sample = 1;
    traindata = compet_cascades{sample}; 
    adj = ceil(vmodel.a);
    train_percent = 0.1;
    data.beta = 5; % the parameter of exponential
end

%% Print to the display
fprintf('++++++++++++++++++++++++++++++++++++++++++ \n');
fprintf('+   Independent Method                   + \n');
fprintf('+   train_percent: %3.2f                  + \n', train_percent);
fprintf('++++++++++++++++++++++++++++++++++++++++++ \n');

%% Read Data
num_event = floor(train_percent*length(traindata.times));
data.adj = adj;
data.time = traindata.times(1:num_event)- traindata.times(1); % vector of event times
data.node = traindata.nodes(1:num_event); % vector of event nodes
data.prod = traindata.products(1:num_event); % vector of event products

data.tmax = traindata.times(num_event);   % maximum time of events (i.e. T)
data.numprod =  5;    % number of products
data.numuser = 64; % number of users

%% Optimization 
learned_mu = zeros(data.numuser, data.numprod); % the vector of mus
learned_a = zeros(data.numuser, data.numuser); % the vector o alphas
optvals = zeros(data.numuser,1); % the vector likelihood of optimal variables

% the optimization is done for each user separately
P = data.numprod;
d_adj = data.adj;

%  cp = gcp('nocreate');
%   if(isempty(cp))
%       %delete(gcp);
%       gcp();
%   end
for u =1:data.numuser
    fprintf('\n ******** User: %d *******\n',u);
    ngbs_u = find(d_adj(u,:)); % neighbors of current user
    
    %%-- Set Parameters
    param = struct;
    param.linesearch_a = 0.01;
    param.linesearch_b = 0.1;
    param.linesearch_t0 = 1;

    param.newton_eps = 1e-3;
    param.newton_maxitr = 25;

    param.barrier_eps = 1e-4;
    param.barrier_mu = 100;
    param.numcons = P + length(ngbs_u);  % number of inequality constrains of current user

    %%---- set the initial value of var (it should be in domain of f)----%%
    initvar = 1e-2*[ones(P,1); ones(length(ngbs_u),1)];
    
    %%----doing the optimization for user u ----%%
    f_u = @(x,t) f(x,t,data,u);
    fgrad_u = @(x,t) fgrad(x,t,data,u);
    fhess_u = @(x,t) fhess(x,t,data,u);
    [optvar, optval] = barrier(initvar, f_u, fgrad_u, fhess_u, param);
    
    %%----stroing the results in vectors ----%%
    optvals(u) = optval; 
    learned_mu(u,:) = optvar(1:data.numprod);
    a_u = zeros(1,data.numuser);
    a_u (ngbs_u) =  optvar(data.numprod+1:end);
    learned_a (u,:) = a_u;
end

%%-----saving the results ------%%
if  ~(exist('batchTest','var') && batchTest == true)
    saveFile = fullfile(pwd, '..','Results','Synth', 'Inference', ...
        ['synth_IC_results_' num2str(net) '_sample' num2str(sample) '_' num2str(train_percent) '.mat']);
else
    saveFile = fullfile(pwd,'Results','Synth', 'Inference', ...
        ['synth_IC_results_' num2str(net) '_sample' num2str(sample) '_' num2str(train_percent) '.mat']);
end
save(saveFile, 'learned_a','learned_mu', 'optvals', 'data', 'param');
