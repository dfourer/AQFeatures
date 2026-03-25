function [ X_feat] = summary_feat(X, mask)
% [ X_feat] = summary_feat( X, mask )
%
% compute most common summary features from a time series
%
% [mean(X) median(X) iqr(X) std(X) skewness(X) kurtosis(X) max(X) min(X) MatEntropy(X) slope];
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

%% linear regression 1d
if size(X,1) > size(X,2)
 X = X.';
end

[slope b] = regression1d(1:length(X), X);

X_feat = [mean(X) median(X) iqr(X) std(X) skewness(X) kurtosis(X) max(X) min(X) MatEntropy(X) slope];

if exist('mask', 'var')
  X_feat = X_feat(mask); 
end

end

