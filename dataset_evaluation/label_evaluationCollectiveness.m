% Compute the ROC curves and correlation between collectiveness/velocity
% Order and human scores.
clear
load('humanGT.mat');
load('collectivenessVideoResult.mat');
collectivenessClips=cell2mat(collectivenessData(2,:));
velocityOrderClips=cell2mat(velocityOrderData(2,:));

%% evaluation criteria 1
% sum the scores and computing the coefficient between the scores and
% collectiveness
GT_table = GT_human;
GT_mean=sum(GT_table,1);
figure
subplot(1,2,1),scatter(collectivenessClips,GT_mean) 
r=corrcoef(collectivenessClips,GT_mean);
title(['Collectiveness coefficient=' num2str(r(2,1))])

figure
subplot(1,2,1),scatter(velocityOrderClips,GT_mean) 
r=corrcoef(velocityOrderClips,GT_mean);
title(['VelocityOrder coefficient=' num2str(r(2,1))])

%% evaluation criteria 2
% majority voting to get the category of each clip
clipLabel_majorvoting=mode(GT_table); % 
curIndex_high=find(clipLabel_majorvoting==2);
curIndex_mid=find(clipLabel_majorvoting==1);
curIndex_low=find(clipLabel_majorvoting==0);
interval=[0:0.05:1];
n_low=hist(collectivenessClips(curIndex_low),interval);
n_mid=hist(collectivenessClips(curIndex_mid),interval);
n_high=hist(collectivenessClips(curIndex_high),interval);
subplot(1,2,2),bar(interval',[n_low;n_mid;n_high]')

%% compute the ROC
collectiveness_high=collectivenessClips(1,curIndex_high);
collectiveness_low=collectivenessClips(1,curIndex_low);
collectiveness_mid=collectivenessClips(1,curIndex_mid);

velocityOrder_high=velocityOrderClips(1,curIndex_high);
velocityOrder_low=velocityOrderClips(1,curIndex_low);
velocityOrder_mid=velocityOrderClips(1,curIndex_mid);

figure,
[ TPRset, FPRset, accuracySet, threshold_set] = returnROC(  collectiveness_high,collectiveness_low );
[maxAccuracy,maxIndex]=max(accuracySet);
maxThreshold=threshold_set(maxIndex);
display(['Collectiveness Best Accuracy for High-Low=' num2str(maxAccuracy) ',best Boundary=' num2str(maxThreshold)]);
[FPRset_sort,index]=sort(FPRset,'ascend');
TPRset_sort=TPRset(index);
subplot(1,3,1),plot(FPRset_sort,TPRset_sort),


[ TPRset, FPRset, accuracySet, threshold_set] = returnROC(  velocityOrder_high,velocityOrder_low );
[maxAccuracy,maxIndex]=max(accuracySet);
maxThreshold=threshold_set(maxIndex);
display(['VelocityOrder Best Accuracy for High-Low=' num2str(maxAccuracy) ',best Boundary=' num2str(maxThreshold)]);
[FPRset_sort,index]=sort(FPRset,'ascend');
TPRset_sort=TPRset(index);
hold on,plot(FPRset_sort,TPRset_sort,'r'),title('ROC curve:High-Low');

[ TPRset, FPRset, accuracySet, threshold_set] = returnROC(  collectiveness_high,collectiveness_mid );
[maxAccuracy,maxIndex]=max(accuracySet);
maxThreshold=threshold_set(maxIndex);
display(['Collectiveness Best Accuracy for High-Mid=' num2str(maxAccuracy) ',best Boundary=' num2str(maxThreshold)]);

[FPRset_sort,index]=sort(FPRset,'ascend');
TPRset_sort=TPRset(index);
subplot(1,3,2),plot(FPRset_sort,TPRset_sort),

[ TPRset, FPRset, accuracySet, threshold_set] = returnROC( velocityOrder_high,velocityOrder_mid );
[maxAccuracy,maxIndex]=max(accuracySet);
maxThreshold=threshold_set(maxIndex);
display(['VelocityOrder Best Accuracy for High-Mid=' num2str(maxAccuracy) ',best Boundary=' num2str(maxThreshold)]);
[FPRset_sort,index]=sort(FPRset,'ascend');
TPRset_sort=TPRset(index);
hold on,plot(FPRset_sort,TPRset_sort,'r'),title('ROC curve:High-Mid');


[ TPRset, FPRset, accuracySet, threshold_set] = returnROC( collectiveness_mid,collectiveness_low );
[maxAccuracy,maxIndex]=max(accuracySet);
maxThreshold=threshold_set(maxIndex);
display(['Collectiveness Best Accuracy for Mid-Low=' num2str(maxAccuracy) ',best Boundary=' num2str(maxThreshold)]);
[FPRset_sort,index]=sort(FPRset,'ascend');
TPRset_sort=TPRset(index);
subplot(1,3,3),plot(FPRset_sort,TPRset_sort),

[ TPRset, FPRset, accuracySet, threshold_set] = returnROC( velocityOrder_mid,velocityOrder_low );
[maxAccuracy,maxIndex]=max(accuracySet);
maxThreshold=threshold_set(maxIndex);
display(['VelocityOrder Best Accuracy for Mid-Low=' num2str(maxAccuracy) ',best Boundary=' num2str(maxThreshold)]);

[FPRset_sort,index]=sort(FPRset,'ascend');
TPRset_sort=TPRset(index);
hold on,plot(FPRset_sort,TPRset_sort,'r'),title('ROC curve:Mid-Low');