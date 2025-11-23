function [M, IM] = bt_max(X)
    % bt_max: balanced ternary equivalent of [M, IM] = max(X)
    %
    % X – cell array of BT strings (e.g. {'T01','1','0',...})
    % M – max value in decimal
    % IM – index (row index for column vectors)
    %
    % Uses the existing bt2dec().

    % --- Convert BT cell array to decimal array ---
    [r, c] = size(X);
    Mdec = zeros(r, c);

    for i = 1:r
        for j = 1:c
            Mdec(i,j) = bt2dec(X{i,j});
        end
    end

    % --- Delegate to built-in max ---
    if nargout == 1
        M = max(Mdec);
    else
        [M, IM] = max(Mdec);
    end
end

