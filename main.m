%========================================================================%
% Florida Institute of Technology
% College of Engineering
% Electrical and Computer Engineering Department
% ECE 5258 : Pattern Recognition
% Instructor: Dr Anagnostopulous
% Main Application Driver File
% (c) November 2015 , Ayokunle Ade-Aina, aadeaina2014 @my.fit.edu
%========================================================================%




% 1 - ground
% 
% 2 - buildings
% 
% 3 - cars
% 
% 4 - high vegetation
% 
% 5 - low vegetation



clc; clear;close all; %setup environment for fresh task
% DataPath = 'C:/Users/aadeaina2014/Documents/ECE 5258/Individual Course project/src/data';
% addpath(DataPath);
% Visualize Original Measurement

% load Oakland.mat;
% 
% idx1 = find (inputPointSet(:,4) ==1301 );
% idx2 = find (inputPointSet(:,4) ==1400 );
load GML.mat;

% ---------------------------------------------
% Samples Data Subset For Training and Testing
%----------------------------------------------

% Odd (Train)

% Even (Test)


idx1 = find (inputPointSet(:,4) ==4 );
idx2 = find (inputPointSet(:,4) ==5 );
% idx3 = find (inputPointSet(:,4) ==3 );
% idx4 = find (inputPointSet(:,4) ==4 );
% idx5 = find (inputPointSet(:,4) ==5 );

idx1 = idx1(1:2:end);
idx2 = idx2(1:2:end);
% idx3 = idx3(1:2:end);
% idx4 = idx4(1:2:end);
% idx5 = idx5(1:2:end);


idx1 = idx1(1:1500);
idx2 = idx2(1:1500);
% idx3 = idx3(1:800);
% idx4 = idx4(1:1000);
% idx5 = idx5(1:1000);
% train_id  =  vertcat(idx1,idx2,idx3,idx4,idx5);
train_id   =  vertcat(idx1,idx2);

idx1 = find (inputPointSet(:,4) ==4 );
idx2 = find (inputPointSet(:,4) ==5 );
% idx3 = find (inputPointSet(:,4) ==3 );
% idx4 = find (inputPointSet(:,4) ==4 );
% idx5 = find (inputPointSet(:,4) ==5 );

idx1 = idx1(2:2:end);
idx2 = idx2(2:2:end);
% idx3 = idx3(2:2:end);
% idx4 = idx4(2:2:end);
% idx5 = idx5(2:2:end);

idx1 = idx1(1:750);
idx2 = idx2(1:750);
% idx3 = idx3(1:800);
% idx4 = idx4(1:1000);
% idx5 = idx5(1:1000);
% 
% test_id  =  vertcat(idx1,idx2,idx3,idx4,idx5);
test_id  =  vertcat(idx1,idx2);

trainX  = inputPointSet(train_id,1:3);
trainL  = inputPointSet(train_id,4);

testX   = inputPointSet(test_id,1:3);
testL   = inputPointSet(test_id, 4);



%---------------------------------
% Visualize Classes Of Input Data
%---------------------------------
label_vector = unique(trainL);
numLabels    = length(label_vector );


visualizeClassData = 0;
visualizeClusterData = 0;

if visualizeClassData == 1
 colmap       = colormap(colorcube(numLabels*20));
for i =1:numLabels
    idx = find(trainL(:,4)==i);
    plot3(trainX(idx,1),trainX(idx,2),trainX(idx,3),'Marker','.','LineStyle','none','color',colmap(i+ 20,:)); hold on;
 disp('');
end

title('Truth')
hold off;
end




clear inputPointSet;

[Ns,Nd] =  size(trainX);

rng(1); % For reproducibility

%------------------------------------------
% Neighborhood Selection using Meanshift
%------------------------------------------

spread = 5;  % Optimal Spread Value is 8
tol    = 0.1;

% Cluster Train
 % trainClusterId = kmeans(trainX,25);
 [trainClusterId , trainCenter ] = meanShift(trainX,tol,spread); % run meanshit clustering

%[trainClusterId,~]= dbscan(trainX,10,5);
% S  = pdist2(trainX,trainX);
% [trainClusterId ]=apcluster(S); 
% Cluster Test

% testClusterId = kmeans(testX,30);
 [testClusterId, testCenter]= meanShift(testX,tol,spread);
%[testClusterId,~]=dbscan(testX,10,5);
% S = pdist2(testX,testX);
% [testClusterId ]=apcluster(S); 
C =  unique(trainClusterId);

%------------------------------------------
% Visualize Clusters Obtained by Meanshift
%------------------------------------------

numCl = length(C );


if visualizeClusterData==1
    
 colmap = colormap(colorcube(numCl*20));

for i =1:numCl
    idx = find(trainClusterId==C(i));    
    plot3(trainX(idx,1),trainX(idx,2),trainX(idx,3),'Marker','.','LineStyle','none','color',colmap(i+ 3,:)); hold on;
 disp('');
end
title('Clustering Result')
hold off;
end
trainL(:,2) = trainClusterId;
testL(:,2) = testClusterId;


%------------------------------------------
% Extract Features From Segmented Data
%------------------------------------------

uniqueTrClabels    = unique(trainClusterId);
uniqueTsClabels    = unique(testClusterId);
Options.EigenFeatures    = 1;  % Extract Eigen Value Based Features for each cluster
Options.RawStatFeatures  = 1;  % extract statistical Features from RAW measurement for each cluster
Options.GeoProjFeatures  = 1;  % Extract Statistical Features from Projections to different Planes
Options.PoinAdjFeatures  = 1;  % Extract Statistical Features from Point Adjacency Matrix

%Extract Training Features
for t = 1:length(uniqueTrClabels)
    clst =  uniqueTrClabels(t);
    idx  = find(trainClusterId==clst);
    idx2 = find(testClusterId==clst);
    if length(idx)> 3  % Check if cluster satisfy minimum requirement for calculation of covariance matrix
        data                       = trainX(idx,:);
        train_features(idx,:)   = feature_extractor(mean(data),data, Options);
        train_Label(idx,:)         = trainL(idx,:);
        selectedX(idx,:)           = trainX(idx,:);
    end
end

%Extract Test Features
for t = 1:length(uniqueTsClabels)
    clst =  uniqueTsClabels(t);    
    idx2 = find(testClusterId==clst);
     if length(idx2)> 3  % Check if cluster satisfy minimum requirement for calculation of covariance matrix
        data                   = testX(idx2,:);
        test_features(idx2,:)   = feature_extractor(mean(data),data, Options);
        test_Label(idx2,:)      = testL(idx2,:);
        final_testSet(idx2,:)   = testX(idx2,:);
    end
end

%Get Rid of Isolated Clusters
idx              = find (train_Label(:,1)==0);
idx2             = find (test_Label(:,1)==0);

train_features(idx,:)  = [];
test_features(idx2,:)  = [];
train_Label(idx,:)     = [];
test_Label(idx2,:)     = [];

%------------------------------------------
% Analyze Features within cluster
%------------------------------------------

% [~,Within,Across] =  featureRelevance(train_features,train_Label,2,sfeature);


%-------------------------------------------------------
% Train , Cross Validate and Classify Lidar Using Support Vector Machines
%-------------------------------------------------------

%22rng(1);
SVMModel = fitcsvm(train_features,train_Label(:,1),'KernelScale','auto');
csvm     = crossval(SVMModel);
[a,score] = predict(csvm.Trained{1},test_features);
 
%-----------------------------------------------------------
% Measure Classification Results
%-----------------------------------------------------------
confMat      = confusionmat(test_Label(:,1), a)%Predict using learned parameter
trainingLoss = kfoldLoss(csvm)
testLoss     = 1-sum( diag(confusionmat(test_Label(:,1), a)))/   size(test_Label,1)
trainingAcc  = 1 - kfoldLoss(csvm)
testAcc      = sum( diag(confusionmat(test_Label(:,1), a)))/   size(test_Label,1)
% disp(['Classifier Accuracy is  : ' num2str(accuracy)])
 
 %---------------------------------
 % Visualize Classification Results
 %---------------------------------
Ltest = oneOutOfC(test_Label(:,1));
a     = oneOutOfC(a);
plotconfusion(Ltest,a)


