function C = bt_matmul(A, B)
% BT_MATMUL_VEC Vectorized BT matrix multiplication
%   A, B: cell arrays of BT strings (e.g., {'T01', '1T0', ...})
%   C: cell array of BT strings, same size as A*B

    % Dimensions
    [m, n] = size(A);
    [n2, p] = size(B);
    if n ~= n2
        error('Inner matrix dimensions must agree.');
    end

    % Pre-convert A to numeric
    A_num = zeros(m, n);
    for i = 1:m
        for j = 1:n
            A_num(i,j) = bt2dec(A{i,j});
        end
    end

    % Pre-convert B to numeric
    B_num = zeros(n, p);
    for i = 1:n
        for j = 1:p
            B_num(i,j) = bt2dec(B{i,j});
        end
    end

    % Vectorized matrix multiplication
    C_num = A_num * B_num;

    % Convert back to BT strings
    C = cell(m, p);
    for i = 1:m
        for j = 1:p
            C{i,j} = dec2bt(C_num(i,j));
        end
    end
end

%function C = bt_matmul(A, B)
%    % A and B are cell arrays of BT strings (e.g. {'T01', '1T0', ...})
%    % C will be a cell array of BT strings.
%
%    % Check inner dimension
%    if size(A,2) ~= size(B,1)
%        error("Matrix dimensions do not agree.");
%    end
%
%    % Allocate output matrix
%    C = cell(size(A,1), size(B,2));
%
%    % Loop over output cells
%    for i = 1:size(A,1)
%        for j = 1:size(B,2)
%
%            % Start accumulator at BT zero
%            acc = '0';
%
%            % Dot product of row i and column j
%            for k = 1:size(A,2)
%                % Multiply two BT integers
%                prod_ij = bt_mul(A{i,k}, B{k,j});
%
%                % Accumulate (BT addition)
%                acc = bt_add(acc, prod_ij);
%            end
%
%            % Store result
%            C{i,j} = acc;
%
%        end
%    end
%end

