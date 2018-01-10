function dtw_dist = cal_dist(Feature, training_sample, C)
% calculate the DTW distance between all samples and the training samples

[subject, sample] = size(Feature);
dtw_forward_dist = zeros(subject, sample, training_sample);
dtw_backward_dist = zeros(subject, sample, training_sample);
for s = 1 : subject
    disp(sprintf('%s%d%s%d%s', 'Calculating ', s, '/', subject, ' ...'));
    for i = 1 : sample
        for j = 1 : training_sample
            if j ~= i
                [dtw_forward_dist(s,i,j), dtw_backward_dist(s,i,j)] = FBU_dtw(Feature{s,j}, Feature{s,i}, C);
            end
        end
    end
end
dtw_dist = cat(3, dtw_forward_dist, dtw_backward_dist);
