function DispersionResutls=CalcFixationDispersion(fixations,Paths,numFixExclude)
%the dispersion is calculated according to:
%Yuval-Greenberg, S., Keren, A., Hilo, R., Paz, A., & Ratzon, N. (2019). Gaze control during simulator driving in adolescents with
%and without attention deficit hyperactivity disorder. American Journal of Occupational Therapy

for ii=1:size(fixations,2) %images
    for kk=1:size(fixations(ii).condition,2) %condition
        if ~isempty(fixations(ii).condition(kk).subject)
            for jj=1:size(fixations(ii).condition(kk).subject,2) %subjects
                if length(fixations(ii).condition(kk).subject(jj).processed.fix_w_final)>numFixExclude
                    DispersionResutls.scores(ii).condition(kk).subject(jj).horizontalDispersion=std(fixations(ii).condition(kk).subject(jj).processed.fix_w_final);
                    DispersionResutls.scores(ii).condition(kk).subject(jj).verticalDispersion=std(fixations(ii).condition(kk).subject(jj).processed.fix_h_final);
                else
                    DispersionResutls.scores(ii).condition(kk).subject(jj).horizontalDispersion=[];
                    DispersionResutls.scores(ii).condition(kk).subject(jj).verticalDispersion=[];
                end
            end
            if ~isempty([DispersionResutls.scores(ii).condition(kk).subject.horizontalDispersion])
                DispersionResutls.meanHorizontalDispersion(ii,kk)=mean([DispersionResutls.scores(ii).condition(kk).subject.horizontalDispersion]);
                DispersionResutls.meanVerticalDispersion(ii,kk)=mean([DispersionResutls.scores(ii).condition(kk).subject.verticalDispersion]);
            else
                DispersionResutls.meanHorizontalDispersion(ii,kk)=NaN;
                DispersionResutls.meanVerticalDispersion(ii,kk)=NaN;           
            end
        else
            DispersionResutls.scores(ii).condition(kk).subject(1).horizontalDispersion=[];
            DispersionResutls.scores(ii).condition(kk).subject(1).verticalDispersion=[];
            DispersionResutls.meanHorizontalDispersion(ii,kk)=NaN;
            DispersionResutls.meanVerticalDispersion(ii,kk)=NaN;
        end
    end
end
%delete images with nans
inddel=find(isnan(DispersionResutls.meanHorizontalDispersion(:,1)) | isnan(DispersionResutls.meanHorizontalDispersion(:,2)));
meanHorizontalDispersion=DispersionResutls.meanHorizontalDispersion;
meanHorizontalDispersion(inddel,:)=[];

inddel=find(isnan(DispersionResutls.meanVerticalDispersion(:,1)) | isnan(DispersionResutls.meanVerticalDispersion(:,2)));
meanVerticalDispersion=DispersionResutls.meanVerticalDispersion;
meanVerticalDispersion(inddel,:)=[];

%calculate mean and ste across all images
numImagesWithscore_horizontal=size(meanHorizontalDispersion,1);
DispersionResutls.meanDispersion_horizontal=mean(meanHorizontalDispersion);
DispersionResutls.steDispersion_horizontal=std(meanHorizontalDispersion)./sqrt(numImagesWithscore_horizontal);
DispersionResutls.stdDispersion_horizontal=std(meanHorizontalDispersion);

numImagesWithscore_vertical=size(meanVerticalDispersion,1);
DispersionResutls.meanDispersion_vertical=mean(meanVerticalDispersion);
DispersionResutls.steDispersion_vertical=std(meanVerticalDispersion)./sqrt(numImagesWithscore_vertical);
DispersionResutls.stdDispersion_vertical=std(meanVerticalDispersion);

%ttests
[~,DispersionResutls.p_horizontal,~,DispersionResutls.stats_horizontal] = ttest(meanHorizontalDispersion(:,1),meanHorizontalDispersion(:,2),'Tail','right');
[~,DispersionResutls.p_vertical,~,DispersionResutls.stats_vertical] = ttest(meanVerticalDispersion(:,1),meanVerticalDispersion(:,2),'Tail','right');

%rain cloud plot
%addpath cd cbrewer
cd(Paths.RainCloudPlot)
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');

subplot(1, 3, 2)
d{1}=meanHorizontalDispersion(:,1);
d{2}=meanHorizontalDispersion(:,2);
h1 = raincloud_plot(d{1}, 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
     'box_col_match', 0);
h2 = raincloud_plot(d{2}, 'box_on', 1, 'color', cb(4,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35, 'box_col_match', 0);
%legend([h1{1} h2{1}], {'Unconscious', 'Conscious'},'FontSize',18);
xlabel('Horizontal dispersion','FontSize',22)
%set(gca, 'YLim', [-.01 .025]);
box off
set(gca,'FontSize',22)

subplot(1, 3, 3)
d{1}=meanVerticalDispersion(:,1);
d{2}=meanVerticalDispersion(:,2);
h1 = raincloud_plot(d{1}, 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
     'box_col_match', 0);
h2 = raincloud_plot(d{2}, 'box_on', 1, 'color', cb(4,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35, 'box_col_match', 0);
%legend([h1{1} h2{1}], {'Unconscious', 'Conscious'},'FontSize',18);
xlabel('Vertical dispersion','FontSize',22)
%set(gca, 'YLim', [-.02 .045]);
box off
set(gca,'FontSize',22)

cd(Paths.EyeTrackingAnalysisFolder)
end