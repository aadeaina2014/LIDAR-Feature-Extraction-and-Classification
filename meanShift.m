%========================================================================%
% Florida Institute of Technology
% College of Engineering
% Electrical and Computer Engineering Department
% Meanshift Clustering function
% (c) November 2015 , Ayokunle Ade-Aina, aadeaina2014 @my.fit.edu
%========================================================================%

function [output,cCenter] = meanShift(input, tol,spread)

Ns     = size(input,1);
hS     = spread;
tempX  = input; 
r    = sqrt(3* hS^2);                              % Spectral Search Radius
i    = 1;                                          % counteer  Variable for mode search Process

while size(tempX,1) ~=0
 
Ns     = size(tempX,1)  ;    
sPoint = randi(Ns) ;
X      = tempX(sPoint,:); 

dS     = pdist2(X, tempX(:,1:3));
idx1   = find  (dS <= r);                           % Find data subset set in spatial range

Ns     = length(idx1);                              % Calculate number of Samples within Current Neigborhood
XX1    = tempX(idx1,1:3);                           % Data belonging to cluster

Yold   = 1;
diff   = 5* tol;

%----------------------------------%
% search for mode estimate         %
%(gradient ascent/hill climbing)   %
%----------------------------------%
j = 1;

while diff > tol
    

Xc1   =  XX1 - repmat(X,Ns,1);
Xc1   =  Xc1/hS;
Xc1   =  sum(Xc1 .^2,2);                              % Compute norm of each row sample
g     =  inv( (2* pi)^1.5)  * exp(-Xc1);              % compute kernel 
gX    =  bsxfun(@times, XX1 ,g);                      % weight every point sample in the neighborhood
Yold  =  X;                                           % record previous point of acent
Y     =  sum(gX,1) / sum(g);                          % find next ascent position
Xdiff =  Yold- Y;
diff  =  norm (abs(Xdiff))                             % find difference between previous and current position
X     =   Y(:,1:3);                                    % update next point of ascent 
end

 [~,idx2,~]   = intersect(input,tempX(idx1,:),'rows'); % Get original index

cCenter (i,:) = Y;                                     % Register Converged Mode
tempX(idx1,:) = [];                                    % remove processed Data
output(idx2,1)= i;                                     % Assign Member Spectrum  to Centroid Spectrum  

i = i+1;

end

end

