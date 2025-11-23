function y = Softmax(v)
    ex = exp(v - max(v));
    y = ex / sum(ex);
end

%function y = Softmax(x)
%  ex = exp(x);
%  y  = ex / sum(ex);
%end
