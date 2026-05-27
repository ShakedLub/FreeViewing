function ErrorBarOnGroupedBars(model_series,model_error)
b = bar(model_series, 'grouped');
hold on

% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(model_series);

% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));

% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
end
hold off
end