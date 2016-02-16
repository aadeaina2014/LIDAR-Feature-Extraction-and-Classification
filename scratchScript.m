clc; clear;close all; %setup environment for fresh task
% DataPath = 'C:/Users/aadeaina2014/Documents/ECE 5258/Individual Course project/src/data';
% addpath(DataPath);

load Oakland.mat;

idx1 = find (inputPointSet(:,4) ==1301 );
idx2 = find (inputPointSet(:,4) ==1400 );


X = vertcat (inputPointSet(idx1,:),inputPointSet(idx2,:));

clear inputPointSet;


[Ns,Nd] =  size(X);

% Generate Subset;


idx     = round(linspace(1,Ns,round(Ns/10) )); 
L = X(idx,4);
X = X(idx,1:3);

Ns2 =  size(X,1);

for y = 3
    
    % round(0.20 * Ns2)
idx     = round(linspace(1,Ns2, 100 ));  % intitalize starting position
spread  = 0.00025;  %  Define kernel Spread  0.00001
tol     = 0.006; % Define shift tolerance


for i = 1: length(idx)
    
Xm_new   = X(idx(i),:) ;  % set start position for mode search




Xm_diff =  1;% initialize mean differe

x = 1;

%Begin Mode Search
while norm (Xm_diff) > tol  % search termination
Xm      = Xm_new;   
Xm      = repmat(Xm,Ns2,1);
Xc      = (Xm - X) .^2; % Compute Euclidean Distance
gX      = sum(Xc, 2)/spread; 
gX      = inv ((2* pi)^Nd/2)*exp(-gX/2);  % compute kernel
gXX     = bsxfun(@times,gX, X);
sum_gXX = sum(gXX);
sum_gX  = sum(gX); %sum over kernel
Xm_old  = Xm_new; %set old mode
Xm_new  = sum_gXX/sum_gX;  % compute new mode
Xm_diff = abs(Xm_old  - Xm_new);

x       = x+1; % iteration counter for mode search

% Check Convergence
if norm (Xm_diff) < tol
    status  = 1;  % mode has been found
else
    status  = 0; % mode has not been found
end


end
disp('iteration')
x

mode(i,:) = Xm_new;

end
% Terminate Mode Search if convergence occurs

mode = round(mode);


% find converged mode and make them cluster centers
Center = unique (mode,'rows');

for j = 1 : size(Center,1) 
 dist       =   pdist2(Center(j,:),X)';
 cdist(:,j) =   dist;
end


for k = 1 : Ns2
     [mval,mPos] = min (round (cdist(k,:)) );
     label(k,:) = mPos; 
     minDist(k,:)= mval; 
end

clabel(:,y)           = label;
clusterCenters {1,y}  = Center;



end








% How to eliminate Merged Clusters



L(:,2)= label;
uniqueLabel = unique(clabel);




% Post Clustering Processing
for i = 1:length(uniqueLabel)
idx =  find (   L(:,2) ==uniqueLabel(i)  );
count(i) = length(idx)  ;  
hm(i)= length(unique (L(idx,1))); % extract number of homogenous clusters

% seg  = L(idx,:);
% segLabel = unique(seg(:,1));
% for  p  = 1: length(unique(seg(:,1)));
% 
% hst(p)= length(find(segLabel(:,1)== p)); % extract number of homogenous clusters
% 
% end
% figure;
% hist(hst)

end

figure;
hist(hm,2)


