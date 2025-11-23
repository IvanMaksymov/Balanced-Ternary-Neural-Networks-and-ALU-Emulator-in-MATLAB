function y = ternarize(x, cutoff)
% TERNARIZE maps input x to ternary values -1, 0, 1
%   x can be a scalar, vector or matrix
%
%   Output:
%       y =  1 if x > cutoff
%       y = -1 if x < -cutoff
%       y =  0 otherwise

    POS1 = 1;
    ZERO = 0;
    NEG1 = -1;

    if nargin < 2
        disp('you did not provide cutoff -- it will be 0.1');
        cutoff = 0.1;
    end

    y = zeros(size(x));         % initialize output
    y(x > cutoff)  = POS1;        % positive zone
    y(x < -cutoff) = NEG1;        % negative zone
    % values between -0.1 and 0.1 remain ZERO
end

