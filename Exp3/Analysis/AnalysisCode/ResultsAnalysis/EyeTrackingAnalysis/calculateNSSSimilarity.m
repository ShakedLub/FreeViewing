function Results=calculateNSSSimilarity(fixations,FixMaps,Paths,Param)
%% calculate measure
%the NSS inter observer congruency is calculated according to:
%Abeles, D., Amit, R., & Yuval-Greenberg, S. (2018). Oculomotor behavior during non-visual tasks: The role of visual saliency. PloS one, 13(6), e0198242.?
PlotFlag=0;
sigma=Param.pixels_per_vdegree/2;

for ii=1:size(FixMaps,2) %images
    Results.image(ii).img=FixMaps(ii).img;
    for kk=1:size(FixMaps(ii).condition,2) %condition
        if kk==1
            COND='U';
        elseif kk==2
            COND='C';
        end
        
        if ~isempty(fixations(ii).condition(kk).subject) && size(fixations(ii).condition(kk).subject,2)>=Param.minSubjPerImageNSSSimilarity
            for jj=1:size(FixMaps(ii).condition(kk).subject,2) %subjects
                Results.image(ii).condition(kk).subject(jj).subjNum=FixMaps(ii).condition(kk).subject(jj).subjNum;
                Results.image(ii).condition(kk).subject(jj).TrialNumberOverall=FixMaps(ii).condition(kk).subject(jj).TrialNumberOverall;
                
                mapIm=[];
                %create sailency map without subject jj
                subjectswithoutone=1:size(FixMaps(ii).condition(kk).subject,2);
                subjectswithoutone(subjectswithoutone==jj)=[];
                
                for bb=subjectswithoutone
                    if isempty(mapIm)
                        mapIm=FixMaps(ii).condition(kk).subject(bb).mapPerImAndSubj;
                    else
                        mapIm=mapIm+FixMaps(ii).condition(kk).subject(bb).mapPerImAndSubj;
                    end
                end
                mapIm=mapIm./length(subjectswithoutone);
                fixMapIm = imgaussfilt(mapIm,sigma,'Padding','symmetric'); 
                
                %calculate NSS
                fix_h=fixations(ii).condition(kk).subject(jj).processed.fix_h_final;
                fix_w=fixations(ii).condition(kk).subject(jj).processed.fix_w_final;
                Results.image(ii).condition(kk).subject(jj).NSSSimPerSubj = NSS(fixMapIm,fix_h,fix_w,sigma);
            end
            Results.meanNSSSimilarityPerImage(ii,kk)= mean([Results.image(ii).condition(kk).subject.NSSSimPerSubj]);
            
            if PlotFlag
                figure
                numsubj=size(FixMaps(ii).condition(kk).subject,2);
                for aa=1:numsubj %subjects
                    %fixation map for each subject
                    subplot(ceil(sqrt(numsubj+2)),ceil(sqrt(numsubj+2)),aa)
                    imshow(imgaussfilt(FixMaps(ii).condition(kk).subject(aa).mapPerImAndSubj,sigma,'Padding','symmetric'),[])
                    title(sprintf('Fixation map subj %g, Congruency: %g',aa,Results.image(ii).condition(kk).subject(aa).NSSSimPerSubj))
                end
                
                %fixation map for all subjects
                subplot(ceil(sqrt(numsubj+2)),ceil(sqrt(numsubj+2)),numsubj+1)
                ind=find('.'==FixMaps(ii).img);
                savenameFM=[FixMaps(ii).img(1:(ind-1)),COND,'.mat'];
                load([Paths.FixationMapsPath,'\',savenameFM]);
                imshow(fixMapPerIm,[])
                title(sprintf('Fixation map %s, Congruency: %g',COND,Results.meanNSSSimilarityPerImage(ii,kk)))
                
                %original image
                subplot(ceil(sqrt(numsubj+2)),ceil(sqrt(numsubj+2)),numsubj+2)
                I=imread([Paths.ImagesFolder,'\',Results.image(ii).img]);
                I=imresize(I,size(fixMapPerIm));
                imshow(I)
                title(sprintf('Original Image %s',Results.image(ii).img))
            end
        else
            Results.image(ii).condition(kk).subject=[];
            Results.meanNSSSimilarityPerImage(ii,kk)= NaN;
        end
    end
end

%delete images with nans
inddel=find(isnan(Results.meanNSSSimilarityPerImage(:,1)) | isnan(Results.meanNSSSimilarityPerImage(:,2)));
meanNSSSimilarityPerImage=Results.meanNSSSimilarityPerImage;
meanNSSSimilarityPerImage(inddel,:)=[];

%calculate mean and ste across all images
numImagesWithscore=size(meanNSSSimilarityPerImage,1);
Results.meanNSSSimilarity=mean(meanNSSSimilarityPerImage);
Results.stdNSSSimilarity=std(meanNSSSimilarityPerImage);
Results.steNSSSimilarity=std(meanNSSSimilarityPerImage)./sqrt(numImagesWithscore);

%% Plot
%%rain cloud plot
%addpath cd cbrewer
cd(Paths.RainCloudPlot)
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');

figure
d{1}=meanNSSSimilarityPerImage(:,1);
d{2}=meanNSSSimilarityPerImage(:,2);
h1 = raincloud_plot(d{1}, 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
     'box_col_match', 0);
h2 = raincloud_plot(d{2}, 'box_on', 1, 'color', cb(4,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35, 'box_col_match', 0);
legend([h1{1} h2{1}], {'Unconscious', 'Conscious'},'FontSize',20);
xlabel('NSS similarity','FontSize',22)
%set(gca, 'YLim', [-.4 1]);
box off
set(gca,'FontSize',22)

cd(Paths.EyeTrackingAnalysisFolder)
end
