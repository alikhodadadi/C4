%% Load learned parameters
dataset = 'music3';
beta = 1;
%%--------- Load Learned Parameters -----------%%
    file = fullfile(pwd, '..' ,'Results','Real', [dataset '_real_CC_beta10e' num2str(beta) '_measures.mat']);
    load(file);
    
    CC_lglks = lglks;
    
    file = fullfile(pwd, '..' ,'Results','Real', [dataset '_real_IC_measures.mat']);
    load(file);
    
    IC_lglks = lglks;
    
%     file = fullfile(pwd, '..' ,'Results','Real', 'real_IV_measures.mat');
%     load(file);
%     
%     IV_lglks = lglks;
    
 %   num_events = 90000;
%%------------- Plotting the results -------------%%
%plot_allLglks_real( CC_lglks, IC_lglks, IV_lglks, num_events);
x = (.2:.2:1);
plot(x, [IC_lglks; CC_lglks]);
legend('CC', 'IC', 'IV');
xlabel('Number of Events');
ylabel('AvgPredLik');