function Features = feature_extractor(X,Y,Options)



% P     = vertcat(X,Y);
[m,~] = size(Y);

G1 = [];
G2 = [];
G3 = [];
G4 = [];
% calculate the covariance matrix

P = Y-ones(m,1)*mean(Y,1);
C = P.'*P./(m-1);

if Options.EigenFeatures    == 1;
    [V,D] = eig(C); % calculate the eigen values
    c = diag(D);
    %extract eigen values and normalize eigen values
    c3 = c(1)/sum(c);
    c2 = c(2)/sum(c);
    c1 = c(3)/sum(c);
    
    P     = vertcat(X,Y);
    %                    GEOMETRIC FEATURES OF CLUSTER
    
    %-------------Eigen Value Based Feature of Point Clusters--------------------%
    G1(1) = (c1-c2)/c1;                                    % Measure of Linearity (1)
    G1(2) = (c2-c3)/c1;                                    % Measure of Linearity (2)
    G1(3) = c3/c1;                                         % Measure of Spherity   (3)
    G1(4) = nthroot((c1*c2*c3), 3);                        % Measure of Omni- variance  (4)
    G1(5) =  c1-c3;                                        % Measure of Anistropy (5)
    G1(6) = -((c1 * log (c1) )...
        + (c2 * log (c2) ) + (c3 * log (c3) ));           % Measure of Eigentropy (6)
    
    G1(7)   = c1+ c2 + c1;                                 % Sum of all eigen values (7)
    G1(8)   = c3/G1(7);                                     % Change of curvature (8)
    %-------------Eigen Value Based Feature of Point Clusters--------------------%
    G1(9)   = 1 - norm(V(:,1));
    
end


if Options.RawStatFeatures  == 1
    
    %                    STATISTICAL FEATURES OF CLUSTER
    % extract statistical Features from RAW measurement for each cluster
    G2(1)  = range(Y(:,1));                               % Maximum Height Difference(13)
    G2(2)  = var(Y(:,1)) ;                                % Longitude Variance(14)
    G2(3)  = range(Y(:,2));                               % Maximum Height Difference(13)
    G2(4)  = var(Y(:,2)) ;                                % Height Variance(14)
    G2(5)  = range(Y(:,3));                               % Maximum Height Difference(13)
    G2(6)  = var(Y(:,3)) ;                                % Elevation Variance(14)
    
end

%                    GEOMETRIC FEATURES OF POINTS
% Extract Statistical Features from Projections to different Geometric Planes

if Options.GeoProjFeatures  == 1
    cluster_center        = mean(P);
    point2center_distance = pdist2(Y,X,'euclidean');
    
    proj_YZ = Y(:,2:3);
    C1      = mean(proj_YZ);
    proj_XZ = [Y(:,1) ,Y(:,3)];
    C2      = mean(proj_XZ);
    proj_XY = Y(:,1:2);
    C3      = mean(proj_XY);
    
    u1 = pdist2(proj_YZ,C1,'euclidean');
    u2 = pdist2(proj_XZ,C2,'euclidean');
    u3 = pdist2(proj_XY,C3,'euclidean');
    
    G3(1)  = mean(u1); % means of distances in YZ plane
    G3(2)  = median(u1); % means of distances in YZ plane
    G3(3)  = var(u1); % variances of distances in YZ plane
    G3(4)  = sqrt( G3(3)); % standard deviation of distances in YZ plane
    
    G3(5)  = mean(u2);    % means of distances in YZ plane
    G3(6)  = median(u2);  % means of distances in YZ plane
    G3(7)  = var(u2);     % variances of distances in YZ plane
    G3(8)  = sqrt(G3(7)); % standard deviation of distances in YZ plane
    
    G3(9)  = mean(u3);     % means of distances in YZ plane
    G3(10) = median(u3);   % means of distances in YZ plane
    G3(11) = var(u3);      % variances of distances in YZ plane
    G3(12) = sqrt(G3(11)); % standard deviation of distances in YZ plane
    
end

% %                    STATISTICAL FEATURES OF POINTS
% Extract Statistical Features from Point Adjacency Matrix
if Options.PoinAdjFeatures  == 1
    nnDist = pdist2(Y,Y,'euclidean');   % Create a Graph within the cluster
    for i  = 1: m
        nnDist(i,:) = nnDist(i,:)/max(nnDist(i,:));            % standard deviation of nearest neigbors
        G4(i,1)     = mean(nnDist(i,:));                       % Mean of nearest neigbors
        G4(i,2)     = median(nnDist(i,:));                     % Median of nearest neigbors
        G4(i,3)     = var(nnDist(i,:));                        % Variance of nearest neigbors
        G4(i,4)     = sqrt(G4(i,3));                               % standard deviation of nearest neigbors
    end
end

total  = Options.EigenFeatures + Options.PoinAdjFeatures + ...
    Options.RawStatFeatures + Options.GeoProjFeatures ;

% Return Features from only one group
if ( Options.EigenFeatures    == 1) && (total ==1);
    Features =  repmat(G1,m,1);
end

if ( Options.RawStatFeatures   == 1) && (total ==1);
    Features =  repmat(G2,m,1);
end

if ( Options.GeoProjFeatures    == 1) && (total ==1);
    Features =  repmat(G2,m,1);
end

if ( Options.PoinAdjFeatures    == 1) && (total ==1);
    Features = G4;
end

% Return Features From only two groups
if total ==2
    if  (Options.EigenFeatures ==1)&& ( Options.RawStatFeatures ==1)
        G = [G1,G2];
        Features =  repmat(G,m,1);
    end
    
    if  (Options.EigenFeatures ==1)&& (Options.GeoProjFeatures == 1)
        G = [G1,G3];
        Features =  repmat(G,m,1);
    end
    
    if  (Options.EigenFeatures ==1)&& (Options.PoinAdjFeatures ==1)
        
        Features = [ repmat(G1,m,1),G4];
    end
    if ( Options.RawStatFeatures ==1)&& ( Options.GeoProjFeatures == 1)
        G = [G2,G3];
        Features =  repmat(G,m,1);
    end
    if ( Options.RawStatFeatures ==1)&& (Options.PoinAdjFeatures ==1)
        Features = [ repmat(G2,m,1),G4];
    end
    
    if  ( Options.GeoProjFeatures    == 1)&& (Options.PoinAdjFeatures ==1)
        Features = [ repmat(G3,m,1),G4];
    end    
end


if  total ==3;
    GG = [G1,G2,G3];
   Features =  repmat(GG,m,1);
end



if  total ==4;
    GG = [G1,G2,G3];
    G =  repmat(GG,m,1);
    Features = [G4,G];
end




end

%
%
%
% % P     = vertcat(X,Y);
% [m,~] = size(Y);
%
% % calculate the covariance matrix
%
% P = Y-ones(m,1)*mean(Y,1);
% C = P.'*P./(m-1);
%
%
% [V,D] = eig(C); % calculate the eigen values
% c = diag(D);
% %extract eigen values and normalize eigen values
% c3 = c(1)/sum(c);
% c2 = c(2)/sum(c);
% c1 = c(3)/sum(c);
%
% P     = vertcat(X,Y);
% %                    GEOMETRIC FEATURES OF CLUSTER
%
% %-------------Eigen Value Based Feature of Point Clusters--------------------%
% f(1) = (c1-c2)/c1;                                    % Measure of Linearity (1)
% f(2) = (c2-c3)/c1;                                    % Measure of Linearity (2)
% f(3) = c3/c1;                                         % Measure of Spherity   (3)
% f(4) = nthroot((c1*c2*c3), 3);                        % Measure of Omni- variance  (4)
% f(5) =  c1-c3;                                        % Measure of Anistropy (5)
% f(6) = -((c1 * log (c1) )...
%     + (c2 * log (c2) ) + (c3 * log (c3) ));           % Measure of Eigentropy (6)
%
% f(7)   = c1+ c2 + c1;                                 % Sum of all eigen values (7)
% f(8)   = c3/f(7);                                     % Change of curvature (8)
% %-------------Eigen Value Based Feature of Point Clusters--------------------%
% f(9)   = 1 - norm(V(:,1));
%
% %                    STATISTICAL FEATURES OF CLUSTER
% f(10)  = range(Y(:,1));                               % Maximum Height Difference(13)
% f(11)  = var(Y(:,1)) ;                                % Longitude Variance(14)
% f(12)  = range(Y(:,2));                               % Maximum Height Difference(13)
% f(13)  = var(Y(:,2)) ;                                % Height Variance(14)
% f(14)  = range(Y(:,3));                               % Maximum Height Difference(13)
% f(15)  = var(Y(:,3)) ;                                % Elevation Variance(14)
%
% %                    GEOMETRIC FEATURES OF POINTS
% cluster_center        = mean(P);
% point2center_distance = pdist2(Y,X,'euclidean');
%
% proj_YZ = Y(:,2:3);
% C1      = mean(proj_YZ);
% proj_XZ = [Y(:,1) ,Y(:,3)];
% C2      = mean(proj_XZ);
% proj_XY = Y(:,1:2);
% C3      = mean(proj_XY);
%
% u1 = pdist2(proj_YZ,C1,'euclidean');
% u2 = pdist2(proj_XZ,C2,'euclidean');
% u3 = pdist2(proj_XY,C3,'euclidean');
%
% f(16)  = mean(u1); % means of distances in YZ plane
% f(17)  = median(u1); % means of distances in YZ plane
% f(18)  = var(u1); % variances of distances in YZ plane
% f(19)  = sqrt( f(18)); % standard deviation of distances in YZ plane
%
%
%
% f(20)  = mean(u2); % means of distances in YZ plane
% f(21)  = median(u2); % means of distances in YZ plane
% f(22)  = var(u2); % variances of distances in YZ plane
% f(23)  = sqrt(f(22)); % standard deviation of distances in YZ plane
%
%
% f(24)  = mean(u3); % means of distances in YZ plane
% f(25)  = median(u3); % means of distances in YZ plane
% f(26)  = var(u3); % variances of distances in YZ plane
% f(27)  = sqrt(f(26)); % standard deviation of distances in YZ plane
% %
% % %                    STATISTICAL FEATURES OF POINTS
% nnDist = pdist2(Y,Y,'euclidean');   % Create a Graph within the cluster
% for i  = 1: m
%     nnDist(i,:) = nnDist(i,:)/max(nnDist(i,:));            % standard deviation of nearest neigbors
%     ff(i,1)     = mean(nnDist(i,:));                       % Mean of nearest neigbors
%     ff(i,2)     = median(nnDist(i,:));                     % Median of nearest neigbors
%     ff(i,3)     = var(nnDist(i,:));                        % Variance of nearest neigbors
%     ff(i,4)     = ff(i,3)^2;                               % standard deviation of nearest neigbors
% end
% f =  repmat(f,m,1);
%
% features = [ff,f];  % Point Features and Cluster Features