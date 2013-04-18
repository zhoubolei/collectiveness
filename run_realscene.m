%% Measuring collectiveness at each frame of a video
% Mar.28 2013, Bolei Zhou
clear
addpath('util\');
curVideo = 'realcrowd\';
curTrkName = 'klt_3000_10_trk.txt';

%% Collectiveness parameter
para.K = 20;
para.lamda = 0.5/para.K ;
para.upperBound = para.K*para.lamda/(1-para.K*para.lamda);
para.threshold = 0.6*para.lamda/(1-para.K*para.lamda);

%%
curClipFrameSet = dir([curVideo '\*.jpg']);
curTrks = readTraks([curVideo '\' curTrkName]);
[XVset] = trk2XV(curTrks, 1, 2); % transform trajectories into point set

figure
for i = 1:length(curClipFrameSet)     
    curFrame = imread([curVideo '\' curClipFrameSet(i).name]);    
    curFrame = im2double(curFrame);
    curIndex = find(XVset(:, 5) == i);
    curX = XVset(curIndex,1:2);
    curV = XVset(curIndex,3:4);  
    curOrder = SDP_order(curV); % average velocity measurement
    [collectivenessSet, crowdCollectiveness, Zmatrix] = measureCollectiveness( curX, curV, para);%crowd collectiveness
    clusterIndex = collectiveMerging( Zmatrix, para ); % get clusters from Z matrix
    hold off, imshow(curFrame),hold on
    %%%%%%%%%%% plot points with different clusters at each frame
    scatter(curX(:,1),curX(:,2),'+r')
    quiver(curX(:,1),curX(:,2),curV(:,1),curV(:,2),'y'),
    for j = 1:max(clusterIndex)         
        curClusterIndex=find(clusterIndex==j);         
        scatter(curX(curClusterIndex,1),curX(curClusterIndex,2),'filled'),      
    end   
    title(['No.Points=' num2str(size(curX,1)) ',order=' num2str(curOrder) ',Collectiveness=' num2str(crowdCollectiveness)])
    drawnow
end

