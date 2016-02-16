
%========================================================================%
% Florida Institute of Technology
% College of Engineering
% Electrical and Computer Engineering Department
% Information Characterization and Exploitation Lab  (ICE)
% hhtp://research2.fit.edu
% (c) November 2015 , Ayokunle Ade-Aina, aadeaina2014 @my.fit.edu
%========================================================================%

% This functions extract features that help in predicting a 3D points
% semantic label

% Input
% X  : optimal Nearest Neighbors of a 3D Point
% k  : number of optimal nearest neighbours
% r  : radius of neighborhoods

% Output
% f : extracted features




function  [f]= featureType1(X,Y)

P     = vertcat(X,Y);
[m,~] = size(P);

% calculate the covariance matrix

P = P-ones(m,1)*mean(P,1);
C = P.'*P./(m-1);

[V,D] = eig(C); % calculate the eigen values
c = diag(D);
%extract eigen values and normalize eigen values
c3 = c(1)/sum(c);
c2 = c(2)/sum(c);
c1 = c(3)/sum(c);

%f = zeros(1,8);

%--------------------3D Features of 3D Point Clouds------------------------%
f(1) = (c1-c2)/c1;                                    % Measure of Linearity (1)
f(2) = (c2-c3)/c1;                                    % Measure of Linearity (2)
f(3) = c3/c1;                                         % Measure of Spherity   (3)
f(4) = nthroot((c1*c2*c3), 3);                        % Measure of Omni- variance  (4)
f(5) =  c1-c3;                                        % Measure of Anistropy (5)
f(6) = -((c1 * log (c1) )...
    + (c2 * log (c2) ) + (c3 * log (c3) ));           % Measure of Eigentropy (6)

f(7)   = c1+ c2 + c1;                                 % Sum of all eigen values (7)
f(8)   = c3/f(7);                                     % Change of curvature (8)
f(9)   = 1 - norm(V(:,1));  
f(10)  = range(Y(:,1));                               % Maximum Height Difference(13)
f(11)  = var(Y(:,1)) ;                                % Longitude Variance(14)
f(12)  = range(Y(:,2));                               % Maximum Height Difference(13)
f(13)  = var(Y(:,2)) ;                                % Height Variance(14)
f(14)  = range(Y(:,3));                               % Maximum Height Difference(13)
f(15)  = var(Y(:,3)) ;                                % Elevation Variance(14)

%  IDX  = rangesearch(X,Y,0.25,'Distance','euclidean');
%  k    = length(IDX);    % Flag
%  
%  
% f(9)   = (k + 1)/ ((4/3)* 0.25* 0.25*0.25)+1;                  % Local Point Density(9)
% f(10)  = max(abs(X(:,3)));                            % absolute height (10)
% 
% f(11)  = max(pdist2(X,Y));                            % radius of k-NN (11)
% f(12)  = 1 - norm(V(:,1));  
% f(13)  = range(P(:,3));                               % Maximum Height Difference(13)
% f(14)  = var(P(:,3)) ;                                % Height Variance(14)
% % within local Neighborhood(15)
%--------------------3D Features of 3D Point Clouds------------------------%


end
