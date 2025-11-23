%% --- STE derivative ---
function dy = ternaryDerivative(v)
    % Straight-Through Estimator (gradient = 1 in [-1,1])
    dy = double(abs(v) <= 1);
end
