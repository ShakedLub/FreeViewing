function Results=classifyFixationsRegions(fixations,Paths,Parameters)
plotFlag=0;
indDel=[];

ImSize=ceil([fixations(1).condition(1).subject(1).processed.rect(4),fixations(1).condition(1).subject(1).processed.rect(3)]);
if Parameters.RemoveCenterBias
    CenterBiasMask=CreateCenterBiasMask(Parameters.pixels_per_vdegree,Parameters.CenterBiasRadius,ImSize);
end

for ii=1:size(fixations,2) %images
    clear Param SaliencymapPerIm salmap HighLevelMap objMap LowLevelSalMap_B
    Results.image(ii).imageName=fixations(ii).img;
    
    inddot=find('.'==fixations(ii).img);
    
    %% high level fixation map
    %load combined object and non-mondrian experiment fixation map
    savenameHighMap=[fixations(ii).img(1:(inddot-1)),'.mat'];
    load([Paths.HighLevelMapsPath,'\',savenameHighMap]);
    Param.HighLevelfixationMap_B=HighLevelMap;
    
    %check correct size
    if ~isequal(ImSize, size(HighLevelMap))
        error('Problem with high level map size')
    end

    %% low level saliency map
    if Parameters.LowLevelType == 1 %load itti and Koch sliency map from saliencytoolbox
        savenameSM=[fixations(ii).img(1:(inddot-1)),'.mat'];
        load([Paths.SaliencyMapsPath,'\IttiKochModel\',savenameSM]);
        LowLevelSalMap=imresize(salmap.data,ImSize);
        
        mean_LowLevelSalMap=mean(LowLevelSalMap(:));
        std_LowLevelSalMap=std(LowLevelSalMap(:),1); %std normalized by N
        LowLevelSalMap_Z=(LowLevelSalMap-mean_LowLevelSalMap)./std_LowLevelSalMap;
        
        Param.LowLevelSalMap_B=imbinarize(LowLevelSalMap_Z);
    elseif Parameters.LowLevelType == 2 %load itti and Koch sliency map from smiler that is histogram matched to non mondrian map
        savenameSM=[fixations(ii).img(1:(inddot-1)),'.mat'];
        load([Paths.LowLevelMapsPath,'\',savenameSM]);
        
        Param.LowLevelSalMap_B=LowLevelSalMap_B;
        
        %check correct size
        if ~isequal(ImSize, size(Param.LowLevelSalMap_B))
            error('Problem with low level map size')
        end
    end
    
    %remove center bias from low and high level areas
    if Parameters.RemoveCenterBias
        Param.HighLevelfixationMap_B = CenterBiasMask & Param.HighLevelfixationMap_B;
        Param.LowLevelSalMap_B = CenterBiasMask & Param.LowLevelSalMap_B;
    end
    
    %% High and low map
    Param.HighAndLowMap=Param.LowLevelSalMap_B & Param.HighLevelfixationMap_B;
    
    %% Parameters
    Param.radius=Parameters.pixels_per_vdegree/2; %Pixels in 0.5 deg
    Param.imageSizeW = ImSize(2);
    Param.imageSizeH = ImSize(1);
    
    %% classify fixations results of experiment (real data)
    for kk=1:size(fixations(ii).condition,2) %conditions
        for jj=1:size(fixations(ii).condition(kk).subject,2) %subjects
            clear fix_w fix_h
            %fixations
            fix_w=fixations(ii).condition(kk).subject(jj).processed.fix_w_final;
            fix_h=fixations(ii).condition(kk).subject(jj).processed.fix_h_final;
            
            Results.image(ii).condition(kk).subject(jj)=classifyFixationsPerSubject(fix_w,fix_h,Param);
        end
    end
    
    %calculations per image
    Results=calculationsRegionsPerImage(Results,fixations,ii,'Real',[]);
    
    if  plotFlag
        plotFixationsTwoConditions(ii,fixations,Results,Param,Paths);
    end
    
    %number of pixels in each region
    Results.image(ii).numPixLowandHigh=sum(sum(Param.HighLevelfixationMap_B & Param.LowLevelSalMap_B));
    Results.image(ii).numPixLow=sum(sum(Param.LowLevelSalMap_B))-Results.image(ii).numPixLowandHigh;
    Results.image(ii).numPixHigh=sum(sum(Param.HighLevelfixationMap_B))-Results.image(ii).numPixLowandHigh;

    if Parameters.RemoveCenterBias
        Results.image(ii).numPixBackground=sum(sum(CenterBiasMask))-Results.image(ii).numPixLow-Results.image(ii).numPixHigh-Results.image(ii).numPixLowandHigh;

        %check calculations
        if Results.image(ii).numPixBackground+Results.image(ii).numPixHigh+Results.image(ii).numPixLow+Results.image(ii).numPixLowandHigh ~= sum(sum(CenterBiasMask))
            error('Problem with number of pixels calculations')
        end
    else
        Results.image(ii).numPixBackground=Param.imageSizeW*Param.imageSizeH-Results.image(ii).numPixLow-Results.image(ii).numPixHigh-Results.image(ii).numPixLowandHigh;
    end
    
    %% classify fixations baseline (shuffled data)
    if Parameters.shuffledDataFlag
        for nn=1:Parameters.Nrepetitions %num repetitions 
            Results.shuffled(nn).image(ii).imageName=fixations(ii).img;
            for kk=1:size(fixations(ii).shuffled(nn).condition,2)
                for jj=1:size(fixations(ii).shuffled(nn).condition(kk).subject,2) %subjects
                    clear fix_w fix_h
                    %shuffled fixations
                    fix_w=fixations(ii).shuffled(nn).condition(kk).subject(jj).fix_w_final;
                    fix_h=fixations(ii).shuffled(nn).condition(kk).subject(jj).fix_h_final;
                    
                    Results.shuffled(nn).image(ii).condition(kk).subject(jj)=classifyFixationsPerSubject(fix_w,fix_h,Param);
                end
            end
            
            %calculations per image
            Results=calculationsRegionsPerImage(Results,fixations,ii,'Shuffled',nn);
        end
    end
end
end