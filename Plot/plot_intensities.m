function   h  = plot_intensities(  method, events, model1, model2,  T_incentive, T_end, beta)
% This function plots the intensities for incentiviztion
if(isequal(method, 'IC'))
    [ I ] = ic_eval_intensity(events, model1, 0, T_incentive);
    inc_I = ic_eval_intensity(events, model2, T_incentive, T_end);
    I = [I, inc_I];
elseif(isequal(method, 'CC'))
    [ I ] = ic_eval_intensity(events, model1, 0, T_incentive);
    inc_I = cc_eval_intensity(events, model2, beta, T_incentive, T_end);
    I = [ I, inc_I];
end
%% Plotting the results
X = (1:T_end);
h = figure;
plot(X,I);


xlabel('Time');
ylabel('Product Intensity (\lambda^p(t))')

%legendNames = {'Product #1', 'Product #2', 'Product #3'};
legendNames = {'P#1', 'P#2', 'P#3'};
legend(legendNames,'Location','NorthWest')

if(isequal(method, 'IC'))
    title([method ' Model']);
    fileName = 'independent_intensity';
    file = fullfile(pwd,'Results','Synth','Incentive', fileName);
   
elseif((isequal(method, 'CC')))
    title([method ' Model, \beta = ' num2str(beta)]);
    fileName = ['dependent_intensity_b' num2str(100*beta)];
    file = fullfile(pwd,'Results','Synth','Incentive', fileName);
end
 print (h, '-depsc', '-r50', file);
 print (h, '-dpng', '-r150', file);
 saveas(h, file, 'fig'           );
end

