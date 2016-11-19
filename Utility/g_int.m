function y = g_int(x,w)
   if nargin == 1
       w = 1;
   end
   y = 1-exp(-w*x);
end

