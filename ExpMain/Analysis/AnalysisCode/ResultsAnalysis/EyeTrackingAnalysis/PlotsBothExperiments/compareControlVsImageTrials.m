function [Results,dataImvsCon,ResultsPermutation,parameterNames,fixations_Image,fixations_Control]=compareControlVsImageTrials(fixations_Image,fixations_Control,Nrepetitions,alpha)
%% calculate saccade and fixation parameters in image and control fixations
parameterNames={'numFix','durationFix','stddurationFix','numSacc','ampSacc','stdampSacc'};

%Calculate fixation parametes for each subject image trials
[fixations_Image,dataImvsCon]=calculateFixAndSaccData(fixations_Image,[],parameterNames,'Image');

%calculate fixation parametes for each subject control trials
[fixations_Control,dataImvsCon]=calculateFixAndSaccData(fixations_Control,dataImvsCon,parameterNames,'Control');

%% plot data
%% plot box plots
figure
rows=ceil(sqrt(length(parameterNames)));
columns=ceil(sqrt(length(parameterNames)));
for qq=1:length(parameterNames)
    subplot(rows,columns,qq)
    mat=[dataImvsCon.([parameterNames{qq},'_Image'])(:,1),dataImvsCon.([parameterNames{qq},'_Control'])(:,1),dataImvsCon.([parameterNames{qq},'_Image'])(:,2),dataImvsCon.([parameterNames{qq},'_Control'])(:,2)];
    boxplot(mat,'ColorGroup',[1 2 1 2]);
    hold on;
    parallelcoords(mat, 'Color', 0.7*[1 1 1], 'LineStyle', '-','Marker', 'o', 'MarkerSize', 10);
    hold off
    ylabel(parameterNames{qq},'FontSize',18)
    set(gca,'XTick',[1.5,3.5])
    set(gca,'XTickLabel',{'U','C'},'FontSize',18)
end

%% run permutation test
%real data
%draw randomly and calculate percent significant
Results=ImageVsControlPermutation(fixations_Image,fixations_Control,Nrepetitions,parameterNames,'ANOVA',alpha);

%Permutation data
for nn=1:Nrepetitions
    %shuffle data
    [FixationsRand_Control,FixationsRand_Image]=shuffleData(fixations_Control,fixations_Image,parameterNames);
    
    %draw randomly and calculate percent significant
    ResultsPermutation(nn)=ImageVsControlPermutation(FixationsRand_Image,FixationsRand_Control,Nrepetitions,parameterNames,'ANOVA',alpha);
end

%calculate Pvalues
for kk=1:length(parameterNames)
    if kk==1
        Results.Pvalue(1).parameterName=parameterNames{kk};
        Results.Pvalue(1).effectName='P1';
        Results.Pvalue(1).numExtremeObs=sum([ResultsPermutation.([parameterNames{kk},'_PrecentSignificant_P1'])]>Results.([parameterNames{kk},'_PrecentSignificant_P1']))+1;
        Results.Pvalue(1).numAllObs=length([ResultsPermutation.([parameterNames{kk},'_PrecentSignificant_P1'])])+1;
        Results.Pvalue(1).value=Results.Pvalue(1).numExtremeObs/Results.Pvalue(1).numAllObs;
    else
        Results.Pvalue(end+1).parameterName=parameterNames{kk};
        Results.Pvalue(end).effectName='P1';
        Results.Pvalue(end).numExtremeObs=sum([ResultsPermutation.([parameterNames{kk},'_PrecentSignificant_P1'])]>Results.([parameterNames{kk},'_PrecentSignificant_P1']))+1;
        Results.Pvalue(end).numAllObs=length([ResultsPermutation.([parameterNames{kk},'_PrecentSignificant_P1'])])+1;
        Results.Pvalue(end).value=Results.Pvalue(end).numExtremeObs/Results.Pvalue(end).numAllObs;
    end
    Results.Pvalue(end+1).parameterName=parameterNames{kk};
    Results.Pvalue(end).effectName='P2';
    Results.Pvalue(end).numExtremeObs=sum([ResultsPermutation.([parameterNames{kk},'_PrecentSignificant_P2'])]>Results.([parameterNames{kk},'_PrecentSignificant_P2']))+1;
    Results.Pvalue(end).numAllObs=length([ResultsPermutation.([parameterNames{kk},'_PrecentSignificant_P2'])])+1;
    Results.Pvalue(end).value=Results.Pvalue(end).numExtremeObs/Results.Pvalue(end).numAllObs;
    
    Results.Pvalue(end+1).parameterName=parameterNames{kk};
    Results.Pvalue(end).effectName='P12';
    Results.Pvalue(end).numExtremeObs=sum([ResultsPermutation.([parameterNames{kk},'_PrecentSignificant_P12'])]>Results.([parameterNames{kk},'_PrecentSignificant_P12']))+1;
    Results.Pvalue(end).numAllObs=length([ResultsPermutation.([parameterNames{kk},'_PrecentSignificant_P12'])])+1;
    Results.Pvalue(end).value=Results.Pvalue(end).numExtremeObs/Results.Pvalue(end).numAllObs;
end

%check which pvalues are significant with fdr
FDR_Pvalues=mafdr([Results.Pvalue.value],'BHFDR',true);
for ii=1:length(FDR_Pvalues)
    Results.Pvalue(ii).value_fdr_corrected=FDR_Pvalues(ii);
end
significant_Pvalues=find(FDR_Pvalues<alpha);
significant_parameterName={Results.Pvalue(significant_Pvalues).parameterName};
significant_effectName={Results.Pvalue(significant_Pvalues).effectName};
disp(significant_parameterName);
disp(significant_effectName);

%% plot significant parameters
significant_paramName=unique(significant_parameterName,'stable');
figure
rows=length(significant_paramName);
columns=4;
jj=1;
for qq=1:length(significant_paramName)
    %boxplot
    subplot(rows,columns,jj)
    mat=[dataImvsCon.([significant_paramName{qq},'_Image'])(:,1),dataImvsCon.([significant_paramName{qq},'_Control'])(:,1),dataImvsCon.([significant_paramName{qq},'_Image'])(:,2),dataImvsCon.([significant_paramName{qq},'_Control'])(:,2)];
    boxplot(mat,'ColorGroup',[1 2 1 2]);
    hold on;
    parallelcoords(mat, 'Color', 0.7*[1 1 1], 'LineStyle', '-','Marker', 'o', 'MarkerSize', 10);
    hold off
    ylabel(significant_paramName{qq},'FontSize',18)
    set(gca,'XTick',[1.5,3.5])
    set(gca,'XTickLabel',{'Unconscious','Concscious'},'FontSize',18)

    %P1
    plotNum=jj+1;
    realVal=Results.([significant_paramName{qq},'_PrecentSignificant_P1']);
    vecReptitions=[ResultsPermutation.([significant_paramName{qq},'_PrecentSignificant_P1'])];
    ind=strcmp(significant_paramName{qq},{Results.Pvalue.parameterName}) & strcmp('P1',{Results.Pvalue.effectName});
    Pval=Results.Pvalue(ind).value_fdr_corrected;
    prc=95;
    xlabelText='Percent significant tests';
    if jj==1
        titleText='Trial type effect';
    else
        titleText=[];       
    end
    plotBootstrap(rows,columns,plotNum,realVal,vecReptitions,Pval,prc,xlabelText,titleText)
    
    %P2
    plotNum=jj+2;
    realVal=Results.([significant_paramName{qq},'_PrecentSignificant_P2']);
    vecReptitions=[ResultsPermutation.([significant_paramName{qq},'_PrecentSignificant_P2'])];
    ind=strcmp(significant_paramName{qq},{Results.Pvalue.parameterName}) & strcmp('P2',{Results.Pvalue.effectName});
    Pval=Results.Pvalue(ind).value_fdr_corrected;
    prc=95;
    xlabelText='Percent significant tests';
    if jj==1
        titleText='Condition effect';
    else
        titleText=[];
    end
    plotBootstrap(rows,columns,plotNum,realVal,vecReptitions,Pval,prc,xlabelText,titleText)
    
    %P12
    plotNum=jj+3;
    realVal=Results.([significant_paramName{qq},'_PrecentSignificant_P12']);
    vecReptitions=[ResultsPermutation.([significant_paramName{qq},'_PrecentSignificant_P12'])];
    ind=strcmp(significant_paramName{qq},{Results.Pvalue.parameterName}) & strcmp('P12',{Results.Pvalue.effectName});
    Pval=Results.Pvalue(ind).value_fdr_corrected;
    prc=95;
    xlabelText='Percent significant tests';
    if jj==1
        titleText='Interaction effect';
    else
        titleText=[];
    end
    plotBootstrap(rows,columns,plotNum,realVal,vecReptitions,Pval,prc,xlabelText,titleText)
    
    jj=jj+4;
end

    function [fixations,data]=calculateFixAndSaccData(fixations,data,parameterNames,trialType)
        for ii=1:size(fixations,2) %subjects
            for kk=1:size(fixations(ii).condition,2) %conditions
                for tt=1:size(fixations(ii).condition(kk).trial,2) %trials
                    %fixation parameters:
                    %%fixations number
                    fixations(ii).condition(kk).trial(tt).numFix=length(fixations(ii).condition(kk).trial(tt).processed.fix_w_final);
                    %%fixationsDurations
                    fixations(ii).condition(kk).trial(tt).durationFix=mean(fixations(ii).condition(kk).trial(tt).processed.fix_duration_final);
                    fixations(ii).condition(kk).trial(tt).stddurationFix=std(fixations(ii).condition(kk).trial(tt).processed.fix_duration_final);
                    
                    %saccade parameters:
                    %%saccade number
                    fixations(ii).condition(kk).trial(tt).numSacc=length(fixations(ii).condition(kk).trial(tt).processed.sacc_duration_final);
                    %%saccadeAmplitudes
                    fixations(ii).condition(kk).trial(tt).ampSacc=mean(fixations(ii).condition(kk).trial(tt).processed.sacc_amp_final);
                    fixations(ii).condition(kk).trial(tt).stdampSacc=std(fixations(ii).condition(kk).trial(tt).processed.sacc_amp_final);
                end
                for qq=1:length(parameterNames)
                    if contains(parameterNames{qq},'Sacc') && ~strcmp(parameterNames{qq},'numSacc')
                        data.([parameterNames{qq},'_',trialType])(ii,kk)=nanmean([fixations(ii).condition(kk).trial.(parameterNames{qq})]);
                    else
                        data.([parameterNames{qq},'_',trialType])(ii,kk)=mean([fixations(ii).condition(kk).trial.(parameterNames{qq})]);
                    end
                end
            end
        end
    end     
end