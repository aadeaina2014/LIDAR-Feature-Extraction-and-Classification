
% pulled from paper : Plant Specie Classification using a 3D Lidar Sensor
% and Machine Learing

function  [features] = featureType2(x )
    % x ; cluster of measured data data
    % X : complete measured data
   
    [m,~] = size(x);
     f = zeros(1,44);
    bn    =  9 ; % number of bins for histogram
    h = max(x(:,3))-min(x(:,3));
   % cluster center  
        
    cluster_center =  mean(x,1); %(Cluster Feature -1)
    
   
    u1 = pdist2(x(:,1:2),cluster_center(:,1:2),'euclidean');
    
    % maximum distance from cluster center
%     w = max(u1);
%    
%     %ratio of maximum height to maximum width  (Cluster Feature-2)
%     f(1) = h/w; % cluster_ratio_maxH2W
%     
%     % cluster density (Cluster Feature-3)
%     f(2) = size(x,1)/(pi.*(w.^2).*h); % cluster_density
%     clear h w;
   
    
    % 3D Features
    % distance of every point to cluster centroid (Point Feature Feature 4)
    point2center_distance = pdist2(x,cluster_center,'euclidean');
    
%     f(3) = mean(point2center_distance); % clusterMeanDist2Centroid
%     f(4) = median(point2center_distance); %clusterMedianDist2Centroid
%     f(5) =  (var(point2center_distance))^2; % clusterStdEvDist2Centroid 
%     
%     proj_YZ = x(:,2:3);
%     C1      = mean(proj_YZ);
%     proj_XZ = [x(:,1) ,x(:,3)];
%     C2      = mean(proj_XZ);
%     proj_XY = x(:,1:2);
%     C3      = mean(proj_XY);
%     
%     u1 = pdist2(proj_YZ,C1,'euclidean');
%     u2 = pdist2(proj_XZ,C2,'euclidean');
%     u3 = pdist2(proj_XY,C3,'euclidean');
    % 2D Features
%     f(6)  = mean(u1); % means of distances in YZ plane
%     f(7)  = median(u1); % means of distances in YZ plane
%     f(8)  = var(u1); % variances of distances in YZ plane
%     f(9) = f(9)^2; % standard deviation of distances in YZ plane
%      
%     f(10:18) =  hist(u1,bn); % histogram of the distances to the center of the cluster
%     
%     f(19)  = mean(u2); % means of distances in YZ plane
%     f(20)  = median(u2); % means of distances in YZ plane
%     f(21)  = var(u2); % variances of distances in YZ plane
%     f(22) = f(14)^2; % standard deviation of distances in YZ plane
%     f(23:31) = hist(u2,bn); % histogram of the distances to the center of the cluster
%     
%     f(32)  = mean(u3); % means of distances in YZ plane
%     f(33)  = median(u3); % means of distances in YZ plane
%     f(34)  = var(u3); % variances of distances in YZ plane
%     f(35) = f(19)^2; % standard deviation of distances in YZ plane
%     f(36:44) = hist(u3,bn); % histogram of the distances to the center of the cluster
    
    
    clear  proj_YZ proj_XZ proj_YYY ;
    
    for i  = 1: m
    
        nnDist(i,:) = pdist2(x(:,1:3),x(i,1:3),'euclidean');   % Create a Graph within the cluster
                     
        nnDist(i,:) = nnDist(i,:)/max(nnDist(i,:));   % 
        ff(i,1)     = mean(nnDist(i,:));
        ff(i,2)     = median(nnDist(i,:));
        ff(i,3)     = var(nnDist(i,:));
        ff(i,4)     = ff(i,3)^2;
%         ff(i,5:13)  = hist(nnDist(i,:),bn);
    end
    
    f = repmat(f,m,1);
    
    %features = horzcat(point2center_distance, ff,f);
    features = horzcat(point2center_distance, ff); 
    
   
end