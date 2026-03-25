function [ BW ] = Bandwidth( s, Fs )
%[ BW ] = Bandwidth( s, Fs )
%
%  Compute thte Bandwidth
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

if size(s,1) > size(s,2)
  s = s.';
end
Ns     = size(s,2);   %% length of s
Nchan  = size(s,1);   %% number of channels


T_frame = 30e-3;                 %% 30 ms
%N_frame = round(T_frame * Fs);   
dt      = 10e-3;                 %% 10ms
dn      = round(dt * Fs);

nb_trame = ceil(Ns  / dn);


L_threshold = 0.7;   % energy ratio to consider
Nfft = 2048;
Nh   = 1024;
w = hann(Nfft).';

BW = zeros(Nchan, nb_trame);
for n = 1:Nchan
  %spect = zeros(Nfft/2, nb_trame);
  for i = 1:nb_trame
    i0 = (i-1)*dn+1;
    i1 =  min(min(i0 + Nfft-1), Ns);
    N_frame = length(i0:i1);
    if N_frame ~= length(w)
     w = hann(N_frame).'; 
    end
    tmp = abs(fft(w .* s(n,i0:i1), Nfft)).^2;
    %spect(:, i) = tmp(1:(Nfft/2));
    spec_db = 10 * log10( tmp(1:Nh)/max(tmp(1:Nh)) );

    sp_max = max(spec_db);
    sp_min = min(spec_db);
    
    sp_th  = (sp_min-sp_max) * L_threshold;
    
%     freq_axis = ((1:Nh)-1)/Nfft*Fs;
    
%     figure(1)
%     plot(freq_axis, spec_db, 'k');
%     xlabel('frequency [Hz]');
%     ylabel('amplitude [dB]');
%     hold on
%     plot(freq_axis, ones(1, Nh) * sp_th, 'r-.')

    % Get the Bandwidth
    I = find( spec_db < sp_th,1);

    if ~isempty(I)
     BW(n,i) = (I-1)/Nfft * Fs;   %%store current bandwidth
    else  %% no signal
     BW(n,i) = 0;
    end
%     plot([BW(n,i) BW(n,i)], [sp_max sp_min], 'g-.');
%     legend('spectrum', 'threshold (0.7)', 'bandwidth');
%     title(sprintf('Magnitude spectrum, Bandwidth=%.2f Hz', BW(n,i)))
%     hold off
%     pause
   
  end
end

end