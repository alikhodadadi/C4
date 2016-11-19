%%This script learns the parameter for synthetic data, then calculcate the
%%test log likelihood and othre measures to evaluate the performance of
%%different methods.
%% Add Required Folders to Path
addpath(genpath(fullfile(pwd,  'Utility'   )), '-BEGIN');
addpath(genpath(fullfile(pwd,  'Simulation')), '-BEGIN');
addpath(genpath(fullfile(pwd,  'Inference')), '-BEGIN');
addpath(genpath(fullfile(pwd,  'Inference', 'ACVX')), '-BEGIN');
addpath(genpath(fullfile(pwd,  'Inference', methodName)),'-BEGIN'); 
addpath(genpath(fullfile(pwd,  'Evaluation', 'Utils'   )), '-BEGIN');
%addpath(genpath(fullfile(pwd, 'Evaluation', 'CC')),'-BEGIN');

%% ------- LEARNING THE PARAMETERS FOR THE SELECTED METHOD ---------------%%    
    %%+++++++++++ Load Synthetic Data +++++++++++++++++++++%%
    file = fullfile(pwd, 'Data', 'Synth', 'Evaluation', [net '_synth_events.mat']);
    load(file);
    %%++++++++++++ Define variabels +++++++++++++++++++++++%%
    adj = ceil(vmodel.a);
    data.beta = exp_coeff;
    MSEs  = zeros( sample_count, 5);
    MAPEs = zeros( sample_count, 5);
    lglks = zeros( sample_count, 5);
    
    for sample = 1:sample_count
        traindata = compet_cascades{sample};
        for train_percent = 0.2:0.2:1
            %%++++++ Learn Parameters (do inference) +++++++++%%
            batchTest = true;
            eval([methodName '_main_synth']);
            
            %%+++ CALCULATING THE METRICS (LGLIKELIHOOD, MSE, MAPE, RANK)++
            %----------- Calc Errors ----------------%%
            idx = round(train_percent/0.2);
            MSEs   (sample, idx) = calc_mse ( vmodel.a, vmodel.mu, learned_a, learned_mu );
            MAPEs  (sample, idx) = calc_mape( vmodel.a, vmodel.mu, learned_a, learned_mu );
            %---------- Calc lglks -------------------%%
            pred_test_lglk_synt; %the script that calculates the average log likelihood per event
            lglks(sample, idx) = lglk;
        end
        %---------( save the results )--------------------%%
        file = fullfile(pwd, 'Results','Synth', 'Evaluation', ...
            ['synth_' methodName '_measures_ ' num2str(net) '_sample' num2str(sample) '.mat']);
        save(file, 'MSEs', 'MAPEs', 'lglks', 'N_events', 'exp_coeff');
    end  