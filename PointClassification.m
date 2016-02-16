% 
%  load  ProjectData.mat;

% [coeff,score,latent,tsquared,explained] = pca(features);

% sum1 =0
% for i  = 1: length(explained)
%    sum1 = sum1+ explained(i);
%    cm(i) = sum1;
% end
%     
% 
% Z = ones(size(features,1),10);
% for i  = 1:2
% Z(:,i) =  features*coeff(:,i);
% end



f        = features; % [, features(:,24:56), features(:,58)];
train    = f(1:2:end,:);
test     = f(2:2:end,:);
Ltrain   = Label(1:2:end,:);
svm      = fitcsvm(train,Ltrain);            % Train Classifier
Ltest    = Label(2:2:end,:);

[a,~,~]= predict(svm,test);
 L      = loss(svm,train,Ltrain) 

confMat = confusionmat(Ltest, a)%Predict using learned parameter
 
accuracy = sum( diag(confusionmat(Ltest, a)))/   size(Ltest,1);
disp(['Classifier Accuracy is  : ' num2str(accuracy)])
 
 

 recall    = confMat(1,1)/  sum (confMat(:,1))  %(Sensitivity)
 precision = confMat(1,1)/  sum (confMat(1,:))
 F_measure = (2* precision * recall)/(precision + recall)
 FPR       =   confMat(1,2)/(confMat(2,2)+confMat(1,2))%(false Alarm rate)
 TPR       =  1- FPR % (Specificity)
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
%  plot(FPR,TPC) % ROC space
