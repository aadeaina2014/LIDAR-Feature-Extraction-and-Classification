
clc;clear;close all;
load Oakland.mat;

X = inputPointSet;

 writerObj = VideoWriter('pointClouds.avi');
 open(writerObj);
 set(gcf, 'renderer', 'zbuffer');
% plot3(X(:,1),X(:,2),X(:,3),'r.')

my_views = -210:20: 210;

load unsupervised_features.mat;
C = unique(output);

for j= 1: length(C)
  plot3(X(:,1),X(:,2),X(:,3),'g.'); hold on;
  title('Point Cloud Clustering')
  idx = find(output ==C(j));
  D   = X(idx,:);
   plot3(D(:,1),D(:,2),D(:,3),'b.'); hold off;
for i  = 1: length(my_views)
   

    view(my_views(i),26)
    zoom(1.2)
 
  drawnow;
  thisFrame = getframe(gca);
  writeVideo(writerObj, thisFrame);
  
  zoom(0.83)
end


end