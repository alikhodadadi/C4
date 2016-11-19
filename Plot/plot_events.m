function   plot_events( method, events, beta, T, U, P )
% This function plots the events for the incentivization
n_ints = T;
N_events = zeros(P, n_ints+1);
ratio_events = zeros(P, n_ints);
for i = 1:n_ints
    t = T*i/n_ints;
    ind1  = find(events.times <=t);
    for p = 1:P
        N_events(p,i+1) = length(find(events.products(ind1)== p));
        ratio_events(p,i) = length(find(events.products(ind1)== p))/length(ind1);
    end
end

%% Plotting the results
X = (0:T/n_ints:T);
h1 = figure; 
plot(X, N_events); 

xlabel('Time');
ylabel('Number of Events in [0,t)')
if(isequal(method, 'CC'))
    title([method ' Model, \beta = ' num2str(beta)]);
elseif(isequal(method, 'IC'))
    title([method ' Model']);
end

legendNames = {'P#1', 'P#2', 'P#3'};
legend(legendNames,'Location','NorthWest')

h2 = figure; 
plot(X(2:end), ratio_events ); 

xlabel('Time');
ylabel('The total ratio of product events in [0,t)')

if(isequal(method, 'CC'))
    title([method ' Model, \beta = ' num2str(beta)]);
elseif(isequal(method, 'IC'))
    title([method ' Model']);
end

legendNames = {'P#1', 'P#2', 'P#3'};
legend(legendNames,'Location','NorthWest')
if(isequal(method, 'IC'))    
    events_fileName = 'independent_events';
    events_file = fullfile(pwd, '..','Results','Synth','Incentive', events_fileName);
    
    ratio_fileName = 'independent_ratio';
    ratio_file = fullfile(pwd, '..','Results','Synth','Incentive', ratio_fileName);
elseif((isequal(method, 'CC')))
    events_fileName = ['dependent_events_b' num2str(100*beta)];
    events_file = fullfile(pwd, 'Results','Synth','Incentive', events_fileName);
    
    ratio_fileName = ['dependent_ratio_b' num2str(100*beta)];
    ratio_file = fullfile(pwd, 'Results','Synth','Incentive', ratio_fileName);
end
 print(h1, '-depsc', '-r50', events_file);
 print(h1, '-dpng', '-r150', events_file);
 saveas(h1, events_file, 'fig');

 print(h2, '-depsc', '-r50', ratio_file);
 print(h2, '-dpng', '-r150', ratio_file);
 saveas(h2, ratio_file, 'fig');
end

