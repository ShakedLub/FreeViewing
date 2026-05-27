function [FixationsPerImageProcessed,Fixations_PerSubject,subjNumber]=loadDataFreeViewing(Paths,Param)
%% load data
% load FixationsPerImageProcessed
load([Paths.LoadResultsStructsPath1,'\FixationsPerImageProcessed_RemoveCenterBias.mat'])

% fix struct to be in the same structure as the main analysis
for ii= 1:size(FixationsPerImageProcessed,2) %images
    FixationsPerImageProcessed(ii).condition.subject=FixationsPerImageProcessed(ii).subject;
end
FixationsPerImageProcessed = rmfield(FixationsPerImageProcessed,'subject');

% load Fixations_PerSubject
load([Paths.LoadResultsStructsPath1,'\Fixations_PerSubject_RemoveCenterBias.mat']);

% fix struct to be in the same structure as the main analysis
for ii= 1:size(Fixations_PerSubject,2) %participants
    Fixations_PerSubject(ii).condition.trial=Fixations_PerSubject(ii).trial;
end
Fixations_PerSubject = rmfield(Fixations_PerSubject,'trial');

%check fixations per subject
for ii=1:size(Fixations_PerSubject,2) %images
    if length(Fixations_PerSubject(ii).condition.trial)<Param.MinTrials
        disp('Some subjects have less than 10 image trials')
    end
end

% create subjNumber
subjNumber=[Fixations_PerSubject.subjNum];

%% fix fixations for subjects with wrong distance from screen
load([Paths.DataFolder,'\DataPileups\Experiment1\pileup_U_401.mat'],'resources')
RECT=resources.Images.dstRectDom;
rect=[RECT(1),RECT(2),RECT(3)-RECT(1),RECT(4)-RECT(2)];%rect=[widthmin heightmin width height]
wantedImSize=ceil([rect(4),rect(3)]);

for ii=1:size(FixationsPerImageProcessed,2) %images
    for jj=1:size(FixationsPerImageProcessed(ii).condition.subject,2) %subjects
        OrigImSize=ceil([FixationsPerImageProcessed(ii).condition.subject(jj).processed.rect(4),FixationsPerImageProcessed(ii).condition.subject(jj).processed.rect(3)]);
        if ~isequal(OrigImSize,wantedImSize)
            fix_h_new=[];
            fix_w_new=[];
            fix_h=FixationsPerImageProcessed(ii).condition.subject(jj).processed.fix_h_final;
            fix_w=FixationsPerImageProcessed(ii).condition.subject(jj).processed.fix_w_final;
            for aa=1:length(fix_h) %fixations
                height=fix_h(aa);
                width=fix_w(aa);
                
                temp_map=zeros(OrigImSize);
                temp_map(height,width)=1;
                
                %Fix all maps to the same size as a stimulus that was seen from 70 cm away
                map = imresize(temp_map,wantedImSize);
                Allfix=find(map);
                ColorIntensityfix=map(Allfix);
                [~,indMaxIntensityFix]=max(ColorIntensityfix);
                fix=Allfix(indMaxIntensityFix(1));
                [y,x]=ind2sub(wantedImSize,fix);
                
                fix_h_new=[fix_h_new,y];
                fix_w_new=[fix_w_new,x];
            end
            FixationsPerImageProcessed(ii).condition.subject(jj).processed.fix_h_final=fix_h_new';
            FixationsPerImageProcessed(ii).condition.subject(jj).processed.fix_w_final=fix_w_new';           
            FixationsPerImageProcessed(ii).condition.subject(jj).processed.fix_h_original=fix_h;
            FixationsPerImageProcessed(ii).condition.subject(jj).processed.fix_w_original=fix_w;
            FixationsPerImageProcessed(ii).condition.subject(jj).processed.rect_original=FixationsPerImageProcessed(ii).condition.subject(jj).processed.rect;
            FixationsPerImageProcessed(ii).condition.subject(jj).processed.rect=rect;
            
            %update also Fixations_PerSubject
            indS=find([Fixations_PerSubject.subjNum]==FixationsPerImageProcessed(ii).condition.subject(jj).subjNum);
            indT=find([Fixations_PerSubject(indS).condition.trial.TrialNumberOverall] == FixationsPerImageProcessed(ii).condition.subject(jj).TrialNumberOverall);
            Fixations_PerSubject(indS).condition.trial(indT).processed.fix_h_final=fix_h_new';
            Fixations_PerSubject(indS).condition.trial(indT).processed.fix_w_final=fix_w_new';
            Fixations_PerSubject(indS).condition.trial(indT).processed.fix_h_original=fix_h;
            Fixations_PerSubject(indS).condition.trial(indT).processed.fix_w_original=fix_w;
            Fixations_PerSubject(indS).condition.trial(indT).processed.rect_original=Fixations_PerSubject(indS).condition.trial(indT).processed.rect;
            Fixations_PerSubject(indS).condition.trial(indT).processed.rect=rect;
        end
    end
end
end