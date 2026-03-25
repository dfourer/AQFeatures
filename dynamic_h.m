function [ h, val, sdb ] = dynamic_h( s )
% [ h, val ] = dynamic_h( s )
%  Compute the normalized dynamic range histogram of a signal s
%  in [-95.5dBh - -0.5dB]
%
% Input:
% s: input signal
%
% Output:
% h:
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
%val = (-95.5):1:(-0.5);
val = -100:1:0;

h = zeros(1, length(val)-1);

sdb = 20 * log10(abs(s));
sdb = sdb(sdb >= val(1) & sdb <= val(end));

%hist(sdb, 100);

%% compute the histogram
for i = 1:length(h)
  h(i) = length(sdb(sdb >= val(i) & sdb < val(i+1)));
end

val = val(2:end);
h = h/sum(h);
end

