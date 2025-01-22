function Results=calculateNSSSimilarity(FixMaps,Paths,Param)
%the NSS inter observer congruency is calculated according to:
%Abeles, D., Amit, R., & Yuval-Greenberg, S. (2018). Oculomotor behavior during non-visual tasks: The role of visual saliency. PloS one, 13(6), e0198242.?
PlotFlag=0;
sigma=Param.pixels_per_vdegree/2;

for ii=1:size(FixMaps,2) %images
    Results.image(ii).img=FixMaps(ii).img;
    if ~isempty(FixMaps(ii).subject) && size(FixMaps(ii).subject,2)>=Param.minSubjPerImageNSSSimilarity
        for jj=1:size(FixMaps(ii).subject,2) %subjects
            Results.image(ii).subject(jj).subjNum=FixMaps(ii).subject(jj).subjNum;
            Results.image(ii).subject(jj).TrialNumberOverall=FixMaps(ii).subject(jj).TrialNumberOverall;
            
            mapIm=[];
            %create sailency map without subject jj
            subjectswithoutone=1:size(FixMaps(ii).subject,2);
            subjectswithoutone(subjectswithoutone==jj)=[];
            
            for bb=subjectswithoutone
                if isempty(mapIm)
                    mapIm=FixMaps(ii).subject(bb).mapPerImAndSubj;
                else
                    mapIm=mapIm+FixMaps(ii).subject(bb).mapPerImAndSubj;
                end
            end
            mapIm=mapIm./length(subjectswithoutone);
            fixMapIm = imgaussfilt(mapIm,sigma,'Padding','symmetric');
            
            %calculate NSS
            fix_h=FixMaps(ii).subject(jj).fix_h;
            fix_w=FixMaps(ii).subject(jj).fix_w;
            Results.image(ii).subject(jj).NSSSimPerSubj = NSS(fixMapIm,fix_h,fix_w,sigma);
        end
        Results.meanNSSSimilarityPerImage(ii)= mean([Results.image(ii).subject.NSSSimPerSubj]);

        if PlotFlag
            figure
            numsubj=size(FixMaps(ii).subject,2);
            for aa=1:numsubj %subjects
                %fixation map for each subject
                subplot(ceil(sqrt(numsubj+2)),ceil(sqrt(numsubj+2)),aa)
                imshow(imgaussfilt(FixMaps(ii).subject(aa).mapPerImAndSubj,sigma,'Padding','symmetric'),[])
                title(sprintf('Fixation map subj %g, Congruency: %g',aa,Results.image(ii).subject(aa).NSSSimPerSubj))
            end
            
            %fixation map for all subjects
            subplot(ceil(sqrt(numsubj+2)),ceil(sqrt(numsubj+2)),numsubj+1)
            ind=find('.'==FixMaps(ii).img);
            savenameFM=[FixMaps(ii).img(1:(ind-1)),'.mat'];
            load([Paths.FixationMapsPath,'\',savenameFM]);
            imshow(fixMapPerIm,[])
            title(sprintf('Fixation map, Congruency: %g',Results.meanNSSSimilarityPerImage(ii)))
            
            %original image
            subplot(ceil(sqrt(numsubj+2)),ceil(sqrt(numsubj+2)),numsubj+2)
            I=imread([Paths.ImagesFolder,'\',Results.image(ii).img]);
            I=imresize(I,size(fixMapPerIm));
            imshow(I)
            title(sprintf('Original Image %s',Results.image(ii).img))
        end
    else
        Results.image(ii).subject=[];
        Results.meanNSSSimilarityPerImage(ii)= NaN;
    end    
end

%delete images with nans
inddel=find(isnan(Results.meanNSSSimilarityPerImage));
meanNSSSimilarityPerImage=Results.meanNSSSimilarityPerImage;
meanNSSSimilarityPerImage(inddel)=[];

%calculate mean and ste across all images
numImagesWithscore=length(meanNSSSimilarityPerImage);
Results.meanNSSSimilarity=mean(meanNSSSimilarityPerImage);
Results.stdNSSSimilarity=std(meanNSSSimilarityPerImage);
Results.steNSSSimilarity=std(meanNSSSimilarityPerImage)./sqrt(numImagesWithscore);
end
