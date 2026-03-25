function [hist3D, axis1, axis2, nbSrc, s_hat ] = SpatialFreqDiversity( s, Fs)
% [ nbSrc, s_hat ] = SpatialDiversity( s )
%
%  Spatial diversity descriptor
%
%
% 
% Compute the 3D histogram Ratio_Amplitude, Delta_Phase, 
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

max_nbsrc = 10;
% -inf

T = -70; %-30; %-70;   %% threshold in dB

max_A = 15;
nb_points = 130;

%% Compute the left and right channels STFT
Sw1 = spectrogram(s(1,:));
Sw2 = spectrogram(s(2,:));

nb_trame = size(Sw1, 2);

M    = size(Sw1,1);
Mh   = round(M/2);
  %size(Sw1(1:Mh,:),1) * size(Sw1(1:Mh,:),2);

%% get critical bands
[critical_bands] = barkscale( M, Fs );
nbB = length(critical_bands);  %% 24

%% Build 3D histogram
hist3D = zeros(nb_points, nb_points, nbB);  %%  ratio_A * delta_phi

%axis1  = linspace(min(ratio_A) , max(ratio_A)  , nb_points);
axis1  = linspace(eps , max_A, nb_points);
delta1 = abs(axis1(2)-axis1(1));

axis2 = linspace(-pi, +pi, nb_points);
delta2 = abs(axis2(2)-axis2(1));


for b = 1:nbB
    
  m    = (critical_bands(b,1):critical_bands(b,2));
  m    = m(m<=Mh);
  
  len  = length(m) * nb_trame;
  E         = 0.5 * reshape(abs(Sw1(m,:)) + abs(Sw2(m,:)), 1, len);   %% average energy vector
  X1        = reshape( Sw1(m,:), 1, len);
  X2        = reshape( Sw2(m,:), 1, len);
  
  %% find non negligible indices
  I = find(10 * log10(E) > T);

  omega  = 2 * pi * (m-1) / M * Fs;
  wMat   = repmat(omega(:), 1 , size(Sw1,2));
  W      = reshape(wMat, 1, len);

  ratio_A   = abs(X1(I)) ./ (eps + abs(X2(I)));
  delta_phi = modulo2pi((angle(X1(I)) - angle(X2(I)))); % ./ (eps + W(I));
  %delta_phi = (angle(X1(I)) - angle(X2(I))) ./ (eps + W(I));
  
  
  lenI = length(I);
  for i = 1:lenI
    [~, I1] = min( abs(ratio_A(i)   - axis1) );
    [~, I2] = min( abs(delta_phi(i) - axis2) );  
  
    %if abs(axis1(I1)-ratio_A(i)) < delta1 && abs(axis2(I2)-delta_phi(i)) < delta2
    hist3D(I1, I2, b) = hist3D(I1, I2, b) + E(i);
   %end
  end
  
  %% Normalize
  hist3D(I1, I2, b) = hist3D(I1, I2, b) / sum(sum(hist3D(I1, I2, b)));

  imagesc(axis2, axis1, hist3D(:,:,b) )
  title(sprintf('Frequency-band : %d [%fHz - %fHz]', b, (critical_bands(b,1)-1)/M *Fs, (critical_bands(b,2)-1)/M *Fs));
  pause
end


imagesc(axis2, axis1, sum(hist3D,3))
 title('Sum');
pause

%ratio_A   = reshape(ratio_A, 1, len);
%delta_phi = reshape(delta_phi, 1, len);

% figure(1)
% plot(ratio_A);
% 
% figure(2)
% plot(delta_phi);
% 
% figure(3)
% plot(E);
% pause


%max(ratio_A) 





%% find the optimal number of clusters using the Elbow method
nbSrc = 0;
[d, data] = compute_distance(hist2D);
Z = linkage(d);
d_vec = zeros(1, max_nbsrc);

for nc = 1:max_nbsrc
  T = cluster(Z, 'maxclust', nc);
  cost = SSE(T, data);
  d_vec(nc) = cost;
end

[~, I] = max(abs(diff(d_vec)));
nbSrc = I+1;

%d_vec = d_vec / max(d_vec);

% plot(1:10, d_vec);
% hold on
% plot(nbSrc, d_vec(nbSrc), 'rx');
% xlabel('number of clusters')
% ylabel('SSE')
% pause

%% store the ratio_A and the delta_Phi associated to the source
T = cluster(Z, 'maxclust', nbSrc);
Src = zeros(nbSrc, 3);
for i = 1:nbSrc
  I = find(T == i);

  %% centroid
  N = sum(data(I, 3));
  Src(i, 1) = sum( data(I, 3) .* data(I, 1) )/N;
  Src(i, 1) = sum( data(I, 3) .* data(I, 2) )/N;
  
  %% maximum
  %[~, Ic]  = max(data(I, 3));
  %Src(i, 1) = axis1(data(I(Ic), 1))
  %Src(i, 2) = axis2(data(I(Ic), 2))
end
 
 %imagesc(axis2,axis1, hist2D);
 %xlabel('delay')
 %ylabel('\Delta_A')

 s_hat = Src;

end


function [d, data] = compute_distance(hist2d)
sz = size(hist2d);

nb = nnz(hist2d); %sz(1) * sz(2);

data = zeros(nb, 3);

index = 1;
for i = 1:sz(1)
  for j = 1:sz(2)
    if hist2d(i,j) > eps
      data(index, 1) = i;
      data(index, 2) = j;
      data(index, 3) = hist2d(i,j);
      index = index + 1;
    end
  end
  
  %% normalize dataset
  data(:,1) = data(:,1) / max(data(:,1));
  data(:,2) = data(:,2) / max(data(:,2));
  data(:,3) = data(:,3) / max(data(:,3));
end

 d = pdist(data(:,1:3));
end

function cost = SSE(T, data)
  nc = max(T);
  cost = 0;
  for i = 1:nc   %% for each cluster
     I = find(T == i);
     
     c = mean(data(I, :));

     for j = 1:length(I)
      cost = cost + sum((data(I(j), :) - c).^2);
     end
  end
end




