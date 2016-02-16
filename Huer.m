
% switch mode
%    case 1
%        for t = 1:length(uniqueClabels)
%            clst =  uniqueClabels(t);
%            idx  = find(output==clst);
%            if length(idx)> 3  % Check if cluster satisfy minimum requirement for calculation of covariance matrix
%                data              = X(idx,1:3);          
%                features(idx,:)   = [feature_extractor(mean(data),data, Options),L(idx,1)];
%                Label (idx,:)     = L(idx,:);
%                selectedX(idx,:)  = X(idx,1:3);
%            end
%        end
%    case 2
%    % Cluster Analytcis
% uniqueClabels    = unique(output);
% numClust         = length(uniqueClabels);
% Cdata  = []; % refined  cluster index
% x      = 1;
% 
% for i = 1 :numClust  
%     idx1    = find(L(:,2)== uniqueClabels(i)) ;
%     dsubset = L(idx1,1);
%     for j = 1 : 2
%     idx11 {j,1} = find(dsubset== uniqueLabels(j)) ;   
%     h_data(i,j)    = length(idx11{j,1}  );
%     end
%     [mn,mnPos]         = min(h_data(i,:)); % find majority
%     [mx,mxPos]         = max(h_data(i,:)); % find minority
%     test(i)  = (mx/sum(h_data(i,:)))*100; % compute homogenuity score
%     
%     % filter based on homogenuity score
%     if test(i) > 75
%         zz       = repmat(uniqueClabels(i),length(idx11{mxPos,1} ),1);
%         yy       = idx11{mxPos,1};        % index of data subset 
%         Xdata    = [X(yy,:),dsubset(yy,1),zz];  % data subset, true label, cluster label
%         Cdata    =  vertcat(Cdata, Xdata );
%     else
%         
%         ivd(x) = i;
%         x = x+1;
%     end
%     Heuristic(i,:) = mn;
%     
% end
% 
% % extract Features
% clstLabel  = Cdata(:,5); 
% uniqClstLabel = unique(clstLabel);
%  for t = 1:length(uniqClstLabel)
%   clst =  uniqClstLabel(t);
%   idx  = find(clstLabel==clst);
%   if length(idx)> 3  % Check if cluster satisfy minimum requirement for calculation of covariance matrix
%   data             = Cdata(idx,1:3);
%   
%   
%   [f2]              = featureType2(data);
%   [f1]              = featureType1(mean(data) ,data);
%   f1                = repmat(f1,size(f2,1),1);
%   features(idx,:)   = [f1,f2, Cdata(idx,4)]; % Features  and Label 
%   Label (idx,:)     = Cdata(idx,4);
%   selectedX(idx,:)  = Cdata(idx,1:3);
%   end
%  end
%    otherwise
%       disp('Invalid Selection re-run the code with correct options')
% end


