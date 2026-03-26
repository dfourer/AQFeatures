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

load('AQFeatures.mat');
f_names{26} = 'AVSP6';

k = 2;               % fichier a afficher (cf. originals
I = [8     2    14]; %[3, 26, 23];     % indices des features a visualiser


dataset_chemin = '/home/dfourer/Recherche/Soumis/TODO/SMC-mars-2026/dataset/'; 
class_name = {};      % vecteur final de classes
individual_name = {}; % vecteur final des individus

i_ref = 0;
d0 = dir(sprintf('%s/originals', dataset_chemin));

for j = 1:length(d0)
    if length(d0(j).name) < 4
        continue;
    end
    
    [~, name0, ext0] = fileparts(d0(j).name);
    if strcmpi(ext0,".aif") || strcmpi(ext0,".wav")
        i_ref = i_ref + 1;
        class_name{i_ref} = name0;
        if i_ref == k
            d = dir(sprintf('%s/generated/%s', dataset_chemin, class_name{i_ref}));
            
            count = 0;
            
            for i = 1:length(d)
                if length(d(i).name) < 4
                    continue;
                end
                [~, nn, ext] = fileparts(d(i).name);
                if strcmpi(ext, ".wav")
                    count = count + 1;
                    % juste stocker le nom
                    individual_name{count} = nn;
                end
            end
        end
    end
end



figure
hold on

if length(I) == 2
    % Cas 2D
    plot(X{k}(:,I(1)), X{k}(:,I(2)), 'kx', 'MarkerFaceColor', 'k')  % points de la classe
    plot(feats_ref{k}(I(1)), feats_ref{k}(I(2)), 'go', 'MarkerSize', 10, 'LineWidth', 2) % référence
    xlabel(f_names{I(1)}, 'Interpreter', 'none')
    ylabel(f_names{I(2)}, 'Interpreter', 'none')  
    grid on
elseif length(I) >= 3
    % Cas 3D
    I = I(1:3);  % ne garder que 3 features max
    plot3(X{k}(:,I(1)), X{k}(:,I(2)), X{k}(:,I(3)), 'kx', 'MarkerSize', 6)  % points classe
    plot3(feats_ref{k}(I(1)), feats_ref{k}(I(2)), feats_ref{k}(I(3)), 'go', 'MarkerSize', 10, 'LineWidth', 2) % référence
    xlabel(f_names{I(1)}, 'Interpreter', 'none')
    ylabel(f_names{I(2)}, 'Interpreter', 'none') 
    zlabel(f_names{I(3)}, 'Interpreter', 'none') 
    grid on
end
hold off
title(sprintf('%s - Visualisation des features',class_name{k}))
legend('Échantillons', 'Référence')

% Activer le mode Data Cursor
dcm = datacursormode(gcf);
set(dcm,'UpdateFcn',@(obj,event) myupdatefcn(obj,event,X{k}(:,I), individual_name, dataset_chemin, class_name{k}));  
datacursormode on

%% Callback pour afficher l'indice de l'échantillon
function txt = myupdatefcn(~, event, Xk, individual_name, dataset_chemin, classname)
    pos = get(event,'Position');          % coordonnées du point cliqué
    % Chercher le point le plus proche dans Xk
    [~, idx] = min(sum((Xk - pos).^2, 2)); 
    txt = {sprintf('Index: %d (%s)', idx, strrep(individual_name{idx}, '_', '\_')), ...
           sprintf('Coords: [%s]', num2str(pos))};
    filename = sprintf('%s/generated/%s/%s.wav', dataset_chemin, classname,individual_name{idx});
    fprintf(1,'%s',filename);
    if exist(filename,'file')
        
        [x,Fs] = audioread(filename);
        clear sound
        sound(x,Fs)
        % Utiliser sound au lieu de soundsc pour éviter les conflits
        % Lancer le son dans un timer pour ne pas bloquer le callback
        %t = timer('StartDelay',0,'TimerFcn',@(~,~) sound(x,Fs));
        %start(t)
    end
end