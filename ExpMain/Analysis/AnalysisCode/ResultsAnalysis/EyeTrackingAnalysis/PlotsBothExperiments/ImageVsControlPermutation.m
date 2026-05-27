function Results=ImageVsControlPermutation(Fixations_Image,Fixations_Control,Nrepetitions,parameterNames,testType,pTh)
%Initialize TempDataEmpty
for qq=1:length(parameterNames)
    TempDataEmpty.([parameterNames{qq},'_Control'])=[];
    TempDataEmpty.([parameterNames{qq},'_Image'])=[];
end

for nn=1:Nrepetitions
    %Initialize parameters
    TempData=TempDataEmpty;
    
    for ii=1:size(Fixations_Control,2) %subjects
        nTrials=min([size(Fixations_Control(ii).condition(1).trial,2),size(Fixations_Control(ii).condition(2).trial,2),size(Fixations_Image(ii).condition(1).trial,2),size(Fixations_Image(ii).condition(2).trial,2)]);
        
        ind=randperm(size(Fixations_Control(ii).condition(1).trial,2),nTrials);
        Control_U_trials=Fixations_Control(ii).condition(1).trial(ind);
        
        ind=randperm(size(Fixations_Control(ii).condition(2).trial,2),nTrials);
        Control_C_trials=Fixations_Control(ii).condition(2).trial(ind);
        
        ind=randperm(size(Fixations_Image(ii).condition(1).trial,2),nTrials);
        Image_U_trials=Fixations_Image(ii).condition(1).trial(ind);
        
        ind=randperm(size(Fixations_Image(ii).condition(2).trial,2),nTrials);
        Image_C_trials=Fixations_Image(ii).condition(2).trial(ind);
        
        for qq=1:length(parameterNames)
            if contains(parameterNames{qq},'Sacc') && ~strcmp(parameterNames{qq},'numSacc')
                TempData.([parameterNames{qq},'_Control'])(ii,1)=nanmean([Control_U_trials.(parameterNames{qq})]);
                TempData.([parameterNames{qq},'_Control'])(ii,2)=nanmean([Control_C_trials.(parameterNames{qq})]);
                TempData.([parameterNames{qq},'_Image'])(ii,1)=nanmean([Image_U_trials.(parameterNames{qq})]);
                TempData.([parameterNames{qq},'_Image'])(ii,2)=nanmean([Image_C_trials.(parameterNames{qq})]);
            else
                TempData.([parameterNames{qq},'_Control'])(ii,1)=mean([Control_U_trials.(parameterNames{qq})]);
                TempData.([parameterNames{qq},'_Control'])(ii,2)=mean([Control_C_trials.(parameterNames{qq})]);
                TempData.([parameterNames{qq},'_Image'])(ii,1)=mean([Image_U_trials.(parameterNames{qq})]);
                TempData.([parameterNames{qq},'_Image'])(ii,2)=mean([Image_C_trials.(parameterNames{qq})]);
            end
        end
    end
    
    switch testType
        case 'ANOVA'
            %Repeated measures ANOVA
            alpha=pTh;
            doplot=0;
            ttst=0;
            
            for qq=1:length(parameterNames)
                data={TempData.([parameterNames{qq},'_Image'])(:,1),TempData.([parameterNames{qq},'_Image'])(:,2);TempData.([parameterNames{qq},'_Control'])(:,1),TempData.([parameterNames{qq},'_Control'])(:,2)};
                if any(isnan(data{1,1}) | isnan(data{1,2}) | isnan(data{2,1}) | isnan(data{2,2}))
                    error('Nan value in data for Anova')
                end
                stats = rmanova2(data,alpha,doplot,ttst);
                Data.(['P1_',parameterNames{qq}])(nn)=stats.P1;
                Data.(['P2_',parameterNames{qq}])(nn)=stats.P2;
                Data.(['P12_',parameterNames{qq}])(nn)=stats.P12;
            end
    end
end
switch testType
    case 'ANOVA'
        for qq=1:length(parameterNames)
            Results.([parameterNames{qq},'_PrecentSignificant_P1'])=sum(Data.(['P1_',parameterNames{qq}])<pTh)/length(Data.(['P1_',parameterNames{qq}]));
            Results.([parameterNames{qq},'_PrecentSignificant_P2'])=sum(Data.(['P2_',parameterNames{qq}])<pTh)/length(Data.(['P2_',parameterNames{qq}]));
            Results.([parameterNames{qq},'_PrecentSignificant_P12'])=sum(Data.(['P12_',parameterNames{qq}])<pTh)/length(Data.(['P12_',parameterNames{qq}]));
        end
end
end