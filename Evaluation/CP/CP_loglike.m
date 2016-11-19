function [ lglk ] = Valera_loglike( data, a, b, mu)
%This function calculated the likelihood of data using a , b , mu
%parameters
%   

P = data.numprod;
U = data.numuser;

%matlabpool ('open',2);
lglk = 0;
for u = 1: U
    disp('%%+++++++ valera +++++%%');
    disp(u);
    for p = 1:P
        mu_up = mu(u, p);
        a_up = a(p,:,u);
        b_up = b(p,:,u);
        lglk = lglk + Valera_partial_loglike(data, mu_up, a_up, b_up, u, p);
    end
end
%matlabpool close;
end

