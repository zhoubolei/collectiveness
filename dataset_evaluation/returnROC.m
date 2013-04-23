function [ TPRset, FPRset, accuracySet, threshold_set] = returnROC( gt_high,gt_low )
%RETURNROC to compute the ROC curve
% Bolei Zhou, April 23, 2013
threshold_set = [0:0.02:1];
nThreshold = length(threshold_set);
TPRset = [];FPRset = [];
accuracySet = [];
for i = 1 : nThreshold
    curThreshold = threshold_set(i);
    TP = length(find(gt_high>=curThreshold));
    P = length(gt_high);
    FP = length(find(gt_low>=curThreshold));
    N = FP + length(find(gt_low<=curThreshold));
    curTPR = TP/P;
    curFPR = FP/N;
    accuracy = (TP+length(find(gt_low <= curThreshold)))/(P+N);
    TPRset = [TPRset curTPR];
    FPRset = [FPRset curFPR];
    accuracySet = [accuracySet accuracy];
end

    
end

