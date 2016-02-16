

load Oakland.mat;
XYZ = inputPointSet;
figure;
plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'r.')



% Cluster Data

%                 --Objectives--
% (1) To obtain Homogenous Clusters in order to ensure that features are
% extracted for points truely belonging to the neigborhood
% (2) To Maximize number of Points in each Cluster in order to ensure that
% adequate information charaxterizing member points can be obtained 
% (i.e  minimum num of clusters).

svector   =  5 :1: 30; % Heuristic Search For Best Kernel Spread

for t  = 1:length(svector)

spread  = svector(t);
tol     = 0.01;


[output,cCenter] = meanShift(X, tol,spread);
L(:,2)           = output;
uniqueLabels     = [1301,1400];
uniqueClabels    = unique(output);
numClust         = length(uniqueClabels);
 
 for i = 1 :numClust
    idx1 = find(L(:,2)== uniqueClabels(i)) ;
    dsubset = L(idx1,1);
    for j = 1 : 2
    idx11          = find(dsubset== uniqueLabels(j)) ; 
    h_data(i,j)    = length(idx11);
    end
    [m,~]          = min(h_data(i,:));
    Heuristic(i,:) = m;
 end

 J(t) = sum(Heuristic);  % Number of Wrongly Clustered Points
end

plot(1:length(J),J,'r');

