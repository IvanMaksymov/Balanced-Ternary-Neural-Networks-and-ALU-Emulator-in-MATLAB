clc; clear; close all;
pkg load image;
rng(3);

%% --- Load MNIST data ---
train_images = loadMNISTImages('train-images-idx3-ubyte');
train_labels = loadMNISTLabels('train-labels-idx1-ubyte');

test_images  = loadMNISTImages('t10k-images-idx3-ubyte');
test_labels  = loadMNISTLabels('t10k-labels-idx1-ubyte');

%% --- Parameters ---
N_train = 5000; % training samples per digit
N_test  = 800;  % test samples per digit
img_size = [16 16]; % resize images

train_X = [];
train_Y = [];
test_X  = [];
test_Y  = [];

flag = 1; % 1 - load from the saved files, 0 - build from scratch

if flag == 0

  %% --- Build datasets ---
  for digit = 0:9
      % --- TRAIN ---
      idx = find(train_labels == digit);

      selected_train = idx(1:N_train);

      for i = 1:N_train
          img = train_images(:,:,selected_train(i));
          train_X(:,:,end+1) = imresize(img,img_size, 'nearest');
          train_Y(end+1) = digit;
      end

      % --- TEST ---
      idx_test = find(test_labels == digit);

      selected_test = idx_test(1:N_test);
      %selected_test = idx_test(2:N_test+1);

      for i = 1:N_test
          img = test_images(:,:,selected_test(i));
          test_X(:,:,end+1) = imresize(img,img_size, 'nearest');
          test_Y(end+1) = digit;
      end
  end

  X = train_X(:,:,2:end);
  X_tst = test_X(:,:,2:end);
  %%%X = double(X ~= 0);

  X_new = zeros(size(X)); % same size as X
  X_new_tst = zeros(size(X_tst));

  cnt = 1;
  for cycle = 1:N_train
      for digit = 0:9
          old_index = digit*N_train + cycle; % original dataset index
          X_new(:,:,cnt) = X(:,:,old_index);
          cnt = cnt + 1;
      end
  end

  cnt = 1;
  for cycle = 1:N_test
      for digit = 0:9
          old_index = digit*N_test + cycle; % original dataset index
          X_new_tst(:,:,cnt) = X_tst(:,:,old_index);
          cnt = cnt + 1;
      end
  end

  X_new = ternarize(X_new);
  X_tst = ternarize(X_new_tst);

  save -v7 train_ternary.dat X_new
  save -v7 test_ternary.dat X_tst

else

  load train_ternary.dat
  load test_ternary.dat

endif

%% --- Plot some images ---
figure; colormap(gray);
for k = 1:30
  subplot(5,6,k);          % local subplot index 1..30
  imshow(X_new(:,:,k), []);
end

figure;
for k = 1:30
    subplot(5,6,k); % 5x5 grid for 25 images
    imshow(X_tst(:,:,k), []);
    title('Test images');
    %title(sprintf('%d', train_Y(k)));
end
