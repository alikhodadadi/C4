
%% ------- Add Required Folders to Path ---------------%%
addpath(genpath(fullfile(pwd, 'Utility'   )), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Simulation')), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Evaluation', 'Utils'   )), '-BEGIN');
methodNames = {'CC', 'IC', 'IV'};
%% --------- Calculating the average test lglk ------------%%%
for methodIdx = 1: length(methodNames)
    method = methodNames{methodIdx};
    addpath(genpath(fullfile(pwd,'Evaluation', method )), '-BEGIN');
    lglks = zeros(1, 5);
    batchTest = true;
    
    for train_percent = 0.2:0.2:1
        %%++++ Pred. Test events likelihood +++++++++++%%
       % addpath(genpath(fullfile(pwd,'Evaluation', method )), '-BEGIN');
        batchTest = true;
        pred_test_lglk_real;
        tr_Idx = round(train_percent/.2);
        lglks( tr_Idx) = lglk;
    end
    %%++++++++++++ Saving the results +++++++++++++++++++++++++++++++++++%%
    if(isequal(method, 'CC'))
        file = fullfile(pwd, 'Results','Real', [dataset '_real_' method '_beta' num2str(beta) '_loglk_measures.mat']);
    else
        file = fullfile(pwd, 'Results','Real', [dataset '_real_' method '_loglk_measures.mat']);
    end
    save(file, 'lglks');
end
