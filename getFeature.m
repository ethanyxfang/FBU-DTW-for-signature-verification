function [Feature, L] = getFeature(database, pflag)

if pflag
    if exist([upper(database),'_feature_p.mat'], 'file')
        load([upper(database),'_feature_p.mat']);
        return;
    end
else
    if exist([upper(database),'_feature.mat'], 'file')
        load([upper(database),'_feature.mat']);
        return;
    end
end

if strcmp(database, 'mcyt')
    % MCYT
    addpath('MCYT\');
    Feature = cell(100, 50);
    L = zeros(100, 50);
    for subject = 1 : 100
        for sample = 1 : 50
            if sample <= 25
                path = sprintf('%s%04d%s%04d%s%02d%s', 'MCYT-100\', subject-1, '\', subject-1, 'v', sample-1, '.fpg');
            elseif sample > 25
                path = sprintf('%s%04d%s%04d%s%02d%s', 'MCYT-100\', subject-1, '\', subject-1, 'f', sample-26, '.fpg');
            end
            [x, y, p, ~, ~, ~] = FPG_Signature_Read(path, 0, 0) ;
            data = [x, y];
            if pflag
                data = [data, p];
            end
            data = getSigFeature(data, pflag);
            Feature{subject, sample} = data;
            L(subject, sample) = length(data);
        end
    end
    
elseif strcmp(database, 'susig')
    % SUSIG
    addpath('SUSIG\');
    Feature = cell(94, 30);
    L = zeros(94, 30);
    k = 0;
    for subject = 1 : 115
        if ismember(subject, [5 6 7 12 17 27 30 31 33 35 41 43 45 47 48 49 50 51 52 68 112])
            continue;
        end
        k = k + 1;
        for sample = 1 : 30
            if sample <=  10
                path = sprintf('%s%03d%s%d%s', 'SUSIG\GENUINE\SESSION1\', subject, '_1_', sample, '.sig');
            elseif sample <= 20
                path = sprintf('%s%03d%s%d%s', 'SUSIG\GENUINE\SESSION2\', subject, '_2_', sample-10, '.sig');
            elseif sample > 20
                path = sprintf('%s%03d%s%d%s', 'SUSIG\FORGERY\', subject, '_f_', sample-20, '.sig');
            end
            [x, y, ~, p, ~] = ReadSignature(path, 0);
            data = [x, y];
            if pflag
                data = [data, p];
            end
            data = getSigFeature(data, pflag);
            Feature{k, sample} = data;
            L(k, sample) = length(data);
        end
    end
end

disp('Saving feature ...');
if pflag
    save([upper(database),'_feature_p'],'Feature','L');
else
    save([upper(database),'_feature'],'Feature','L');
end
disp('Feature saved.');
