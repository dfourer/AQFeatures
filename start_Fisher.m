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
clear
close all

load('AQFeatures.mat');
f_names{26} = 'AVSP6';



%% inter-class variance
nb_classes = length(X);
nb_feat = size(X{1},2);

% %% z-scoring
% for k = 1:nb_classes
%     X{k} = (X{k} - mean(X{k},1)) ./ (eps+std(X{k},0,1));
% end

mu = zeros(nb_classes,nb_feat);
va = zeros(nb_classes,nb_feat);
nk = zeros(1,nb_classes);

for k = 1:nb_classes
  mu(k,:) = mean(X{k},1);
  va(k,:) = var(X{k},1);
  nk(k) = size(X{k},1);
end
N = sum(nk);

%% global mean
%inter-class variance
mu0 = 1/ N * sum(mu .* repmat(nk.',1,nb_feat),1);
% if all classes have the same size
% mu0 = mean(mu, 1);

Sb = 1/ N * sum((mu - repmat(mu0,5,1)).^2.*repmat(nk.',1,nb_feat));

%% intra-class variance
Sw = sum(va .* repmat(nk.',1,nb_feat),1);

%% inverse of the Fisher criterion
f_scores = Sw ./ (eps+Sb)

[~, I] = sort(f_scores, 'descend');
fprintf(1, 'Features selected by descending order of Fisher criterion:\n');

for i = 1:length(I)
fprintf(1, '%s : %.5f \n', f_names{I(i)}, f_scores(I(i)));
end