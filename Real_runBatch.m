%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------ Run Batch ------------------------------------
% This batch runs the mains for each method with different training 
% percents, and stores the results 
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
%% Initialize Parameters
dataset = 'music2';
methods = {'CC', 'IC', 'CP'};
exp_coeff = 10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Data
load(fullfile(pwd, 'Data', [dataset '.mat']));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inference
%%Infers the parameters from data for all methods
for method_id = 1%:length(methods)
    methodName = methods{method_id};
    for train_percent = 0.2%:0.2:1
        batchTest = true;
        data.beta = exp_coeff;
        % Ad to  the path the selected method
        addpath(genpath(fullfile(pwd, 'Inference', methodName)),'-BEGIN');
        eval([methodName '_main_real']);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Evaluation
    % First calculcate the test log likelihood
    Real_lglk_main;
    % Calculating the correlation measures
        % First, Generate the events
        Real_eventGen_main;
        % Second, Calc. the correlations
        Real_corr_main;
