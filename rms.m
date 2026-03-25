function [v,t] = rms(s, N, rec, Fs)
%% compute linear Root Mean Square
% function [v,t] = rms(s, N, rec, Fs)
%
%
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
%s = s - mean(s);
%s = s / max(abs(s));

if ~exist('N', 'var')
  N = length(s);
end
if ~exist('Fs', 'var')
 rec = 44100;
end
if ~exist('rec', 'var')
 rec = 1;
end

if N >= length(s)
 v = sqrt(mean(abs(s).^2));
 t = 1:N;
else
 len = length(s);
 hop = floor(N/rec);
 nb_trame = ceil(length(s)/hop);
 v = zeros(1, nb_trame);
 t = zeros(1, nb_trame);
 for i = 1:nb_trame
  i0 = (i-1)*hop + 1;
  i1 = min(i0 +N -1, len);
  t0 = (i0+i1)/2;
  t(i) = t0/Fs;

  v(i) = sqrt(mean(abs(s(i0:i1)).^2));  
 end
end
