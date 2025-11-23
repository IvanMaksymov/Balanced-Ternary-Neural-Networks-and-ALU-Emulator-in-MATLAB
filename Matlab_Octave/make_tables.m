function tables = make_tables()

    % Characters are used for direct lookup
    digits = {'T','0','1'};

    % ----- ADDITION -----
    add_tab = {
        %   T     0     1     (column)
        'T1', 'T', '0';  % row T
        'T', '0', '1';  % row 0
        '0', '1', '1T'  % row 1
    };

    % ----- SUBTRACTION -----
    sub_tab = {
        %   T      0      1
        '0',   'T',   'T1';   % T -
        '1',   '0',   'T';    % 0 -
        '1T',  '1',   '0'     % 1 -
    };

    % ----- MULTIPLICATION -----
    mul_tab = {
        %   T     0     1
        '1',  '0',  'T';  % row T
        '0',  '0',  '0';  % row 0
        'T',  '0',  '1'   % row 1
    };

    % ----- DIVISION -----
    div_tab = {
        %   T    1
        '1', 'T';   % T /
        '0', '0';   % 0 /
        'T', '1'    % 1 /
    };

    tables.add = add_tab;
    tables.sub = sub_tab;
    tables.mul = mul_tab;
    tables.div = div_tab;
    tables.digits = digits;
end
