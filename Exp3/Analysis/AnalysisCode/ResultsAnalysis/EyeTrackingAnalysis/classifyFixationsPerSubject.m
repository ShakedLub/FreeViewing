function Results=classifyFixationsPerSubject(fix_w,fix_h,Param)
plotFlag=0;
if ~isempty(fix_w)
    for ff=1:length(fix_h) %fixation
        %create circle mask
        [columnsInImage rowsInImage] = meshgrid(1:Param.imageSizeW, 1:Param.imageSizeH);
        centerW = fix_w(ff);
        centerH = fix_h(ff);
        circleMask = (rowsInImage - centerH).^2 + (columnsInImage - centerW).^2 <= Param.radius.^2;
        
        %classify this fixation
        if sum(Param.LowLevelSalMap_B(circleMask))>=1 && sum(Param.HighLevelfixationMap_B(circleMask))>=1
            classification(ff)=3; %high and low area
        elseif sum(Param.LowLevelSalMap_B(circleMask))>=1 && sum(Param.HighLevelfixationMap_B(circleMask))==0
            classification(ff)=1; %low area
        elseif sum(Param.LowLevelSalMap_B(circleMask))==0 && sum(Param.HighLevelfixationMap_B(circleMask))>=1
            classification(ff)=2; %high area
        elseif sum(Param.LowLevelSalMap_B(circleMask))==0 && sum(Param.HighLevelfixationMap_B(circleMask))==0
            classification(ff)=4; %background area
        end
        
        if plotFlag
            figure
            subplot(2,2,1)
            imshow(circleMask)
            title(['Circle around fixation, classification: ',num2str(classification(ff))]);
            
            subplot(2,2,2)
            imshow(Param.HighLevelfixationMap_B)
            title('High level fixation map binary')
            
            subplot(2,2,3)
            imshow(Param.LowLevelSalMap_B)
            title('Low level saliency map binary')
            
            subplot(2,2,4)
            imshow(Param.HighAndLowMap)
            title('High and low overlap Map Binary')
        end
    end
    Results.fixClassifications=classification;
    Results.numLow=sum(classification==1);
    Results.numHigh=sum(classification==2);
    Results.numLowandHigh=sum(classification==3);
    Results.numBackground=sum(classification==4);
    Results.numFix=length(classification);
else
    Results.fixClassifications=[];
    Results.numLow=0;
    Results.numHigh=0;
    Results.numLowandHigh=0;
    Results.numBackground=0;
    Results.numFix=0;
end
end