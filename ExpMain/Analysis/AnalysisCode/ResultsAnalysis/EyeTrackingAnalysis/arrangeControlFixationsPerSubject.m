function Fixations_PerSubjectControl=arrangeControlFixationsPerSubject(EXPDATA_ALL,subjNumber,Paths,Param)
%add all fixations to FixationsSubjects_Control
for ii=1:size(EXPDATA_ALL,1) %subjects
    %general data
    Fixations_PerSubjectControl(ii).subjNum=EXPDATA_ALL{ii,1}.info.subject_info.subject_number_and_experiment;
    for kk=1:size(EXPDATA_ALL,2) %conditions
        indControlTrials=find([EXPDATA_ALL{ii,kk}.Trials_Analysis.IsControlTrial]);
        for jj=1:length(indControlTrials) %control trials
            %general data
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).TrialNumberOverall=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).TrialNumberOverall;
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).gazeX=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).gazeX;
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).gazeY=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).gazeY;
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).non_nan_times=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).non_nan_times;
            %fixation data
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).fix_x=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).fixations(:,1);
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).fix_y=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).fixations(:,2);
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).fix_duration=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).fixationsDurations;
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).fix_onsets=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).fixationsOnsets;
            %saccade data
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).sacc_duration=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).saccadeDurations;
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).sacc_amp=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).saccadeAmplitudes;
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).sacc_vel=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).saccadeVelocities;
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).sacc_onsets=EXPDATA_ALL{ii,kk}.Trials_Analysis(indControlTrials(jj)).saccadeOnsets;           
        end
    end
end

%create RectCell for all participants
for ii=1:length(subjNumber)
    for kk=1:2 %visibility conditions
        SUBJ_NUM=subjNumber(ii);
        if kk==1
            EXP_COND='U';
        elseif kk==2
            EXP_COND='C';
        end
        pileupfileName=['pileup_',EXP_COND,'_',num2str(SUBJ_NUM),'.mat'];
        load([Paths.PileupFolder,'\',pileupfileName],'resources')
        RectCell{ii,kk}=resources.Images.dstRectDom;
        clear resources
    end
end

%Preprocess fixations
for ii=1:size(Fixations_PerSubjectControl,2) %subjects
    SUBJ_NUM=Fixations_PerSubjectControl(ii).subjNum;
    ind_sub=find(subjNumber==SUBJ_NUM);
    for kk=1:size(Fixations_PerSubjectControl(ii).condition,2) %conditions
        excludeTrial=[];
        RECT=RectCell{ind_sub,kk};
        for jj=1:size(Fixations_PerSubjectControl(ii).condition(kk).trial,2) %trials
            Fixations_PerSubjectControl(ii).condition(kk).trial(jj).processed=excludeFixSacc(Fixations_PerSubjectControl(ii).condition(kk).trial(jj),RECT,Param);
            if Fixations_PerSubjectControl(ii).condition(kk).trial(jj).processed.includeSubj==0
                excludeTrial=[excludeTrial,jj];
            end
        end
        if ~isempty(excludeTrial)
            Fixations_PerSubjectControl(ii).condition(kk).trial(excludeTrial)=[];
        end
        if size(Fixations_PerSubjectControl(ii).condition(kk).trial,2)==0
            error('One of the subejcts does not have control trials left in C or U condition')
        end
    end
end
end