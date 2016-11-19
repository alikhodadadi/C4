function s = logmulexp(a,b)
%LOGMULEXP        Matrix multiply in the log domain.
% logmulexp(a,b) returns log(exp(a)*exp(b)) while avoiding numerical underflow.
% The * is matrix multiplication.

% Written by Tom Minka
% (c) Microsoft Corporation. All rights reserved.

s = repmat(a,size(b,2),1) + kron(b',ones(size(a,1),1));
s = reshape(logsumexp(s,2),size(a,1),size(b,2));

%s = kron(a',ones(1,cols(b))) + repmat(b,1,rows(a));
%s = reshape(logsumexp(s),cols(b),rows(a))';
