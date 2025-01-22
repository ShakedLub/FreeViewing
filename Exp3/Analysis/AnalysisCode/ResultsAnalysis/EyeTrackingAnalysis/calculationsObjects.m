function [Results,Summary]=calculationsObjects(Results,Param)
if ~Param.IncludeObjNoAttInObj
    numPixObj=[Results.image.numPixObj];
else
    numPixObj=[Results.image.numPixAllObj];
end
numPixBg=[Results.image.numPixBg];

for kk=1:size(Results.image(1).condition,2) %condition
    %% real data
    clear meanCountObj meanCountBg meanSumFixDurationObj meanSumFixDurationBg
    for ii=1:size(Results.image,2) %images
        meanCountObj(ii)=Results.image(ii).condition(kk).meanCountObj;
        meanCountBg(ii)=Results.image(ii).condition(kk).meanCountBg;
        
        meanSumFixDurationObj(ii)=Results.image(ii).condition(kk).meanSumFixDurationObj;
        meanSumFixDurationBg(ii)=Results.image(ii).condition(kk).meanSumFixDurationBg;
    end
    %fix per pix
    Results.FixPerPixObj(kk)=sum(meanCountObj)/sum(numPixObj);
    Results.FixPerPixBg(kk)=sum(meanCountBg)/sum(numPixBg);
    
    %fix dur per pix
    Results.FixDurPerPixObj(kk)=sum(meanSumFixDurationObj(~isnan(meanSumFixDurationObj)))/sum(numPixObj(~isnan(meanSumFixDurationObj)));
    Results.FixDurPerPixBg(kk)=sum(meanSumFixDurationBg(~isnan(meanSumFixDurationBg)))/sum(numPixBg(~isnan(meanSumFixDurationBg)));
    
    %% shuffled data
    for nn=1:size(Results.shuffled,2) %iterations
        clear meanCountObj meanCountBg meanSumFixDurationObj meanSumFixDurationBg
        for ii=1:size(Results.shuffled(nn).image,2) %images
            meanCountObj(ii)=Results.shuffled(nn).image(ii).condition(kk).meanCountObj;
            meanCountBg(ii)=Results.shuffled(nn).image(ii).condition(kk).meanCountBg;
            
            meanSumFixDurationObj(ii)=Results.shuffled(nn).image(ii).condition(kk).meanSumFixDurationObj;
            meanSumFixDurationBg(ii)=Results.shuffled(nn).image(ii).condition(kk).meanSumFixDurationBg;           
        end
        %fix per pix
        Results.FixPerPixObjShuffled(nn,kk)=sum(meanCountObj)/sum(numPixObj);
        Results.FixPerPixBgShuffled(nn,kk)=sum(meanCountBg)/sum(numPixBg);
        
        %fix dur per pix
        Results.FixDurPerPixObjShuffled(nn,kk)=sum(meanSumFixDurationObj(~isnan(meanSumFixDurationObj)))/sum(numPixObj(~isnan(meanSumFixDurationObj)));
        Results.FixDurPerPixBgShuffled(nn,kk)=sum(meanSumFixDurationBg(~isnan(meanSumFixDurationBg)))/sum(numPixBg(~isnan(meanSumFixDurationBg)));
    end
    
    % P values    
    Results.numExtremeObsFPPObj(kk)=sum(Results.FixPerPixObjShuffled(:,kk)>=Results.FixPerPixObj(kk))+1;
    Results.numAllObsFPPObj(kk)=length(Results.FixPerPixObjShuffled(:,kk))+1;
    Results.pvalFPPObj(kk)=Results.numExtremeObsFPPObj(kk)/Results.numAllObsFPPObj(kk);
    
    Results.numExtremeObsFPPBg(kk)=sum(Results.FixPerPixBgShuffled(:,kk)<=Results.FixPerPixBg(kk))+1;
    Results.numAllObsFPPBg(kk)=length(Results.FixPerPixBgShuffled(:,kk))+1;
    Results.pvalFPPBg(kk)=Results.numExtremeObsFPPBg(kk)/Results.numAllObsFPPBg(kk);
    
    Results.numExtremeObsFDPPObj(kk)=sum(Results.FixDurPerPixObjShuffled(:,kk)>=Results.FixDurPerPixObj(kk))+1;
    Results.numAllObsFDPPObj(kk)=length(Results.FixDurPerPixObjShuffled(:,kk))+1;
    Results.pvalFDPPObj(kk)=Results.numExtremeObsFDPPObj(kk)/Results.numAllObsFDPPObj(kk);
    
    Results.numExtremeObsFDPPBg(kk)=sum(Results.FixDurPerPixBgShuffled(:,kk)<=Results.FixDurPerPixBg(kk))+1;
    Results.numAllObsFDPPBg(kk)=length(Results.FixDurPerPixBgShuffled(:,kk))+1;
    Results.pvalFDPPBg(kk)=Results.numExtremeObsFDPPBg(kk)/Results.numAllObsFDPPBg(kk);
end

%% save data
%FPP
Summary.numExtremeObsFPPObj=Results.numExtremeObsFPPObj;
Summary.numAllObsFPPObj=Results.numAllObsFPPObj;
Summary.pvalFPPObj=Results.pvalFPPObj;

Summary.numExtremeObsFPPBg=Results.numExtremeObsFPPBg;
Summary.numAllObsFPPBg=Results.numAllObsFPPBg;
Summary.pvalFPPBg=Results.pvalFPPBg;

Summary.FixPerPixObj=Results.FixPerPixObj;
Summary.FixPerPixObjShuffled=Results.FixPerPixObjShuffled;
Summary.FixPerPixBg=Results.FixPerPixBg;
Summary.FixPerPixBgShuffled=Results.FixPerPixBgShuffled;

%FDPP
Summary.numExtremeObsFDPPObj=Results.numExtremeObsFDPPObj;
Summary.numAllObsFDPPObj=Results.numAllObsFDPPObj;
Summary.pvalFDPPObj=Results.pvalFDPPObj;

Summary.numExtremeObsFDPPBg=Results.numExtremeObsFDPPBg;
Summary.numAllObsFDPPBg=Results.numAllObsFDPPBg;
Summary.pvalFDPPBg=Results.pvalFDPPBg;

Summary.FixDurPerPixObj=Results.FixDurPerPixObj;
Summary.FixDurPerPixObjShuffled=Results.FixDurPerPixObjShuffled;
Summary.FixDurPerPixBg=Results.FixDurPerPixBg;
Summary.FixDurPerPixBgShuffled=Results.FixDurPerPixBgShuffled;

%% plot
figure
rows=2;
columns=2;

%% Objects FixPerPix
plotNum=1;
%U
realVal1=Results.FixPerPixObj(1);
vecReptitions1=Results.FixPerPixObjShuffled(:,1);
%C
realVal2=Results.FixPerPixObj(2);
vecReptitions2=Results.FixPerPixObjShuffled(:,2);
prc=95;
xlabelText='fixation/pixel';
titleText='Object';
plotPermutationAnalysis(rows,columns,plotNum,realVal1,vecReptitions1,realVal2,vecReptitions2,prc,xlabelText,titleText)

%% Background FixPerPix
plotNum=2;
%U
realVal1=Results.FixPerPixBg(1);
vecReptitions1=Results.FixPerPixBgShuffled(:,1);
%C
realVal2=Results.FixPerPixBg(2);
vecReptitions2=Results.FixPerPixBgShuffled(:,2);
prc=5;
xlabelText='fixation/pixel';
titleText='Background';
plotPermutationAnalysis(rows,columns,plotNum,realVal1,vecReptitions1,realVal2,vecReptitions2,prc,xlabelText,titleText)

%% Objects FixDurPerPix
plotNum=3;
%U
realVal1=Results.FixDurPerPixObj(1);
vecReptitions1=Results.FixDurPerPixObjShuffled(:,1);
%C
realVal2=Results.FixDurPerPixObj(2);
vecReptitions2=Results.FixDurPerPixObjShuffled(:,2);
prc=95;
xlabelText='msec/pixel';
titleText=[];
plotPermutationAnalysis(rows,columns,plotNum,realVal1,vecReptitions1,realVal2,vecReptitions2,prc,xlabelText,titleText)

%% Background FixDurPerPix
plotNum=4;
%U
realVal1=Results.FixDurPerPixBg(1);
vecReptitions1=Results.FixDurPerPixBgShuffled(:,1);
%C
realVal2=Results.FixDurPerPixBg(2);
vecReptitions2=Results.FixDurPerPixBgShuffled(:,2);
prc=5;
xlabelText='msec/pixel';
titleText=[];
plotPermutationAnalysis(rows,columns,plotNum,realVal1,vecReptitions1,realVal2,vecReptitions2,prc,xlabelText,titleText)
end