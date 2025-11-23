function s = bt_sign(bt_str)
    % bt_str : balanced ternary number string (e.g., 'T0111')
    % s      : '1', '0', or 'T' representing sign
    for k = 1:length(bt_str)
        if bt_str(k) == '1'
            s = '1';
            return
        elseif bt_str(k) == 'T'
            s = 'T';
            return
        end
        % else, continue if '0'
    end
    s = '0';  % all zeros
end

