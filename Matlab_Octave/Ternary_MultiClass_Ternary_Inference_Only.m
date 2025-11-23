clc; clear; close all;

warning('off', 'all');

load allvars_ternaryNN_no_bias.h5

N_test = 10;%shorter test, < 800

% Forward pass (fully ternary)
tW1 = ternarize(W1, tf);
tW2 = ternarize(W2, tf);
tW3 = ternarize(W3, tf);

%% =======================
% Decimal inference
%% =======================
acc_test = 0;

for tst_k = 1:N_test
    for i = 1:length(dig_rnd)
        k = dig_rnd(i) + 1;
        target = k - 1;

        x = reshape(X_tst(:,:, (tst_k-1)*10 + k), input_size,1);

        v1 = tW1*x; y1 = sign(v1);
        v2 = tW2*y1; y2 = sign(v2);
        v3 = tW3*y2;

        % applying 'sign' decreses the accuracy from 0.9546 to 0.9395
        %y3 = sign(v3);  % linear output = SVM decision function values (no softmax — decision based on score)
        y3 = v3;

        [~,pred]=max(y3);pred=pred-1;
        if pred==target; acc_test = acc_test+1; end % this is, in fact, the same as argmax
        %printf('Digit %d prediction: %d\n', target, pred);

   end
end

fprintf('\nFINAL TEST ACCURACY (decimal): %.4f\n', acc_test / (N_test*10));

%% =======================
% Ternary inference
%% =======================

%% -------------------------------------------------------------
%% Convert decimal matrix to balanced ternary matrix
%% -------------------------------------------------------------
function btM = toBT(M)
    [r,c] = size(M);
    btM = cell(r,c);  % preallocate cell array of strings

    for i = 1:r
        for j = 1:c
            x = M(i,j);
            if x >= 0
                btM{i,j} = dec2bt(x);
            else
                btM{i,j} = bt_negate(dec2bt(-x));
            end
        end
    end
end

%% -------------------------------------------------------------
%% convert BT matrix -> decimal matrix
%% -------------------------------------------------------------
function Mdec = BT2decMatrix(Mbt)
    [r,c] = size(Mbt);
    Mdec = zeros(r,c);
    for i = 1:r
        for j = 1:c
            Mdec(i,j) = bt2dec(Mbt{i,j});
        end
    end
end

tW1_bt = toBT(tW1);
tW2_bt = toBT(tW2);
tW3_bt = toBT(tW3);

acc_test = 0;

for tst_k = 1:N_test
    for i = 1:length(dig_rnd)
        k = dig_rnd(i) + 1;
        target = k - 1;

        x = reshape(X_tst(:,:, (tst_k-1)*10 + k), input_size,1);
        x_bt = toBT(x);

        v1 = bt_matmul(tW1_bt, x_bt); y1 = cellfun(@bt_sign, v1, 'UniformOutput', false);
        v2 = bt_matmul(tW2_bt, y1); y2 = cellfun(@bt_sign, v2, 'UniformOutput', false);
        v3 = bt_matmul(tW3_bt, y2);

        % applying 'sign' decreses the accuracy from 0.9546 to 0.9395
        %y3 = cellfun(@bt_sign, v3, 'UniformOutput', false);  % linear output = SVM decision function values (no softmax — decision based on score)
        y3 = v3;

        [~,pred] = bt_max(y3);%--0.97 with N_test = 10, matching the full decimal method;
        %pred = bt_first_nonneg(v3);%--0.94 with N_test = 10; %bt_first_positive(v3);
        pred = pred-1;
        if pred==target; acc_test = acc_test+1; end % this is, in fact, the same as argmax
        %printf('Digit %d prediction: %d\n', target, pred);

  end

end

fprintf('\nFINAL TEST ACCURACY (fully ternary): %.4f\n', acc_test / (N_test*10));

