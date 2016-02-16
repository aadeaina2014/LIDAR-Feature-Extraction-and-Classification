

function  [m ,FW, FA]=  featureRelevance(features,Label,fn, featureName)

fileName  = [ 'Feature' num2str(fn) 'Report.txt'];
fileName2 = [ 'Feature_' num2str(fn) 'Report.txt'];

fileID   = fopen(fileName,'w');
fileID2  = fopen(fileName2,'w');

fprintf(fileID,'%s %s\n','Within Class Feature Relevant Report for',featureName{fn,1});
fprintf(fileID2,'%s %s\n','Across Class Feature Relevant Report for',featureName{fn,1});
C     = unique(Label(:,2))  ;
numCl = length(C );


F     = zeros(numCl,length(unique(Label(:,1))  ));
for i = 1:numCl

   idx =  find(Label(:,2)==C(i)  ); 
   Fsubset  = features(idx,:);  
   Lsubset  = Label(idx,1);
   Ls       = unique(Lsubset);
   
   
   FA(i,1) = mean(Fsubset(:,fn));  %   mean
   FA(i,2) = max(Fsubset(:,fn));   % range
   FA(i,3 )= min(Fsubset(:,fn)); % standard deviation
   FA(i,4) = max(Fsubset(:,fn))- min(Fsubset(:,fn));   % range
   FA(i,5 )= sqrt(var((Fsubset(:,fn)))); % standard deviation
   
   fprintf(fileID,'%6s %d\n','cluster',i);
   fprintf(fileID2,'%6s %d\n','cluster',i);
   fprintf(fileID2,'%s\t %f\n','Feature Mean :',  FA(i,1) );
   fprintf(fileID2,'%s\t %f \n','max :',  FA(i,2));
   fprintf(fileID2,'%s\t %f \n','min:',  FA(i,3));
   fprintf(fileID2,'%s\t %f \n','Feature Range :',  FA(i,4));
   fprintf(fileID2,'%s\t %f \n\n\n','Feature Standard  Deviation:',FA(i,5));
   
   
   for j = 1 : length(Ls)
   idx   = find(Lsubset==Ls(j));
   Fdata = Fsubset(idx,:);
   
   M(i,Ls(j))   = mean(Fdata(:,fn));
   FW(i,Ls(j),1)= mean(Fdata(:,fn));  %   mean
   FW(i,Ls(j),2)= max(Fdata(:,fn))- min(Fdata(:,fn));   % range
   FW(i,Ls(j),3 )= sqrt(var((Fdata(:,fn)))); % standard deviation
   fprintf(fileID,'%6s %d\n','Class',Ls(j));
   fprintf(fileID,'%s\t %f\n','Feature Mean :', FW(i,Ls(j),1));
   fprintf(fileID,'%s\t %f \n','Feature Range :', FW(i,Ls(j),2));
   fprintf(fileID,'%s\t %f \n\n\n','Feature Standard  Deviation:', FW(i,Ls(j),3));
   end
    
end


for k = 1:length(unique(Label(:,1))  )
m (k) = sqrt(var(M(:,k)));


end