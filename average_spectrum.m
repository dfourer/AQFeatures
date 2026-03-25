function [ X, Xc, centroid, peak, f_peak, f_axis ] = average_spectrum( x, Fs, deltaF )
% Compute the average spectrum descriptor
%
% INPUT:
% x: signal
% Fs: sampling frequency
% deltaF: spectrum resolution
%
% Output
% X: average spectrum
% Xc: cumulated spectrum
% centroid:
% max
% peak position in Hz
% =========================================================================
% Objective Characterization of Audio Signal Quality
% Application to Music Collection Description
%
% Implementation inspired by:
% Dominique Fourer and Geoffroy Peeters,
% "Objective Characterization of Audio Signal Quality: Application to
% Music Collection Description,"
% Proc. IEEE 42nd International Conference on Acoustics, Speech and Signal
% Processing (ICASSP), March 2017, New Orleans, USA.
%
% Author: Dominique Fourer (dominique@fourer.fr)
%
% Description:
% This code implements feature extraction and/or analysis methods described
% in the above paper, with a focus on objective audio quality characterization.
% It may include descriptors related to spectral, temporal, and perceptual
% properties of audio signals, and can be used for tasks such as:
%   - Audio quality assessment
%   - Music collection description
%   - Audio processing characterization (e.g., DRC discrimination)
%
% Notes:
% - This is a research-oriented implementation and may not exactly reproduce
%   the original results.
% - Ensure proper citation if used in academic work.
%
% License:
% License: Creative Commons Attribution-NonCommercial 4.0 International
% (CC BY-NC 4.0)
%
% You are free to:
%   - Share: copy and redistribute the material
%   - Adapt: remix, transform, and build upon the material
%
% Under the following terms:
%   - Attribution: You must give appropriate credit.
%   - NonCommercial: You may not use the material for commercial purposes.
%
% Full license text:
% https://creativecommons.org/licenses/by-nc/4.0/
%
% =========================================================================

if ~exist('deltaF', 'var')
 deltaF = 44100 / 4096;
end

M = round(Fs / deltaF);

rec = 1;
w   = ones(1, M);

[Sw] = spectrogram(x, w, rec);
 
Mh = round(M/2);
X = mean(abs(Sw(1:Mh,:)).^2, 2);
X = X / sum(X);

% %% change to 10 log10 scale
% X = 10*log10(X);

Xc = cumsum(X);

f_axis = ((1:Mh)-1)/M * Fs;

centroid         = sum(f_axis .* X.');
[peak, m_peak]     = max(X);

f_peak = (m_peak-1)/M * Fs;

% tic
% X2 = abs(fft(x)).^2;
% X2 = resample(X2, M, length(X2));
% X2 = X2(1:Mh) / sum(X2(1:Mh));
% toc
% plot(X)
% hold on
% plot(X2,'r-.')
% pause

end

