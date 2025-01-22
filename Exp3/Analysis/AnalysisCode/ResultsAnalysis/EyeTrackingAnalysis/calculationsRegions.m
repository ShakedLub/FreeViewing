function Summary=calculationsRegions(Results)
Summary.GroupNames={'Low','High','H&L','Background'};
numPixLow=[Results.image.numPixLow];
numPixHigh=[Results.image.numPixHigh];
numPixLowandHigh=[Results.image.numPixLowandHigh];
numPixBackground=[Results.image.numPixBackground];
%save data
Summary.numPixLow=numPixLow;
Summary.numPixHigh=numPixHigh;
Summary.numPixLowandHigh=numPixLowandHigh;
Summary.numPixBackground=numPixBackground;

for kk=1:size(Results.image(1).condition,2) %condition
    %% calculations across all images (real data)
    %Pre process the data
    clear meanFixLow meanFixHigh meanFixLowandHigh meanFixBackground 
    clear meansumfixdurLow meansumfixdurHigh meansumfixdurLowandHigh meansumfixdurBackground
    for ii=1:size(Results.image,2) %images 
        %for fix per pix
        meanFixLow(ii)=Results.image(ii).condition(kk).meanLow;
        meanFixHigh(ii)=Results.image(ii).condition(kk).meanHigh;
        meanFixLowandHigh(ii)=Results.image(ii).condition(kk).meanLowandHigh;
        meanFixBackground(ii)=Results.image(ii).condition(kk).meanBackground;
        
        %for fix dur per pix
        meansumfixdurLow(ii)=Results.image(ii).condition(kk).meansumfixdurLow;
        meansumfixdurHigh(ii)=Results.image(ii).condition(kk).meansumfixdurHigh;
        meansumfixdurLowandHigh(ii)=Results.image(ii).condition(kk).meansumfixdurLowandHigh;
        meansumfixdurBackground(ii)=Results.image(ii).condition(kk).meansumfixdurBackground;
    end
    %save data
    Summary.condition(kk).meanFixLow=meanFixLow;
    Summary.condition(kk).meanFixHigh=meanFixHigh;
    Summary.condition(kk).meanFixLowandHigh=meanFixLowandHigh;
    Summary.condition(kk).meanFixBackground=meanFixBackground;
    
    Summary.condition(kk).meansumfixdurLow=meansumfixdurLow;
    Summary.condition(kk).meansumfixdurHigh=meansumfixdurHigh;
    Summary.condition(kk).meansumfixdurLowandHigh=meansumfixdurLowandHigh;
    Summary.condition(kk).meansumfixdurBackground=meansumfixdurBackground;

    %fix per pix
    Summary.condition(kk).FixPerPix(1)=sum(meanFixLow)/sum(numPixLow);
    Summary.condition(kk).FixPerPix(2)=sum(meanFixHigh)/sum(numPixHigh);
    Summary.condition(kk).FixPerPix(3)=sum(meanFixLowandHigh)/sum(numPixLowandHigh);
    Summary.condition(kk).FixPerPix(4)=sum(meanFixBackground)/sum(numPixBackground);
    
    %fix dur per pix
    Summary.condition(kk).FixDurPerPix(1)=sum(meansumfixdurLow(~isnan(meansumfixdurLow)))/sum(numPixLow(~isnan(meansumfixdurLow)));
    Summary.condition(kk).FixDurPerPix(2)=sum(meansumfixdurHigh(~isnan(meansumfixdurHigh)))/sum(numPixHigh(~isnan(meansumfixdurHigh)));
    Summary.condition(kk).FixDurPerPix(3)=sum(meansumfixdurLowandHigh(~isnan(meansumfixdurLowandHigh)))/sum(numPixLowandHigh(~isnan(meansumfixdurLowandHigh)));
    Summary.condition(kk).FixDurPerPix(4)=sum(meansumfixdurBackground(~isnan(meansumfixdurBackground)))/sum(numPixBackground(~isnan(meansumfixdurBackground)));

    %% calculations across all images (shuffled data)   
    for nn=1:size(Results.shuffled,2) %iterations
        clear meanFixLow meanFixHigh meanFixLowandHigh meanFixBackground 
        clear meansumfixdurLow meansumfixdurHigh meansumfixdurLowandHigh meansumfixdurBackground
        for ii=1:size(Results.shuffled(nn).image,2) %images
            meanFixLow(ii)=Results.shuffled(nn).image(ii).condition(kk).meanLow;
            meanFixHigh(ii)=Results.shuffled(nn).image(ii).condition(kk).meanHigh;
            meanFixLowandHigh(ii)=Results.shuffled(nn).image(ii).condition(kk).meanLowandHigh;
            meanFixBackground(ii)=Results.shuffled(nn).image(ii).condition(kk).meanBackground;           
            
            meansumfixdurLow(ii)=Results.shuffled(nn).image(ii).condition(kk).meansumfixdurLow;
            meansumfixdurHigh(ii)=Results.shuffled(nn).image(ii).condition(kk).meansumfixdurHigh;
            meansumfixdurLowandHigh(ii)=Results.shuffled(nn).image(ii).condition(kk).meansumfixdurLowandHigh;
            meansumfixdurBackground(ii)=Results.shuffled(nn).image(ii).condition(kk).meansumfixdurBackground;
        end
        %save data
        Summary.condition(kk).shuffled(nn).meanFixLow=meanFixLow;
        Summary.condition(kk).shuffled(nn).meanFixHigh=meanFixHigh;
        Summary.condition(kk).shuffled(nn).meanFixLowandHigh=meanFixLowandHigh;
        Summary.condition(kk).shuffled(nn).meanFixBackground=meanFixBackground;
        
        Summary.condition(kk).shuffled(nn).meansumfixdurLow=meansumfixdurLow;
        Summary.condition(kk).shuffled(nn).meansumfixdurHigh=meansumfixdurHigh;
        Summary.condition(kk).shuffled(nn).meansumfixdurLowandHigh=meansumfixdurLowandHigh;
        Summary.condition(kk).shuffled(nn).meansumfixdurBackground=meansumfixdurBackground;

        %fix per pix
        Summary.condition(kk).FixPerPixShuffled(nn,1)=sum(meanFixLow)/sum(numPixLow);
        Summary.condition(kk).FixPerPixShuffled(nn,2)=sum(meanFixHigh)/sum(numPixHigh);
        Summary.condition(kk).FixPerPixShuffled(nn,3)=sum(meanFixLowandHigh)/sum(numPixLowandHigh);
        Summary.condition(kk).FixPerPixShuffled(nn,4)=sum(meanFixBackground)/sum(numPixBackground);      
        
        %fix dur per pix
        Summary.condition(kk).FixDurPerPixShuffled(nn,1)=sum(meansumfixdurLow(~isnan(meansumfixdurLow)))/sum(numPixLow(~isnan(meansumfixdurLow)));
        Summary.condition(kk).FixDurPerPixShuffled(nn,2)=sum(meansumfixdurHigh(~isnan(meansumfixdurHigh)))/sum(numPixHigh(~isnan(meansumfixdurHigh)));
        Summary.condition(kk).FixDurPerPixShuffled(nn,3)=sum(meansumfixdurLowandHigh(~isnan(meansumfixdurLowandHigh)))/sum(numPixLowandHigh(~isnan(meansumfixdurLowandHigh)));
        Summary.condition(kk).FixDurPerPixShuffled(nn,4)=sum(meansumfixdurBackground(~isnan(meansumfixdurBackground)))/sum(numPixBackground(~isnan(meansumfixdurBackground))); 
    end
 
    %P values of shuffled fixations
    for gg=1:length(Summary.GroupNames)
        if gg == length(Summary.GroupNames) %background regions
            Summary.condition(kk).numExtremeObsFPP(gg)=sum(Summary.condition(kk).FixPerPixShuffled(:,gg)<=Summary.condition(kk).FixPerPix(gg))+1;
            Summary.condition(kk).numAllObsFPP(gg)=length(Summary.condition(kk).FixPerPixShuffled(:,gg))+1;
            Summary.condition(kk).pvalFPP(gg)=Summary.condition(kk).numExtremeObsFPP(gg)/Summary.condition(kk).numAllObsFPP(gg);
            
            Summary.condition(kk).numExtremeObsFDPP(gg)=sum(Summary.condition(kk).FixDurPerPixShuffled(:,gg)<=Summary.condition(kk).FixDurPerPix(gg))+1;
            Summary.condition(kk).numAllObsFDPP(gg)=length(Summary.condition(kk).FixDurPerPixShuffled(:,gg))+1;
            Summary.condition(kk).pvalFDPP(gg)=Summary.condition(kk).numExtremeObsFDPP(gg)/Summary.condition(kk).numAllObsFDPP(gg);
        else
            Summary.condition(kk).numExtremeObsFPP(gg)=sum(Summary.condition(kk).FixPerPixShuffled(:,gg)>=Summary.condition(kk).FixPerPix(gg))+1;
            Summary.condition(kk).numAllObsFPP(gg)=length(Summary.condition(kk).FixPerPixShuffled(:,gg))+1;
            Summary.condition(kk).pvalFPP(gg)=Summary.condition(kk).numExtremeObsFPP(gg)/Summary.condition(kk).numAllObsFPP(gg);
            
            Summary.condition(kk).numExtremeObsFDPP(gg)=sum(Summary.condition(kk).FixDurPerPixShuffled(:,gg)>=Summary.condition(kk).FixDurPerPix(gg))+1;
            Summary.condition(kk).numAllObsFDPP(gg)=length(Summary.condition(kk).FixDurPerPixShuffled(:,gg))+1;
            Summary.condition(kk).pvalFDPP(gg)=Summary.condition(kk).numExtremeObsFDPP(gg)/Summary.condition(kk).numAllObsFDPP(gg);
        end
    end
end
end