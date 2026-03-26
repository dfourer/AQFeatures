clear
close all


load("AQFeatures.mat");
dataset_chemin = "../../dataset/";


csv_filename = "./generated.csv";

%csv_fields = {"Filename" "plugindex" "plugname" "sourceindex" "sourcename" "paramindex" "amount" "peak_dB" "integrated_loudness" "integrated_loudness_range" "delta_loudness" "delta_loudness_range" "label"};

csv_fields = {'Filename' f_names{:}};

fp = fopen(csv_filename, 'w+t');

% write header
fprintf(fp, '\"%s\" ', csv_fields{1:end});
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

        %% processing all the generated signals
        d = dir(sprintf('%s/generated/%s', dataset_chemin, name0));
        
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
                fprintf(fp, "generated/%s/%s ", name0, d(i).name);
                fprintf( fp, '%.10f ', X{k}(count,:) );
                fprintf(fp , '\n');
            end
        end
        
        fprintf(1, 'Done.\n')
    end
end

fclose(fp);