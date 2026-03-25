function [ dt, p ] = RelativeDelay( s, Fs )
% [ dt ] = RelativeDelay( s, Fs )
% 
% Compute the time delay between channels of signal s
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
max_delay = 0.5e-3;  %% expressed in seconds


if length(s) < Fs/2
 error('Signal is too short');
end
if size(s,1) > size(s,2)
  s = s.';
end

if size(s, 1) ~= 2
 dt = 0;
 p  = 1;
 %error('Invalid data');
 return;
end

n0 = length(s);

Nchan  = size(s,1);   %% number of channels

dt = zeros(1, Nchan-1);
p  = zeros(1, Nchan-1);

cxx11 = xcorr(s(1,:), s(1,:));cxx11(n0) = 0;

[~, Ns] = max(cxx11);
for i = 2:(Nchan)
 cxx1n = xcorr(s(1,:), s(i,:));%cxx1n(n0) = 0;
 cxxnn = xcorr(s(i,:), s(i,:));cxxnn(n0) = 0;

 
 %% research region in [-0.5s +0.5s]
 %[~, I] = max(cxx1n);
 i0 = round(-max_delay*Fs);
 i1 = -i0;
 n = Ns + (i0:i1); % Limit the research range in [-0.5, +0.5]s

 n = n(n>=1); n = n(n<=length(cxx1n));   %%check bounds
 [~, dn] = max(cxx1n(n));

 dt(i-1) = (Ns-n(dn)) / Fs;   %% compute the relative delay of channel i+1 in seconds
 p(i-1)  = abs(cxx1n(n(dn)))^2 / (eps+max(cxx11(n)) * max(cxxnn(n)).');
end

end

