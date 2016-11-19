
%% This script converts the textfile to mat matrices
%filename = 'rand_kron.txt';
filename = 'core_kron.txt';
A = importdata(filename);
data = A.data;
data = data +1;


M = 64%max(max(data(:,1)),max(data(:,2)));
adj = sparse(data(:,2),data(:,1),1,M,M);
adj = full(adj);