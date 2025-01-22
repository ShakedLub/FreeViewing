function [Results,Summary]=calculationsAttributes(Results,Param,attrNames)
FixTypes={attrNames{:},'objNoAtt'};

%Initialize matrices
Results.numExtremeObsFPPAtt=nan(size(Results.image(1).condition,2),length(attrNames));
Results.numAllObsFPPAtt=nan(size(Results.image(1).condition,2),length(attrNames));
Results.pvalFPPAtt=nan(size(Results.image(1).condition,2),length(attrNames));

Results.numExtremeObsFDPPAtt=nan(size(Results.image(1).condition,2),length(attrNames));
Results.numAllObsFDPPAtt=nan(size(Results.image(1).condition,2),length(attrNames));
Results.pvalFDPPAtt=nan(size(Results.image(1).condition,2),length(attrNames));
    
for kk=1:size(Results.image(1).condition,2) %condition
    %% real data
    clear PixelsInAtt PixelsNoAtt meanCountFixAtt meanCountFixNoAtt meanSumFixDurAtt meanSumFixDurNoAtt
    for ii=1:size(Results.image,2) %images
        PixelsInAtt(ii,:)=Results.image(ii).PixelsInAtt;
        
        meanCountFixAtt(ii,:)=Results.image(ii).condition(kk).meanCountFixAtt;
        meanCountFixNoAtt(ii)=Results.image(ii).condition(kk).meanCountFixNoAtt;
        
        meanSumFixDurAtt(ii,:)=Results.image(ii).condition(kk).meanSumFixDurAtt;
        meanSumFixDurNoAtt(ii)=Results.image(ii).condition(kk).meanSumFixDurNoAtt;
    end
    PixelsNoAtt=[Results.image.PixelsNoAtt];
    
    %fix per pix
    Results.FixPerPixAtt(kk,:)=sum(meanCountFixAtt,1)./sum(PixelsInAtt,1);
    Results.FixPerPixNoAtt(kk)=sum(meanCountFixNoAtt)/sum(PixelsNoAtt);
    
    %fix dur per pix
    for at=1:length(attrNames) %attributes
        FixDur=meanSumFixDurAtt(:,at);
        Pix=PixelsInAtt(:,at);
        inddel=isnan(FixDur);
        FixDur(inddel)=[];
        Pix(inddel)=[];
        Results.FixDurPerPixAtt(kk,at)=sum(FixDur)/sum(Pix);
    end
    Results.FixDurPerPixNoAtt(kk)=sum(meanSumFixDurNoAtt(~isnan(meanSumFixDurNoAtt)))/sum(PixelsNoAtt(~isnan(meanSumFixDurNoAtt)));
    
    %% calculations across all images (shuffled data)
    for nn=1:size(Results.shuffled,2) %iterations
        clear meanCountFixAtt meanCountFixNoAtt meanSumFixDurAtt meanSumFixDurNoAtt
        for ii=1:size(Results.shuffled(nn).image,2) %images
            meanCountFixAtt(ii,:)=Results.shuffled(nn).image(ii).condition(kk).meanCountFixAtt;
            meanCountFixNoAtt(ii)=Results.shuffled(nn).image(ii).condition(kk).meanCountFixNoAtt;
            
            meanSumFixDurAtt(ii,:)=Results.shuffled(nn).image(ii).condition(kk).meanSumFixDurAtt;
            meanSumFixDurNoAtt(ii)=Results.shuffled(nn).image(ii).condition(kk).meanSumFixDurNoAtt;
        end

        %fix per pix
        Results.condition(kk).FixPerPixAttShuffled(nn,:)=sum(meanCountFixAtt,1)./sum(PixelsInAtt,1);
        Results.condition(kk).FixPerPixNoAttShuffled(nn)=sum(meanCountFixNoAtt)/sum(PixelsNoAtt);
        
        %fix dur per pix
        for at=1:length(attrNames) %attributes
            FixDur=meanSumFixDurAtt(:,at);
            Pix=PixelsInAtt(:,at);
            inddel=isnan(FixDur);
            FixDur(inddel)=[];
            Pix(inddel)=[];
            Results.condition(kk).FixDurPerPixAttShuffled(nn,at)=sum(FixDur)/sum(Pix);
        end
        Results.condition(kk).FixDurPerPixNoAttShuffled(nn)=sum(meanSumFixDurNoAtt(~isnan(meanSumFixDurNoAtt)))/sum(PixelsNoAtt(~isnan(meanSumFixDurNoAtt)));
    end
    
    % P values
    Results.numExtremeObsFPPAtt(kk,Param.EFAtt)=sum(Results.condition(kk).FixPerPixAttShuffled(:,Param.EFAtt)>=Results.FixPerPixAtt(kk,Param.EFAtt))+1;
    Results.numAllObsFPPAtt(kk,Param.EFAtt)=length(Results.condition(kk).FixPerPixAttShuffled(:,Param.EFAtt))+1;
    Results.pvalFPPAtt(kk,Param.EFAtt)=Results.numExtremeObsFPPAtt(kk,Param.EFAtt)/Results.numAllObsFPPAtt(kk,Param.EFAtt);
    
    Results.numExtremeObsFDPPAtt(kk,Param.EFAtt)=sum(Results.condition(kk).FixDurPerPixAttShuffled(:,Param.EFAtt)>=Results.FixDurPerPixAtt(kk,Param.EFAtt))+1;
    Results.numAllObsFDPPAtt(kk,Param.EFAtt)=length(Results.condition(kk).FixDurPerPixAttShuffled(:,Param.EFAtt))+1;
    Results.pvalFDPPAtt(kk,Param.EFAtt)=Results.numExtremeObsFDPPAtt(kk,Param.EFAtt)/Results.numAllObsFDPPAtt(kk,Param.EFAtt);
end
Results.FixTypes=FixTypes;

%% save data
%FPP
Summary.numExtremeObsFPPAtt=Results.numExtremeObsFPPAtt;
Summary.numAllObsFPPAtt=Results.numAllObsFPPAtt;
Summary.pvalFPPAtt=Results.pvalFPPAtt;

Summary.FixPerPixAtt=Results.FixPerPixAtt;
Summary.condition(1).FixPerPixAttShuffled=Results.condition(1).FixPerPixAttShuffled;
Summary.condition(2).FixPerPixAttShuffled=Results.condition(2).FixPerPixAttShuffled;

Summary.FixPerPixNoAtt=Results.FixPerPixNoAtt;
Summary.condition(1).FixPerPixNoAttShuffled=Results.condition(1).FixPerPixNoAttShuffled;
Summary.condition(2).FixPerPixNoAttShuffled=Results.condition(2).FixPerPixNoAttShuffled;

%FDPP
Summary.numExtremeObsFDPPAtt=Results.numExtremeObsFDPPAtt;
Summary.numAllObsFDPPAtt=Results.numAllObsFDPPAtt;
Summary.pvalFDPPAtt=Results.pvalFDPPAtt;

Summary.FixDurPerPixAtt=Results.FixDurPerPixAtt;
Summary.condition(1).FixDurPerPixAttShuffled=Results.condition(1).FixDurPerPixAttShuffled;
Summary.condition(2).FixDurPerPixAttShuffled=Results.condition(2).FixDurPerPixAttShuffled;

Summary.FixDurPerPixNoAtt=Results.FixDurPerPixNoAtt;
Summary.condition(1).FixDurPerPixNoAttShuffled=Results.condition(1).FixDurPerPixNoAttShuffled;
Summary.condition(2).FixDurPerPixNoAttShuffled=Results.condition(2).FixDurPerPixNoAttShuffled;

%% plot
figure
rows=1;
columns=2;
%fix per pix
plotNum=1;
%U
realVal1=Results.FixPerPixAtt(1,Param.EFAtt);
vecReptitions1=Results.condition(1).FixPerPixAttShuffled(:,Param.EFAtt);
%C
realVal2=Results.FixPerPixAtt(2,Param.EFAtt);
vecReptitions2=Results.condition(2).FixPerPixAttShuffled(:,Param.EFAtt);
prc=95;
xlabelText='Fixation per pixel';
titleText=Results.FixTypes{Param.EFAtt};
plotPermutationAnalysis(rows,columns,plotNum,realVal1,vecReptitions1,realVal2,vecReptitions2,prc,xlabelText,titleText)

%fix dur per pix
plotNum=2;
%U
realVal1=Results.FixDurPerPixAtt(1,Param.EFAtt);
vecReptitions1=Results.condition(1).FixDurPerPixAttShuffled(:,Param.EFAtt);
%C
realVal2=Results.FixDurPerPixAtt(2,Param.EFAtt);
vecReptitions2=Results.condition(2).FixDurPerPixAttShuffled(:,Param.EFAtt);
prc=95;
xlabelText='Fixation duration per pixel';
titleText=Results.FixTypes{Param.EFAtt};
plotPermutationAnalysis(rows,columns,plotNum,realVal1,vecReptitions1,realVal2,vecReptitions2,prc,xlabelText,titleText)

end