function [ h, v, P] = my_histogram( s, displ, texte )
% function [ h, v] = my_histogram( input_args )
% Compute the dynamic histogram
%
% Input:
% s:    input signal
% displ: plot histogram if it is true
% title: plot title if defined
%
% Output:
% h:    histogram
% v:    corresponding values [dB]
% P:    (1)mean, (2)peak value, (3)peak_position [dB] (4)centroid (5)median, (6)entropy, (7)standard deviation, (8)skewness
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
if min(size(s) > 1)
 error('Input signal should be mono') 
end

if ~exist('texte', 'var')
   texte = ''; 
end

 %% 1 Dynamic compression  energy histogram
 [h, v, sdb] = dynamic_h(s);
 
 
 [h_peak,n_max] = max(h);
 v_peak      = v(n_max);
 
 centroid   = sum(v .* h)/sum(h);
 
 mean_Edb   = sum(v .* h);
 std_Edb    = std(sdb);
 median_Edb = median(sdb);
 skew_Edb   = skewness(sdb);
 
 %% Entropy
 x = find(abs(h) > eps);
 
 Ht  = -sum(h(x) .* log(h(x))./log(2));
 P = [mean_Edb h_peak v_peak centroid median_Edb Ht std_Edb skew_Edb];
 
 if exist('displ', 'var')
   bar(v, 100 * h);
   xlabel('energy in dB');
   ylabel('normalized occurences');
   title(sprintf('%s sig. energy histogram (mean=%.2f dB, entropy=%.2f, std=%.2f skewness=%.2f)', texte, mean_Edb, Ht, std_Edb, skew_Edb));   
 end

end

