function b=ErrorBarOnGroupedBarsWithScatter(model_series,model_error,model_data,colors)
b = bar(model_series, 'grouped');
hold on

% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(model_series); %group are visiblity condition and experiment number
%bars are PAS number

%find the number of participants
nsubj=size(model_data{1,1},1);

% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));

% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars %num PAS options
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    
    for j=1:length(x) %ngroups
        scatter(x(j)*ones(1,length(model_data{j,i})),model_data{j,i},40,'MarkerFaceColor',colors(i,:),'MarkerEdgeColor',[0 0 0])
        if i==1 && j==1
            hold on
        end
    end
end

%add lines connecting participants
% xbarcolor1 = (1:ngroups) - groupwidth/2 + (2*1-1) * groupwidth / (2*nbars);
% xbarcolor2 = (1:ngroups) - groupwidth/2 + (2*2-1) * groupwidth / (2*nbars);
% xbarcolor3 = (1:ngroups) - groupwidth/2 + (2*3-1) * groupwidth / (2*nbars);
% xbarcolor4 = (1:ngroups) - groupwidth/2 + (2*4-1) * groupwidth / (2*nbars);
% for i=1:ngroups %ngroups (visibility conditions and experiment number)
%     for ii=1:nsubj %subjects
%         line([xbarcolor1(i),xbarcolor2(i),xbarcolor3(i),xbarcolor4(i)],[model_data{i,1}(ii),model_data{i,2}(ii),model_data{i,3}(ii),model_data{i,4}(ii)],'Color',[0.8 0.8 0.8],'Linewidth',0.1)
%     end
% end

% Set the position of each error bar in the centre of the main bar
for i = 1:nbars %num PAS options
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none','lineWidth',1);
end
hold off
end