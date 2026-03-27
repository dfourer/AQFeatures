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


dataset_chemin = "../dataset/";    %%path to dataset

generated = "generated-raw";       %%subpath to generated samples after effects


feats_ref   = {};       %% computed features of orignals files
fname_ref   = {};       %% filename of orignals files
fname       = {};       %% filename of each component of X
X           = {};       %% Data matrix with computed features



d0 = dir(sprintf("%s/originals", dataset_chemin));
k       = 0;
for j = 1:length(d0)
    if length(d0(j).name) < 4
        continue;
    end
    [~, name0, ext0] = fileparts(d0(j).name);
    if strcmpi(ext0,".aif") || strcmpi(ext0,".wav")
        k = k+1;
        fprintf(1, 'Processing %s ...\n', name0);
        [x_tmp,Fs] = audioread(sprintf('%s/originals/%s', dataset_chemin, d0(j).name));
        [feats_ref{k}, ~, ~, ~,~, ~, f_axis,f_names] = F_audioQ_desc(x_tmp, Fs);
        
        %% processing all the generated signals
        d = dir(sprintf('%s/%s/%s', dataset_chemin,generated, name0));
        
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

                [x_tmp, fs] = audioread( sprintf('%s/%s/%s/%s', dataset_chemin,generated,name0, d(i).name) );
                feats = F_audioQ_desc(x_tmp, fs);
        
                count = count + 1;
                X_cell{count} = feats;
                fname{k}{count} = d(i).name;
            end
        end
        
        fprintf(1, 'Done.\n')

        X{k} = cell2mat(X_cell');
    end
end


save('AQFeatures.mat')
 


