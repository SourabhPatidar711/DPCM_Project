# MATLAB GUI-Based Differential Pulse Code Modulation (DPCM)

A MATLAB-based graphical user interface for simulating and analyzing **Differential Pulse Code Modulation (DPCM)**.

The project demonstrates the complete DPCM process, including signal generation, sampling, differential encoding, quantization, reconstruction, and performance analysis using MSE and SNR.

---

## 📌 Project Overview

Differential Pulse Code Modulation (DPCM) is a digital coding technique that reduces the amount of information required to represent a signal by encoding the **difference between the current sample and its predicted value**, rather than directly encoding each sample.

This project provides an interactive MATLAB GUI where users can modify signal frequency, sampling frequency, and quantization levels and observe their effect on the reconstructed signal.

---

## ✨ Features

- Interactive MATLAB GUI
- Configurable input signal frequency
- Configurable sampling frequency
- Adjustable quantization levels
- Signal sampling and visualization
- Differential signal generation
- Uniform quantization
- DPCM encoding and decoding
- Reconstructed signal visualization
- Original vs reconstructed signal comparison
- Mean Squared Error (MSE) calculation
- Signal-to-Noise Ratio (SNR) calculation
- Input validation using the Nyquist sampling criterion
- Reset functionality for repeated experiments

---

## 🛠️ Technologies Used

- **MATLAB**
- MATLAB App Designer-style UI components
- Digital Signal Processing
- DPCM
- Signal Sampling
- Quantization
- Numerical Analysis

---

## ⚙️ System Workflow

```text
Input Signal
     ↓
Sampling
     ↓
Prediction
     ↓
Difference Calculation
     ↓
Quantization
     ↓
DPCM Encoded Signal
     ↓
Decoding / Reconstruction
     ↓
Reconstructed Signal
     ↓
MSE & SNR Analysis
```

---

## 🧠 DPCM Working Principle

For each sample, the difference between the current input sample and the previous reconstructed sample is calculated.

### Difference Signal

```text
d(n) = x(n) - x̂(n-1)
```

where:

- `x(n)` = current input sample
- `x̂(n-1)` = previous reconstructed sample
- `d(n)` = difference signal

The difference signal is then quantized before transmission/storage.

### Reconstruction

The reconstructed signal is obtained using:

```text
x̂(n) = x̂(n-1) + dq(n)
```

where `dq(n)` is the quantized difference signal.

---

## 📊 Performance Metrics

### Mean Squared Error (MSE)

MSE measures the average squared difference between the original and reconstructed signal.

```text
MSE = mean((x(n) - x̂(n))²)
```

A lower MSE generally indicates lower reconstruction error.

### Signal-to-Noise Ratio (SNR)

```text
SNR = 10 log10(Psignal / Perror)
```

A higher SNR indicates a better signal-to-error ratio.

---

# 🖥️ GUI Screenshots

## 1. Normal Operation

**Parameters**

```text
Frequency          = 5 Hz
Sampling Frequency = 100 Hz
Quantization       = 16 Levels
```

![Normal Operation](/normal-operation.png)

This test demonstrates the standard operation of the DPCM system with moderate sampling and quantization parameters.

---



---

# 📈 Results and Observations

The experiments demonstrate that the quality of the reconstructed signal depends on both the sampling frequency and quantization levels.

- Lower quantization levels can introduce greater quantization error.
- Increasing quantization levels provides finer representation of the difference signal.
- Increasing the sampling frequency provides more samples for representing the input waveform.
- The reconstructed signal can be compared with the original signal using MSE and SNR.
- The GUI allows these parameters to be changed interactively for experimentation.

---

# 🎯 Learning Outcomes

Through this project, the following concepts were implemented and analyzed:

- Digital signal sampling
- Nyquist sampling criterion
- Differential encoding
- Prediction in DPCM
- Uniform quantization
- Signal reconstruction
- Quantization error
- MSE and SNR analysis
- MATLAB GUI development
- Parameter validation
- Visualization of signal-processing results

---

# 🔮 Future Improvements

Possible improvements include:

- Adaptive quantization
- Higher-order prediction
- Variable prediction coefficients
- PCM vs DPCM comparison
- Delta Modulation comparison
- Bit-rate calculation
- Compression ratio analysis
- Audio signal input
- Exporting simulation results to CSV
- Automated test cases
- Enhanced GUI using MATLAB App Designer

---
