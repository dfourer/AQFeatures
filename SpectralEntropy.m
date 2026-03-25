function [ E ] = SpectralEntropy(s)
% SpectralEntropy( s, Fs )
%
%  Compute the spectral entropy
% 
%  Implementation based on [Automatic Music Detection in television productions, Seyerlehner, Pohle, Schedl, Widmer. Dafx'07]
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

if min(size(s)) ~= size(s,1)
   s = s.'; 
end

L = size(s,1);   %% number of channels

Sw             = spectrogram(s(1, :));
[M, nb_trames] = size(Sw);
Mh = round(M / 2);

E = zeros(L, nb_trames);

for l = 1:L
 if l > 1
   Sw = spectrogram(s(l, :)); 
 end
 X  = abs(Sw(1:Mh, :)).^2;
%  imagesc(10 * log10(X))
%  pause

 for n = 1:nb_trames
 
   %% transform X to pdf
   Px = X(:, n) ./ (eps+sum(X(:, n)));
 
   %% Compute the entropy
   E(l, n) = - sum(Px .* log2(eps+Px));
 end
end

end

