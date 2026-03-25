function [ result ] = isOriginalMono( s )
% [ result ] = isOriginalMono( s )
%
% return true if mixture s was originally mono
%
% [ISO/IEC 15938-4]
%
%
% 1) Normalize each channel to maximal value
% 2) compute cross correlation cx1xn
% 3) 
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

if size(s,1) > size(s,2)
 s = s.';    
end

Ns = size(s,2);   %% length of s

if size(s, 1) < 2
 result = 0;
 return;
 %error('Invalid data');
end

T       = 0.99;
delta_n = 5;

n_chan = size(s,1);

s(1,:) = s(1,:) / max(abs(s(1, :)));  %% normalize 1st channel


N_cor = size(s,2)*2-1;    %length of xcorr vector
n_max = Ns;                % max position

cxx      = zeros(N_cor, n_chan);
cx1xn    = zeros(N_cor, n_chan-1);

cxx(:,1) = xcorr(s(1,:).', s(1,:).');   %% 1st channel autocorrelation

for i = 2:n_chan
 s(i,:) = s(i,:) / max(abs(s(i, :)));  %% normalize other 
 
 cxx(:,i)     = xcorr(s(i,:).', s(i,:).');  %% autocorr
 cx1xn(:,i-1) = xcorr(s(1,:).', s(i,:).');  %% cross corr with s1
end


%m_cxx = mean(cxx(n_max,:));   %% mean maximum of the N channels autocorrelation
m_cxx = mean([cxx(n_max,1) cxx(n_max,n_chan)]);
cx1xn = cx1xn / m_cxx;        %% normalize cross correlation

n_range  = (n_max-delta_n):(n_max+delta_n);
result = ~isempty(find(cx1xn(n_range,:) > T));


end

