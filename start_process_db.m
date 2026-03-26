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

clear
close all


dataset_chemin = "../../dataset/";



d0 = dir(sprintf("%s/originals", dataset_chemin));

i_ref       = 0;
xref        = {};
feats_ref   = {};
X           = {};
for j = 1:length(d0)
    if length(d0(j).name) < 4
        continue;
    end
    [~, name0, ext0] = fileparts(d0(j).name);
    if strcmpi(ext0,".aif") || strcmpi(ext0,".wav")
        i_ref = i_ref+1;
        fprintf(1, 'Processing %s ...\n', name0);
        [xref{i_ref},Fs] = audioread(sprintf('%s/originals/%s', dataset_chemin, d0(j).name));
        [feats_ref{i_ref}, ~, ~, ~,~, ~, f_axis,f_names] = F_audioQ_desc(xref{i_ref}, Fs);

        %% processing all the generated signals
        d = dir(sprintf('%s/generated/%s', dataset_chemin, name0));
        
        X_cell = {};  % stocke chaque vecteur dans une cellule
        count = 0;
        for i = 1:length(d)
            if length(d(i).name) < 4
                continue;
            end
        
            [~, nn, ext] = fileparts(d(i).name);
        
            if strcmpi(ext, ".wav")
                if mod( round(i/length(d) * 100), 25) ==0
                    fprintf(1, "Progress %.2f %% \n", i/length(d) * 100);
                end
                % Lire le fichier audio
                [x, fs] = audioread( sprintf('%s/generated/%s/%s', dataset_chemin,name0, d(i).name) );
        
                % Calculer les features
                feats = F_audioQ_desc(x, fs);
        
                % Ajouter dans la cellule
                count = count + 1;
                X_cell{count} = feats;
            end
        end
        
        fprintf(1, 'Done.\n')
        % Convertir en matrice finale
        X{i_ref} = cell2mat(X_cell');  % transpose si chaque 'feats' est un vecteur ligne
    end
end


save('AQFeatures.mat')
 


