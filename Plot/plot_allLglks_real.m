function  plot_allLglks_real( CC_lglks, IC_lglks, IV_lglks, num_events)
%
%   Detailed explanation goes here
% The CC_results and IC_results are n * 5 matrices that contain the sample
% results of different training percents for diffrent samples

CC_res = mean(CC_lglks, 1);
IC_res = mean(IC_lglks, 1);
IV_res = mean(IV_lglks, 1);

train_precents = (0.2:0.2:1);
X = round(train_precents * num_events);

figure;
plot(X, CC_res, X, IC_res, X, IV_res);
title('lglk');

%% saving the results

end

