function [collectivenessSet] = SPP_computeCollectiveness(curX,curVelocityDegree,para)
%SPP_COMPUTECOLLECTIVENESS Summary of this function goes here
%   Detailed explanation goes here


distanceMatrix=slmetric_pw(curX,curX,'eucdist');
correlationMatrix=cos(slmetric_pw(curVelocityDegree,curVelocityDegree,'eucdist'));
%% K-nearest neighbor adjacency matrix
neighborMatrix=zeros(size(distanceMatrix,1));
for i=1:size(distanceMatrix,1)
    [B,neighborIndex]=sort(distanceMatrix(i,:),'ascend');
    neighborMatrix(i,neighborIndex(2:para.K+1))=1;
end

%neighborMatrix=(distanceMatrix<=para.R & distanceMatrix~=0);

%%
%nNeighbor=sum(neighborMatrix,2);

weightedAdjacencyMatrix=(correlationMatrix.*neighborMatrix);%weigted adjacency matrix


[centralitySet] = SPP_katzCentrality(weightedAdjacencyMatrix,0,para);
collectivenessSet=centralitySet;




end

