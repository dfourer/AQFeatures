function [vec_descriptor, hx, vx, Px, X, Xc, f_axis, f_names] = F_audioQ_desc(x, Fs)
% [desc] = audioQ_desc(s, Fs)
%
% compute all audio quality descriptors from a input audio file
%
% OUTPUT:
% -vec_descriptor:
% (1): mean Frequency Bandwidth (BW)
% (2): mean Background Noise Level (BNL)
% (3): mean Spectral Entropy (SE)
% (4): Balance (Bal)
% (5): Cochlea Difference  max  100 max(mean(CD))  
% (6): Cochlea Difference  std  100*std(mean(CD))
% (7): Cross Channel Correlation CCC
% (8): Mean(DC)
% (8): DC-Offset ratio between channels    DC(1) / DC(2)
% (9): Phase stereo
% (10): Relative Delay
% (11): isMono
% (12-20): dynamic histogram features
% (21) average spectrum mean(x) 
% (22) average spectrum std(X)
% (23) average spectrum centroid (Hz)
% (24) average spectrum peak (normalized magnitude)
% (25) average spectrum frequency peak
%
% hx,vx : Dynamic histogram
% X, Xc : average spectrum
% f_axis: average spectrum frequency axis [ Hz ]
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
% properties of audio sign% =========================================================================
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
% =========================================================================als, and can be used for tasks such as:
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
f_names = {'BW' 'BNL' 'SE' 'Bal' 'mean CochDiff' 'std CochDiff' 'CCCor' 'DCOff' 'DCOff ratio' 'SSPS' 'RDelay' 'isMono'...
                   'DH1' 'DH2' 'DH3' 'DH4' 'DH5' 'DH6' 'DH7' 'DH8' 'AVSP1' 'AVSP2' 'AVSP3' 'AVSP4' 'AVSP5' 'AVSP6'};

max_filelen = length(x); %% expressed in samples % 200

if size(x,1) > size(x,2)
  x = x.';
end

len      = size(x,2);
nb_frame = ceil(len / max_filelen);

vec_descriptor = []; %zeros(nb_frame, nb_desc);
pvec           = zeros(1, nb_frame);

for n = 1:nb_frame
 i0 = (n-1)*max_filelen+1;
 i1 = min(i0+max_filelen-1, len);
 
 frame = x(:, i0:i1);
 len_frame = length(i0:i1);
 pvec(n)   = len_frame;
 
 if len_frame < Fs/2   %% ignore frame if is to short
   pvec(n) = 0;
   continue;
 end
 %% bandwidth
 [ BW ] = Bandwidth(frame, Fs );

 %% Background Noise Ratio
 [ BNL] = BackgroundNoiseLevel(frame, Fs);

 %% Spectral entropy
 SE    = mean(SpectralEntropy(frame));

 %% balance
 [ B ] = Balance(frame);

 %% CC difference
 [ CD ] = cochleaDiff(frame, Fs);
  
 %% Cross-Channel correlation
 [ r ] = crossChannelCorr(frame);
   
 %% DC-offset
 [ Dc ] = DcOffset(frame);
 if length(Dc) <= 1
  Dc(2) = Dc(1);
 end
 %% is originalMono
 [ m ] = isOriginalMono(frame);

 [ sigma_lr ] = phase_stereo(frame);
  
 %% Relative delay
 [ dt ] = RelativeDelay(frame, Fs );
  
 %[ sigma_lr2] = phase_stereo2(s, Fs);

 [ hx, vx, Px] = my_histogram(x(1, i0:i1));
 
 [ X, Xc, centroid, peak, f_peak, f_axis ] = average_spectrum(x(1,:), Fs);
 
 %% obtain good results
 %%  vec_descriptor(n, :) = [mean(mean(BW)) min(BNL) mean(SE) B(1) 100*max(mean(CD.')) 100*std(mean(CD.')) r(1) mean(Dc) Dc(1)/(eps+Dc(2)) sigma_lr dt m Px mean(X) std(X) centroid peak f_peak];
 % fprintf(1, 'BW');
 % mean(mean(BW))
 % 
 % fprintf(1, 'BNL');
 % min(BNL)
 % fprintf(1, 'SE');
 % 
 % mean(SE)
 % fprintf(1, 'BAL');
 % B(1)
 % fprintf(1, 'mean CochDiff');
 % 100*max(mean(CD.'))
 % fprintf(1, 'std CochDiff');
 % 100*std(mean(CD.'))
 % 
 % fprintf(1, 'CCCor');
 % r(1)
 % fprintf(1, 'DCOff');
 % mean(Dc)
 % fprintf(1, 'DCOff ratio');
 % Dc(1)/(eps+Dc(2))
 % fprintf(1, 'SSPS');
 % sigma_lr
 % 
 % fprintf(1, 'RDelay');
 % dt
 % 
 % fprintf(1, 'isMono');
 % m 
 % 
 % fprintf(1, 'DH1-DH8');
 % Px
 % 
 % fprintf(1, 'AVSP1-AVSP6');
 % mean(X) 
 % median(X)
 % std(X)
 % centroid
 % peak
 % f_peak
 
 vec_descriptor(n, :) = [mean(mean(BW)) min(BNL) mean(SE) B(1) 100*max(mean(CD.')) 100*std(mean(CD.')) r(1) mean(Dc) Dc(1)/(eps+Dc(2)) sigma_lr dt m Px mean(X) median(X) std(X) centroid peak f_peak];
 
end

if nb_frame > 1
 vec_descriptor = pvec * vec_descriptor / sum(pvec); %mean(vec_descriptor, 1);
end

