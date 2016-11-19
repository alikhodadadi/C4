function  plot_allLglks_synt( CC_lglks_hire, CC_lglks_core, CC_lglks_rand, num_events)
%
%   Detailed explanation goes here
% The CC_results and IC_results are n * 5 matrices that contain the sample
% results of different training percents for diffrent samples

hier_res = mean(CC_lglks_hire, 1);
core_res = mean(CC_lglks_core, 1);
rand_res = mean(CC_lglks_rand, 1);

train_precents = (0.2:0.2:1);
X = round(train_precents * num_events);

figure;
plot(X, hier_res, X, core_res, X, rand_res);
title('lglk');

%% saving the results

end

