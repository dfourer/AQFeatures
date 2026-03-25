function [Sw] = spectrogram(s,w,rec)
% [Sw] = spectrogram(s,w,rec)
%
% 
% INPUT:
% s: input signal
% w: analysis window
% rec: overlap between 2 adjacent windows
%
%
% OUTPUT:
% Sw: STFT, spectrogram given by |Sw|^2
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

%% default window
if ~exist('w', 'var')
 w = hann(2048, 'periodic').';
 %w = kbdwin(2048, 4).';
end

if ~exist('rec', 'var')
 rec = 2;
end


N = length(w);
len = length(s);

step = round(N/rec);
nb_trame = floor(len/step);
Sw = zeros(N, nb_trame);

wref = w;
for i_t = 1:nb_trame
 i0 = (i_t-1)*step+1;
 i1 = min([len i0+N-1]);
 N_tmp = length(i0:i1);

 if N_tmp < N
   w = resample(wref, N_tmp, N);
 end
 
 Sw(1:N_tmp, i_t) = fft( s(i0:i1) .* w );

%  subplot(121)
%  plot(s(i0:i1) .* w)
%  subplot(122)
%  plot(abs(Sw(1:N_tmp, i_t)))
%  pause
end
