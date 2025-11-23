function [W1,W2,W3,acc] = MultiClass_Ternary_SVM_No_Bias(X,D,W1,W2,W3,alpha,tf)
% MultiClass_Ternary_SVM
% Fully ternary deep neural network with an L2-SVM (squared hinge loss) output layer
%
% Inputs:
%   X       - input data [rows x cols x samples]
%   D       - target labels one-hot encoded [samples x classes]
%   W1,W2,W3 - weights and biases
%   alpha   - learning rate
%   C       - SVM regularization parameter
%   tf      - ternarization threshold
%
% Outputs:
%   Updated W and training accuracy

    C = 0.1;  % good default
    % or test grid
    C_values = [0.1, 1, 10, 50];

    N = size(X,3);
    correct = 0;
    [r,c,~] = size(X);
    input_size = r*c;

    rnd = randperm(N);

    for ii = 1:N
        k = rnd(ii);

        x = reshape(X(:,:,k), input_size, 1);
        d = D(k,:)';              % one-hot target
        [~,target_class] = max(d);
        y_label = -ones(size(d));
        y_label(target_class) = 1;  % convert one-hot to ±1 labels

        % --- ternarize weights ---
        tW1 = ternarize(W1, tf);
        tW2 = ternarize(W2, tf);
        tW3 = ternarize(W3, tf);

        % --- forward pass ---
        v1 = tW1*x;
        y1 = ternaryActivation(v1, tf);

        v2 = tW2*y1;
        y2 = ternaryActivation(v2, tf);

        v3 = tW3*y2;     % linear SVM output
        y3 = v3;              % no softmax, raw scores

        % --- L2-SVM loss and derivative ---
        % Squared hinge: L = 0.5*||w||^2 + C * sum(max(0, 1 - y_i f_i)^2)
        margin = 1 - y_label .* y3;
        mask = (margin > 0);
        d3 = -2 * C * (y_label .* margin .* mask);  % gradient wrt output (f_i)

        % --- backprop through ternary layers ---
        e2 = tW3' * d3;
        d2 = e2 .* ternaryDerivative(v2);

        e1 = tW2' * d2;
        d1 = e1 .* ternaryDerivative(v1);

        % --- weight updates ---
        W3 = W3 - alpha * (d3 * y2');
        W2 = W2 - alpha * (d2 * y1');
        W1 = W1 - alpha * (d1 * x');

        % --- accuracy ---
        [~,pred] = max(y3);
        [~,true_label] = max(d);
        if pred == true_label
            correct = correct + 1;
        end
    end

    acc = correct / N;
end

