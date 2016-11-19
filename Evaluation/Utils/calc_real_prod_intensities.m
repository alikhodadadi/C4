function [ intensities, event_counts] = calc_real_prod_intensities( data )
% This function seperates the time in to 1 hour bins and calculates the
% intensity of each products at each bin.
%Inputs:
%   data: a struct containing the events
%Output:
%   intensities: a matrix containing data.numprod columns each column shows
%       the intensity of respective product in different bins
%   event_counts: a matrix like the intensities, each cell of it shows the
%       total number of events of that product till the time of seleceted
%       bin.
num_prods = data.numprod;
hour = 1*3600000;%in mili seconds
T_beg = data.times(1);
T_end = data.times(end);

num_intvs = floor((ceil((T_end - T_beg)/hour)));
intensities  = zeros(num_intvs, num_prods);
event_counts = zeros(num_intvs+1, num_prods);
for i = 1:num_intvs
   % i
    t = T_beg + i * hour;
    ind = find(data.times < t);
    for p = 1:num_prods
        event_counts(i+1,p) = length(find(data.prods(ind)== p));
        intensities(i,p) = length(find(data.prods(ind)== p)) - event_counts(i,p); 
    end
end
end 

