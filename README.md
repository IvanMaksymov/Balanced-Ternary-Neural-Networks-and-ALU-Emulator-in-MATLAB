# Balanced Ternary Neural Networks and ALU Emulator in MATLAB/Octave

<p align="center">
  <img src="logoGitHub.png" width="300">
</p>


This repository provides a complete MATLAB/Octave framework for experimenting with balanced-ternary computing, including:

1) A balanced ternary ALU emulator with multi-trit operations;

2) A simple, experimental ternary deep neural network prototype;

3) Training and inference on a ternarised MNIST dataset;

4) Support utilities for encoding/decoding balanced-ternary vectors.

This project is for researchers exploring non-binary computing, ternary logic circuits and unconventional neural network arithmetic. It began as a hobby project aimed at developing a deeper understanding of the opportunities offered by ternary neural networks. I intentionally avoided consulting the existing literature to build everything from scratch, hoping to think independently, avoid repeating the assumptions made by others (at least consciously) and perhaps even rediscover or create something genuinely new. As usual, no warranty is provided. You use this code at your own risk.

## File description

1) Ternary_MultiClass_Ternary_Inference_Only.m loads the trained network weights (allvars_ternaryNN_no_bias.h5), converts them into their ternary (balanced trit) form and evaluates the model on N_test = 10 test images (default, maximum 800). In the decimal inference section, matrix multiplications are carried out using standard MATLAB/Octave integer operations, which are naturally fast. In contrast, the ternary inference section performs all computations strictly using ternary arithmetic. This includes trit-wise operations, ternary addition and shift-and-add multiplication through the ternary ALU emulator. As expected, this mode is significantly slower, even though several optimisation tricks are applied to the emulator to reduce overhead.
2) The data file allvars_ternaryNN_no_bias.h5 is produced by the file Ternary_MultiClass_Ternary_Full_v2.m that calls MultiClass_Ternary_SVM_No_Bias.m and other functions. It is relatively slow, too. However, setting N_train = 1000 and N_test = 10 helps reduce the training time (for test purposes only, of course). 
3) File mnist_loader.m loads the standard MNIST data, reduces the image size (if needed; 16 x 16 images are used in this project) and converts them into their ternary (balanced trit) form, also creating two data files for further use in the model.

## Algorithm Description

This implementation trains a hybrid ternary DNN using a multi-class L2-SVM loss function. The network uses ternary weights and activations with no bias terms.

**Network Architecture:**
- 3-layer fully connected network
- Ternary weights: `W ∈ {-1, 0, +1}`
- Ternary activations: `y ∈ {-1, 0, +1}`
- No bias terms in any layer

**Forward Pass:**
```
v₁ = ternarize(W₁) × x
y₁ = ternaryActivation(v₁, tf)
v₂ = ternarize(W₂) × y₁  
y₂ = ternaryActivation(v₂, tf)
v₃ = ternarize(W₃) × y₂  # Raw SVM scores (no softmax)
```

**Ternary Functions:**
- `ternarize(W, tf)`: Quantises weights to {-1, 0, +1} using threshold `tf`
- `ternaryActivation(v, tf)`: Applies ternary activation with threshold `tf`
- `ternaryDerivative(v)`: Straight-Through Estimator for backpropagation

**L2-SVM Loss:**
```
L = 0.5 × ||w||² + C × Σ max(0, 1 - y_label × v₃)²
```
Where:
- `C` = regularisation parameter (default: 0.1)
- `y_label` = target labels converted from one-hot to ±1 encoding
- `v₃` = raw output scores from final layer

**Gradient Calculation:**
```
margin = 1 - y_label ⋅ v₃
mask = (margin > 0)
∂L/∂v₃ = -2 × C × (y_label ⋅ margin ⋅ mask)
```

**Backward Pass:**
Gradients are propagated through ternary layers using Straight-Through Estimation:
```
e₂ = ternarize(W₃)ᵀ × ∂L/∂v₃
∂L/∂v₂ = e₂ ⋅ ternaryDerivative(v₂)
e₁ = ternarize(W₂)ᵀ × ∂L/∂v₂  
∂L/∂v₁ = e₁ ⋅ ternaryDerivative(v₁)
```

**Weight Update:**
```
W₃ = W₃ - α × (∂L/∂v₃ × y₂ᵀ)
W₂ = W₂ - α × (∂L/∂v₂ × y₁ᵀ)
W₁ = W₁ - α × (∂L/∂v₁ × xᵀ)
```

These computations are followed by argmax classification, which is a standard approach for multi-class SVM without softmax.

### Parameters
- `alpha`: Learning rate for gradient descent
- `tf`: Ternarisation threshold for weights and activations  
- `C`: SVM regularisation parameter (default: 0.1)
- I note that, currently, there is no direct regularisation (the algorithm is mostly experimental)



