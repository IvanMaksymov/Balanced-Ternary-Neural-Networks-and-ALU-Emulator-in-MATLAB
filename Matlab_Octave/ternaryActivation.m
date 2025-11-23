%% --- ternary activation ---
function y = ternaryActivation(v, tf)
    y = zeros(size(v));
    y(v > tf)  =  1;
    y(v < -tf) = -1;
end
