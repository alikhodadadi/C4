function y = g(x,w)
   if nargin == 1
       w = 1;
   end
   y = w*exp(-w*x);
end

