clear
close all

filename = "merged-generated.csv"; 
%"generated+distortion-lhs.csv";

function idx = get_class_index(str, classes_names)

idx = 0;

% Parcours des classes
for i = 1:length(classes_names)
    if contains(lower(str), lower(classes_names{i}))
        idx = i;
        return;
    end
end

end

classes_names = {'drumLoop' 'electric-guitar' 'male-backing-vocals' 'nylon-guitar' 'upright-bass'};

sep = ","; %'\s+'
fid = fopen(filename, "r+t");

% --- Lecture du header
headerLine = fgetl(fid);
if ~ischar(headerLine)
  error('Fichier vide ou header introuvable.');
end

% Header separe par espaces/tabulations
allHeaders = regexp(strtrim(headerLine), sep, 'split');
nCols = numel(allHeaders)+1;


allHeaders{end+1} = "classe-name";

% --- Lecture des lignes de donnees
rawLines = {};
while ~feof(fid)
    line = fgetl(fid);
        if ischar(line) && ~isempty(strtrim(line))
            rawLines{end+1,1} = line; 
        end
end

nRows = numel(rawLines);
rawTokens = cell(nRows, nCols);

    for i = 1:nRows
        line = strtrim(rawLines{i});

        % Match :
        % - soit une chaine entre guillemets, ex: "1.00"
        % - soit un bloc sans espaces
        %tokens = regexp(line, '"[^"]*"|\S+', 'match');
        tokens = regexp(line, sep, 'split');

        if numel(tokens) > nCols
            error(['Nombre de colonnes invalide a la ligne %d.\n' ...
                   'Attendu : %d, trouve : %d.\nLigne : %s'], ...
                   i+1, nCols, numel(tokens), line);
        end

        % Retire les guillemets autour des champs, si presents
        tokens = regexprep(tokens, '^"(.*)"$', '$1');
        k = get_class_index(tokens{1}, classes_names);

        if k == 0
            error("invalid index");
        end

        rawTokens(i, 1:length(tokens)) = tokens;
        rawTokens(i,end) = {sprintf('%d', k)};
    end

    % --- Conversion en numerique colonne par colonne
    numericMask = false(1, nCols);
    Xfull = nan(nRows, nCols);

    for j = 1:nCols
        col = rawTokens(:, j);
        vals = str2double(col);

        % Une colonne est consideree numerique si toutes les valeurs se convertissent
        if all(~isnan(vals))
            numericMask(j) = true;
            Xfull(:, j) = vals;
        end
    end

    Xfull = Xfull(:, numericMask);

    X = {};
    for k = 1:length(classes_names)
      I = find(Xfull(:,end) == k);

      X{k} = Xfull(I, 1:end-1);
    end
    
    f_names = allHeaders(numericMask(1:end-1));


save("Custom-AQFeatures.mat")




