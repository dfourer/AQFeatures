clear
close all


load("AQFeatures.mat");
dataset_chemin = "../../dataset/";
%dataset_chemin = "../";

fullpath = false;

csv_filename = "./generated.csv";

%generated = "generated-raw";

csv_fields = {'Filename' f_names{:}};

fp = fopen(csv_filename, 'w+t');

% write header
for i = 1:numel(csv_fields)
  fprintf(fp, '%s ', strrep(csv_fields{i},' ', '-'));
end

fprintf(fp, '\n');

d0 = dir(sprintf("%s/originals", dataset_chemin));
k = 0;
for j = 1:length(d0)
    if length(d0(j).name) < 4
        continue;
    end
    [~, name0, ext0] = fileparts(d0(j).name);
    
    if strcmpi(ext0,".aif") || strcmpi(ext0,".wav")
        k = k+1;
        fprintf(1, 'Processing %s ...\n', name0);
        if fullpath
            fprintf(fp, "./originals/%s ", d(i).name);
        else
            fprintf(fp, "%s ", d(i).name);
        end
        fprintf( fp, '%.10f ', feats_ref{k} );
        fprintf(fp , '\n');
        
        %% processing all the generated signals
        d = dir(sprintf('%s/%s/%s', dataset_chemin, generated, name0));
        
        count = 0;
        for i = 1:length(d)
            if length(d(i).name) < 4
                continue;
            end
            
            [~, nn, ext] = fileparts(d(i).name);
        
            if strcmpi(ext, ".wav")
                count = count +1;
                if mod( round(i/length(d) * 100), 25) == 0
                    fprintf(1, "Progress %.2f %% \n", i/length(d) * 100);
                end
                % Lire le fichier audio
                %[x, fs] = audioread( sprintf('%s/generated/%s/%s', dataset_chemin,name0, d(i).name) );

                if fullpath
                    fprintf(fp, "./%s/%s/%s ", generated, name0, d(i).name);
                else
                    fprintf(fp, "%s ", d(i).name);
                end

                fprintf( fp, '%.10f ', X{k}(count,:) );
                fprintf(fp , '\n');
            end
        end
        
        fprintf(1, 'Done.\n')
    end
end

fclose(fp);
