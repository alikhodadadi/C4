function  plot_allMAPE( CC_MAPEs_hier, CC_MAPEs_core, CC_MAPEs_rand, num_events)
%
%   Detailed explanation goes here
% The CC_results and IC_results are n * 5 matrices that contain the sample
% results of different training percents for diffrent samples

hier_res = mean(CC_MAPEs_hier, 1);
core_res = mean(CC_MAPEs_core, 1);
rand_res = mean(CC_MAPEs_rand, 1);

train_precents = (0.2:0.2:1);
X = round(train_precents * num_events);

figure;
plot(X, hier_res, X, core_res, X, rand_res);
title('MAPE');

%% saving the results

end