%========================================================================%
% Florida Institute of Technology
% College of Engineering
% Electrical and Computer Engineering Department
% ECE 5258 : Pattern Recognition
% Instructor: Dr Anagnostopulous
% Main Application Driver File
% (c) November 2015 , Ayokunle Ade-Aina, aadeaina2014 @my.fit.edu
%========================================================================%




clc; clear;close all; %setup environment for fresh task
% DataPath = 'C:/Users/aadeaina2014/Documents/ECE 5258/Individual Course project/src/data';
% addpath(DataPath);
% Visualize Original Measurement

load Oakland.mat;

idx1 = find (inputPointSet(:,4) ==1301 );
idx2 = find (inputPointSet(:,4) ==1400 );


X       = vertcat (inputPointSet(idx1,:),inputPointSet(idx2,:));
L       = X(:,4);
X       = X(:,1:3);
clear inputPointSet;
[Ns,Nd] =  size(X);

% Generate Subset;
idx    = round(linspace(1,Ns,round(Ns/10) ));
L      = L(idx);
X      = X(idx,:);
Ns2    = size(X,1);


   
%    S = pdist2(X,X);
%  
% 
% [output] = apcluster(S); 


[output,~] =dbscan2(X,0.85,);
C =  unique(output);
for t = 1: length(C)
    
count(t)  = length(find( output==C(t)));

end

 L(:,2)           = output;
uniqueLabels     = [1301,1400];

mode   = 1;

uniqueClabels    = unique(output);
switch mode
   case 1
       for t = 1:length(uniqueClabels)
           clst =  uniqueClabels(t);
           idx  = find(output==clst);
           if length(idx)> 3  % Check if cluster satisfy minimum requirement for calculation of covariance matrix
               data              = X(idx,1:3);          
               features(idx,:)   = [feature_extractor(mean(data),data),L(idx,1)];
               Label (idx,:)     = L(idx,1);
               selectedX(idx,:)  = X(idx,1:3);
           end
       end
   case 2
   % Cluster Analysis
uniqueClabels    = unique(output);
numClust         = length(uniqueClabels);
Cdata  = []; % refined  cluster index
x      = 1;

for i = 1 :numClust  
    idx1    = find(L(:,2)== uniqueClabels(i)) ;
    dsubset = L(idx1,1);
    for j = 1 : 2
    idx11 {j,1} = find(dsubset== uniqueLabels(j)) ;   
    h_data(i,j)    = length(idx11{j,1}  );
    end
    [mn,mnPos]         = min(h_data(i,:));
    [mx,mxPos]         = max(h_data(i,:));
    test(i)  = (mx/sum(h_data(i,:)))*100;
    if test(i) > 75
        zz       = repmat(uniqueClabels(i),length(idx11{mxPos,1} ),1);
        yy       = idx11{mxPos,1};        % index of data subset 
        Xdata    = [X(yy,:),dsubset(yy,1),zz];  % data subset, true label, cluster label
        Cdata    =  vertcat(Cdata, Xdata );
    else
        
        ivd(x) = i;
        x = x+1;
    end
    Heuristic(i,:) = mn;
    
end

clstLabel  = Cdata(:,5); 
uniqClstLabel = unique(clstLabel);
 for t = 1:length(uniqClstLabel)
  clst =  uniqClstLabel(t);
  idx  = find(clstLabel==clst);
  if length(idx)> 3  % Check if cluster satisfy minimum requirement for calculation of covariance matrix
  data             = Cdata(idx,1:3);
  
  
  [f2]              = featureType2(data);
  [f1]              = featureType1(mean(data) ,data);
  f1                = repmat(f1,size(f2,1),1);
  features(idx,:)   = [f1,f2, Cdata(idx,4)]; % Features  and Label 
  Label (idx,:)     = Cdata(idx,4);
  selectedX(idx,:)  = Cdata(idx,1:3);
  end
 end
   otherwise
      disp('Invalid Selection re-run the code with correct options')
end

% Get Rid of Isolated Clusters
idx              = find (Label==0);
features(idx,:)  = [];
Label            = features(:,end) ;
features         = features(:,1:end-1);



