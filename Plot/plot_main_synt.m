%% Load learned parameters
%%--------- Load Learned Parameters -----------%%
    file = fullfile(pwd, '..' ,'Results','Synth', 'Evaluation', 'synth_CC_measures_hier.mat');
    load(file);
    
    CC_MSEs_hier = MSEs;
    CC_MAPEs_hier = MAPEs;
    CC_ranks_hier = ranks;
    CC_lglks_hier = lglks;
    
    file = fullfile(pwd, '..' ,'Results','Synth', 'Evaluation', 'synth_CC_measures_core.mat');
    load(file);
    
    CC_MSEs_core = MSEs;
    CC_MAPEs_core = MAPEs;
    CC_ranks_core = ranks;
    CC_lglks_core = lglks;
    
    file = fullfile(pwd, '..' ,'Results','Synth', 'Evaluation', 'synth_CC_measures_rand.mat');
    load(file);
    
    CC_MSEs_rand = MSEs;
    CC_MAPEs_rand = MAPEs;
    CC_ranks_rand = ranks;
    CC_lglks_rand = lglks;
    
    num_events = N_events;
%%------------- Plotting the results -------------%%
plot_allMSE ( CC_MSEs_hier,  CC_MSEs_core,  CC_MSEs_rand,  num_events);
plot_allMAPE( CC_MAPEs_hier, CC_MAPEs_core, CC_MAPEs_rand, num_events);
%plot_allRank( CC_ranks_hier, CC_ranks_core, CC_ranks_rand, num_events);
plot_allLglks_synt( CC_lglks_hier, CC_lglks_core, CC_lglks_rand, num_events);