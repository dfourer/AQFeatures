function [ CD, Global_mean_tf, Global_std_tf, Global_mean_ft, C1_m, C2_m ] = cochleaDiff( s, Fs, fmin, fmax, use_gammatone )
% [ x ] = cochleaDiff( s, Fs, fmin, fmax )
%
% Author: Dominique Fourer (dominique@fourer.fr)
%
% version 2:
%
% Implementation based on 
% [D. Tardieu, E. Detruty, and G. Peeters, “Production effect: Audio features for
% recordings techniques description and decade prediction,” in Proc. DAFX’11, sep 2011, pp. 441–446.]
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

if ~exist('use_gammatone', 'var')
  use_gammatone = false;
end

if ~use_gammatone
  N  = 1024;
  Nh = round(N/2);
  dt  = round(1e-2 * Fs);  %% 10ms
  rec = N / dt;
  w = hann(N, 'periodic').';
end

if ~exist('fmin', 'var')
 fmin = 30;
end

if ~exist('fmax', 'var')
 fmax = min(Fs/2, 11025);
end

if size(s, 1) > size(s, 2)
 s = s.';   
end
    
numchans    = 70;
frameshift  = 10; %% in ms
ti          = 8; %% in ms
compression = 'none';

if size(s, 1) == 1
    
 if use_gammatone
   C1_m  = makeRateMap_c(s(1,:), Fs, fmin, fmax, numchans, frameshift,ti,compression);  
 else
     
   C1_m = abs(spectrogram(s(1,:), w, rec)/sum(w));
   C1_m = C1_m(1:Nh,:);
 end
 C2_m = C1_m;

 CD = zeros(size(C1_m));
else
    
  if use_gammatone
    C1_m  = makeRateMap_c(s(1,:), Fs, fmin, fmax, numchans, frameshift,ti,compression);
    C2_m  = makeRateMap_c(s(2, :), Fs, fmin, fmax, numchans, frameshift,ti,compression);  
 else
     
   C1_m = abs(spectrogram(s(1,:), w, rec)/sum(w));
   C1_m = C1_m(1:Nh,:);
   C2_m = abs(spectrogram(s(2,:), w, rec)/sum(w));
   C2_m = C2_m(1:Nh,:);
 end

 CD = abs(C1_m) - abs(C2_m);
end





%%1 Global Mean over frequency and time of abs
Global_mean_tf = mean(mean(CD));


%%2 Standard Deviation over frequency of the mean over time of abs
Global_std_tf = std(mean(CD));

%%3 Mean over time which measure the mean panning over frequencies
if size(s, 1) == 1
 Global_mean_ft = 0;   
else
 Global_mean_ft = mean(mean(C1_m - C2_m));
end
%%4 Mean over time of the absolute value which ignore the panning direction

%%5 Standard deviation over time


end

