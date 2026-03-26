# Objective Audio Quality Characterization – DRC Discrimination

This project provides a MATLAB implementation for analyzing and discriminating **Dynamic Range Compression (DRC) profiles** using audio descriptors.

The main objective is to identify features that are:
- ✅ Sensitive to compression profiles  
- ✅ Robust to the original audio content  

This is achieved using an **inverse Fisher criterion**, specifically designed to isolate processing effects from content variability.

---

## Overview

Audio signals are first processed to extract descriptors.  
Then, features are ranked according to their ability to discriminate between different DRC profiles independently of the original signal.

Finally, results can be visualized in a 3D feature space.

---

## Project Structure

.
├── start_process_db.m
├── start_Fisher.m
├── start_display3d.m
├── originals/
└── generated/

---

## Data Organization

Your dataset must follow this structure:
/originals/
file1.wav
file2.wav
...

/generated/
file1/
compressed_A.wav
compressed_B.wav
file2/
compressed_A.wav
compressed_B.wav


### 🔹 Description
- `originals/` contains reference (unprocessed) audio files  
- `generated/<filename>/` contains compressed versions of each corresponding file  

⚠️ File names must match between `originals/` and `generated/`.

---

## ⚙️ Scripts Description

### ▶️ `start_process_db.m`
**Feature extraction**

- Loads original and compressed audio files  
- Computes audio descriptors for each signal  
- Organizes and stores features for further processing  

---

### ▶️ `start_Fisher.m`
**Feature selection using inverse Fisher criterion**

- Computes a score for each feature:
F = variance_inter_profile / variance_inter_audio


- Ranks features in descending order  
- Selects features that:
- Maximize differences between compression profiles  
- Minimize dependence on audio content  

---

### ▶️ `start_display3d.m`
**3D visualization**

- Projects selected features into a 3D space  
- Allows visual inspection of:
- Separation between DRC profiles  
- Robustness across different audio signals  

---

## Typical Workflow

### 🔹 Prerequisite: Dataset preparation

Before running the pipeline, you must create a dataset with the following structure:


/originals/
file1.wav
file2.wav
...

/generated/
file1/
compressed_A.wav
compressed_B.wav
file2/
compressed_A.wav
compressed_B.wav


- Each file in `originals/` must have a corresponding folder in `generated/`
- Each folder must contain the same audio processed with different DRC profiles

---

### 1. Extract features
```matlab
start_process_db
```
2. Select discriminative features (DRC-oriented)
```matlab
start_Fisher
```
3. Visualize feature space
```matlab
start_display3d
```
