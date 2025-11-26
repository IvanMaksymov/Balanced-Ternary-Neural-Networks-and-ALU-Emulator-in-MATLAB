clc; clear; close all;
rng(3);

%% =======================
% 1. Load MNIST ternary dataset
%% =======================
N_train = 5000;%5000;%1000; % training samples per digit
N_test  = 800;%800;%10;  % test samples per digit
load train_ternary.dat   % should contain X_new
load test_ternary.dat    % should contain X_tst

sz = size(X_new);
input_size  = sz(1)*sz(2);
output_size = 10;

%% =======================
% 2. Create target matrix D
%% =======================
D = eye(10);  % one-hot encoding digits 0..9

%% =======================
% 3. Initialize weights & biases
%% =======================
hidden_size = 2*ceil(input_size/2);

% Layer 1
limit1 = sqrt(6)/sqrt(input_size + hidden_size);
W1 = rand(hidden_size, input_size)*2*limit1 - limit1;
b1 = zeros(hidden_size,1);

% Layer 2
limit2 = sqrt(6)/sqrt(hidden_size + hidden_size);
W2 = rand(hidden_size, hidden_size)*2*limit2 - limit2;
b2 = zeros(hidden_size,1);

% Layer 3 (output)
limit3 = sqrt(6)/sqrt(hidden_size + output_size);
W3 = rand(output_size, hidden_size)*2*limit3 - limit3;
b3 = zeros(output_size,1);

%% =======================
% 4. Training loop
%% =======================
epochs = 1500;%1500;
lr = 0.001;%0.005;
tf = 0.1;%0.05;%0.1;  % ternarisation threshold
accuracy = zeros(epochs,1);

dig_rnd   = 0:9;
train_rnd = 1:N_train;

for epoch = 1:epochs
    acc_sum = 0;

    for i = 1:length(train_rnd)
        j = train_rnd(i);
        start_idx = (j-1)*10 + 1;
        end_idx   = j*10;
        X_batch = X_new(:,:,start_idx:end_idx);

        % --- call fully ternary deep function ---
        [W1,W2,W3,acc_batch] = MultiClass_Ternary_SVM_No_Bias(X_batch,D, W1,W2,W3, lr, tf);

        acc_sum = acc_sum + acc_batch;
    end

    accuracy(epoch) = acc_sum / length(train_rnd);
    fprintf('Epoch %d/%d - Training Accuracy: %.4f\n', epoch, epochs, accuracy(epoch));
end

figure; plot(1:epochs, accuracy,'LineWidth',2);
xlabel('Epoch'); ylabel('Accuracy'); title('Training Accuracy'); grid on;

%% ===========================================================================================
% 5. Inference on test set -- see Ternary_MultiClass_Ternary_Inference_Only.m for more detail
%% ===========================================================================================
% Forward pass (fully ternary)
tW1 = ternarize(W1, tf);
tW2 = ternarize(W2, tf);
tW3 = ternarize(W3, tf);

acc_test = 0;

for tst_k = 1:N_test
    for i = 1:length(dig_rnd)
        k = dig_rnd(i) + 1;
        target = k - 1;

        x = reshape(X_tst(:,:, (tst_k-1)*10 + k), input_size,1);

%        v1 = tW1*x; y1 = ternaryActivation(ternarize(v1, tf), tf);
%        v2 = tW2*y1; y2 = ternaryActivation(ternarize(v2, tf), tf);
%        v3 = tW3*y2;

        v1 = tW1*x; y1 = sign(v1);
        v2 = tW2*y1; y2 = sign(v2);
        v3 = tW3*y2;

        %y3 = ternaryActivation(ternarize(v3, tf), tf);
        % applying 'sign' decreses the accuracy from 0.9546 to 0.9395
        %y3 = sign(v3);  % linear output = SVM decision function values (no softmax — decision based on score)
        %y3 = Softmax(v3); % output layer using Softmax
        y3 = v3;  % linear output = SVM decision function values (no softmax — decision based on score)

        [~,pred]=max(y3); pred=pred-1;
        if pred==target; acc_test = acc_test+1; end
        printf('Digit %d prediction: %d\n', target, pred);

%        pred = ternary_argmax(y3);
%        if pred==target; acc_test = acc_test+1; end
%        printf('Digit %d prediction: %d\n', target, pred);

    end
end

fprintf('\nFINAL TEST ACCURACY (fully ternary): %.4f\n', acc_test / (N_test*10));



