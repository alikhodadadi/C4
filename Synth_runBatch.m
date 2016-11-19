%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------ Run Batch ------------------------------------
% This batch simulates the data and then calculates the metrics 
% -----------------------------------------------------------------
% Copyright by Ali Khodadadi and Zarezade, 
% khodadadi@ce.sharif.edu, zarezade@ce.sharif.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fclose('all');
close all
clear;
clc;
rng('default');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Add Required Folders to Path
addpath(genpath(fullfile(pwd, 'Utility'   )), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Simulation')), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Inference')), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Inference','ACVX')), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Evaluation')), '-BEGIN');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set the general parameters
N_u = 50;%number of users
N_p = 5;% number of products
N_events = 10000;
exp_coeff = 10;
sample_count = 2;
net = 'rand'; %{'hier', 'core'}
methods = {'CC', 'IC', 'CP'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate data
    % Create the model and generate events
    simulation_main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inference
    %%----------- Load data ---------------------------------------%%
    load(fullfile(pwd,'..' ,'Data', 'Synth', [net '_synth_events.mat']));
    %%----- Infers parameters from data for each method ------%%
    for method_id = 1:2
        methodName = methods{method_id};
        % Add to path the selected method
        addpath(genpath(fullfile(pwd, 'Inference', methodName)),'-BEGIN');
        for sample = 1: sample_count
            traindata = compet_cascades{c};
            for train_percent = 1:0.2:1
                batchTest = true;
                eval([methodName '_main_synth']);
            end
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Evaluation
    for method_id = 1:length(methods)
        methodName = methods{method_id};
        % Run the evaluation main
        Synth_eval_main;
    end
    % Testing incentivization
    incentivise_main
