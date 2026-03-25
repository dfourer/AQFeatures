function [ BNL ] = BackgroundNoiseLevel(x, Fs)
% [ BNL ] = BackgroundNoiseLevel(x, Fs)
%
% compute the Background Noise Level
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

N_5ms = round(5e-3 * Fs);

maxPeak_dB = 10 * log10(eps+max(abs(x)));

minPowdB = inf;

nb_trame = ceil(length(x)/ N_5ms);

for i = 1:nb_trame
 i0 = (i-1) * N_5ms + 1;
 i1 = min(length(x), i0 + N_5ms -1);
 
 trame = x(i0:i1);
 
 E = 10 * log10(eps+ sum(trame.^2) / length(trame) );
 
 if E < minPowdB && ~isinf(E)
   minPowdB = E;
 end
end

BNL = minPowdB - maxPeak_dB;

end

