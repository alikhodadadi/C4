%% This script calculates correlation measures over generated data
%% ---------- Add Required Folders to Path -------------------------%%
addpath( genpath(fullfile(pwd, 'Evaluation', 'Utils' )), '-BEGIN');

%% ---------- Define the variables ----------------------------------%%
prod_num = N_p;
user_num = N_u;

prod_corrs = zeros(3, prod_num);
prod_norms = zeros(3, prod_num);
user_corrs = zeros(3,1);
user_norms = zeros(3,1);
for sample = 1:sample_count;
    %% +++++++++++++ Load Data ++++++++++++++++++++++%%
    %  ------------- Load Real Data -----------------%%
    file = fullfile(pwd, 'Data','Real', [dataset '.mat'] );
    load(file);
    data = testdata;
    data.products = testdata.prod;
    data.times = testdata.time;
    data.users = testdata.user;
    %  ------------- Load CC_gen data ---------------%%
    file = fullfile(pwd, 'Data', 'Real','Evaluation', ...
        [dataset '_CC_gen_events_beta' num2str(beta) '_sample_' num2str(sample) '.mat']);
    load(file);
    CC_events.numprod = prod_num;
    CC_events.numuser = user_num;
    %  ------------- Load IC_gen data ----------------%%
    file = fullfile(pwd,  'Data', 'Real','Evaluation', ...
        [dataset '_IC_gen_events_sample_' num2str(sample) '.mat']);
    load(file);
    IC_events.numprod = prod_num;
    IC_events.numuser = user_num;
    %  ------------- Load CP_gen data -----------------%%
    file = fullfile(pwd, 'Data', 'Real','Evaluation', ...
        [dataset '_CP_gen_events_sample_' num2str(sample) '.mat']);
    load(file);
    CP_events.numprod = prod_num;
    CP_events.numuser = user_num;

    %% +++++++++++++ Calc Correlations for products +++++++++++%%
    real_ints = calc_real_prod_intensities( data      );
    CC_ints   = calc_real_prod_intensities( CC_events );
    IC_ints   = calc_real_prod_intensities( IC_events );
    CP_ints   = calc_real_prod_intensities( CP_events );   
    for i = 1:prod_num
        prod_corrs(1, i) = corr(real_ints(:,i), CC_ints(:,i));
        prod_corrs(2, i) = corr(real_ints(:,i), IC_ints(:,i));
        prod_corrs(3, i) = corr(real_ints(:,i), CP_ints(:,i));
        
        prod_norms(1, i) = mean(abs(real_ints(:,i)- CC_ints(:,i)));
        prod_norms(2, i) = mean(abs(real_ints(:,i)- IC_ints(:,i)));
        prod_norms(3, i) = mean(abs(real_ints(:,i)- CP_ints(:,i)));

    end
    %% +++++++++++++ Calc Correlation for users +++++++++++++++%%
    real_users = calc_real_user_intensities( data      );
    CC_users   = calc_real_user_intensities( CC_events );
    IC_users   = calc_real_user_intensities( IC_events );
    CP_users   = calc_real_user_intensities( CP_events );
    
    user_corrs(1) = corr(sum(real_users,2), sum(CC_users,2));
    user_corrs(2) = corr(sum(real_users,2), sum(IC_users,2));
    user_corrs(3) = corr(sum(real_users,2), sum(CP_users,2));
        
    user_norms(1) = mean(abs(sum(real_users,2)-sum(CC_users,2)));
    user_norms(2) = mean(abs(sum(real_users,2)-sum(IC_users,2)));
    user_norms(3) = mean(abs(sum(real_users,2)-sum(CP_users,2)));

    %% ------ Create results to be saved -------------------%%
    % prods_measures is a 3*2*prod_num matrix which stores for each product
    % the correlation and l1 distance for each of methods. The rows show
    % the results for CC, IC, and CP methods respectively. The first column
    % is the corr results and the second column is the l1 distance results.
    prods_measures = zeros(3,2,prod_num);
    for i =1:prod_num
        prods_measures(:,1,i) = prod_corrs(:,i);
        prods_measures(:,2,i) = prod_norms(:,i);
    end
    users_musures = [user_corrs, user_norms];
    %% --------------- Save  the Results --------------------%%
    saveFile =  fullfile(pwd,  'Results','Real','Evaluation', ...
        [dataset '_real_corr_measures_sample' num2str(sample) '.mat'] );
    save(saveFile, 'prods_measures','users_measures');
end