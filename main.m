clc; clear;
%% setting
database = 'mcyt'; % specify database
training_sample = 10; % set the number of training sample
pflag = true; % P feature flag
C = 3; % FBU-DTW penalty factor

if strcmp(database, 'mcyt')
    subject = 100;
    sample = 50;
    gsample = 25;
elseif strcmp(database, 'susig')
    subject = 94;
    sample = 30;
    gsample = 20;
else
    error('Undefined database.');
end

%% get the feature of signature
disp('Calculating feature ...')
[Feature, L] = getFeature(database, pflag);

%% calculate the DTW distance between all samples and the training samples
disp('Calculating FBU-dtw distances ...')
if pflag
    if exist([upper(database), '_dist_p_', num2str(C), '_', num2str(training_sample), '.mat'], 'file')
        load ([upper(database), '_dist_p_', num2str(C), '_', num2str(training_sample), '.mat']);
    else
        dtw_dist = cal_dist(Feature, training_sample, C);
        disp('Saving distances matrix ...');
        save([upper(database), '_dist_p_', num2str(C), '_', num2str(training_sample), '.mat'], 'dtw_dist');
        disp('distances matrix saved.')
    end
else
    if exist([upper(database), '_dist_', num2str(C), '_', num2str(training_sample), '.mat'], 'file')
        load ([upper(database), '_dist_', num2str(C), '_', num2str(training_sample), '.mat']);
    else
        dtw_dist = cal_dist(Feature, training_sample, C);
        disp('Saving distances matrix ...');
        save([upper(database), '_dist_', num2str(C), '_', num2str(training_sample), '.mat'], 'dtw_dist');
        disp('distances matrix saved.')
    end
end

%% distance normalization
for i = 1 : subject
    for j = 1 : training_sample
        dtw_dist(i, :, j) = dtw_dist(i, :, j) / (L(i, j)); % dist/L
        dtw_dist(i, :, j+training_sample) = dtw_dist(i, :, j+training_sample) / (L(i, j)); % dist/L
    end
end
 
%% Gauss probability distribution estimation
Gref_mean = zeros(subject, 1);
Gref_std = Gref_mean;
Gtest_mean = zeros(subject, sample);
Gtest_std = Gtest_mean;

for i = 1 : subject
    temArray = dtw_dist(i, 1:training_sample, :);
    temArray = temArray(:);
    temArray(temArray == 0) = [];
    Gref_mean(i) = mean(temArray);
    Gref_std(i) = std(temArray);
    
    for j = 1 : training_sample
        temArray = dtw_dist(i, j, :);
        temArray(temArray == 0) = [];
        Gtest_mean(i, j) = mean(temArray);
        Gtest_std(i, j) = std(temArray);
    end
    for j = training_sample+1 : sample
        Gtest_mean(i, j) = mean(dtw_dist(i, j, :));
        Gtest_std(i, j) = std(dtw_dist(i, j, :));
    end
end

%% score normalization
score = zeros(subject, sample);
% ID_2
thre = 0.7 * ((Gtest_mean(i, j)-Gref_mean(i))^2 / (Gref_std(i)^2) + 1);
if (Gtest_std(i, j)^2 / Gref_std(i)^2) >= thre
    % We find it better to use 0.4 than 0.3 proposed in the paper.
    score(i, j) = (Gtest_mean(i, j) - Gref_mean(i)) * (Gtest_std(i, j) / Gref_std(i)) ^ 0.4;
else
    score(i, j) = (Gtest_mean(i, j) - Gref_mean(i)) * (Gref_std(i) / Gtest_std(i, j)) ^ 0.4;
end

%% calculate EER
range = 0 : 0.01 : 2;
FA = zeros(1, length(range));
FR = FA;
k = 0;
for thre = range
%     thre = 0.933;
    k = k + 1;
    for i = 1 : subject
        for j = training_sample+1 : gsample
            if score(i, j) >= thre
                FR(k) = FR(k) + 1;
            end
        end
        for j = gsample+1 : sample
            if score(i, j) < thre
                FA(k) = FA(k) + 1;
            end
        end
    end
end
[EER, TH] = ROC(FR/(gsample-training_sample)/subject, FA/(sample-gsample)/subject);

disp('Result:');
disp(sprintf('%s%s%3.4f%s%3.3f', upper(database),' EER=',EER(1), ' TH=', (range(2)-range(1))*(TH(1)-1)));
