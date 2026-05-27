function Results=saccadeRateTraceObjects(Fixations_PerSubject,ObjectsResults_PerSubj,Param,type)
% classify saccades to objects and background and calculate saccade rate
for ii=1:size(Fixations_PerSubject,2) %subjects
    for kk=1:size(Fixations_PerSubject(ii).condition,2) %conditions
        %initialze data matrices
        dataPerSubjPerCond_Obj=zeros(size(Fixations_PerSubject(ii).condition(kk).trial,2),4000);
        dataPerSubjPerCond_Bg=zeros(size(Fixations_PerSubject(ii).condition(kk).trial,2),4000);

        for jj=1:size(Fixations_PerSubject(ii).condition(kk).trial,2) %trials
            switch type
                case 'real'
                    sacc_onsets=Fixations_PerSubject(ii).condition(kk).trial(jj).processed.sacc_onsets_final;
                    sacc_duration=Fixations_PerSubject(ii).condition(kk).trial(jj).processed.sacc_duration_final;
                    fix_onsets=Fixations_PerSubject(ii).condition(kk).trial(jj).processed.fix_onsets_final;
                case 'shuffled'
                    sacc_onsets=Fixations_PerSubject(ii).condition(kk).trial(jj).sacc_onsets_final;
                    sacc_duration=Fixations_PerSubject(ii).condition(kk).trial(jj).sacc_duration_final;
                    fix_onsets=Fixations_PerSubject(ii).condition(kk).trial(jj).fix_onsets_final;
            end
            %find only saccades with included fixations
            %saccade onset + saccade duration = fixation onset + 1
            sacc_offsets=sacc_onsets+sacc_duration-1;
            saccToInclude=ismember(sacc_offsets,fix_onsets);
            sacc_onsets_final=sacc_onsets(saccToInclude);
            sacc_offsets_final=sacc_offsets(saccToInclude);
            
            objectClass=ObjectsResults_PerSubj(ii).condition(kk).trial(jj).objectClass;
            fixID=ObjectsResults_PerSubj(ii).condition(kk).trial(jj).fixID;
            
            saccID=[];
            saccNumObj=[];
            for aa=1:length(sacc_offsets_final) %included saccades
                %find these saccades object classification
                ind=find(fix_onsets==sacc_offsets_final(aa));
                saccID(aa)=fixID(ind);
                saccNumObj(aa)=objectClass(ind);
                
                %create binary vec with 1 in saccade onsets
                if saccID(aa) == 1 || saccID(aa) == 2 %object saccade
                    dataPerSubjPerCond_Obj(jj,sacc_onsets_final(aa))=1;
                elseif saccID(aa) == 0 %background saccade
                    dataPerSubjPerCond_Bg(jj,sacc_onsets_final(aa))=1;
                end
            end
        end

        %Normalize the saccade rate trace (according to region size)
        dataPerSubjPerCond_Obj=dataPerSubjPerCond_Obj./repmat([ObjectsResults_PerSubj(ii).condition(kk).trial.numPixObj]',1,4000);
        dataPerSubjPerCond_Bg=dataPerSubjPerCond_Bg./repmat([ObjectsResults_PerSubj(ii).condition(kk).trial.numPixBg]',1,4000);
        
        Results.condition(kk).dataPerSubjPerCond_Obj{ii}=dataPerSubjPerCond_Obj;
        Results.condition(kk).dataPerSubjPerCond_Bg{ii}=dataPerSubjPerCond_Bg;

        %average across trials and change to Hz
        Results.condition(kk).meanSaccRate_Obj(ii,:)=mean(dataPerSubjPerCond_Obj,1).*Param.EyeTrackerFrameRate;
        Results.condition(kk).meanSaccRate_Bg(ii,:)=mean(dataPerSubjPerCond_Bg,1).*Param.EyeTrackerFrameRate;
        
        %smooth
        data_Obj=Results.condition(kk).meanSaccRate_Obj(ii,:);
        data_Bg=Results.condition(kk).meanSaccRate_Bg(ii,:);
        SaccRate_Obj=[];
        SaccRate_Bg=[];
        for aa=1:length(data_Obj)
            startWindow=max(1,aa-round(Param.smoothWindow/2)+1);
            endWindow=min(length(data_Obj),aa+round(Param.smoothWindow/2));
            SaccRate_Obj(aa)=mean(data_Obj(startWindow:endWindow));
            SaccRate_Bg(aa)=mean(data_Bg(startWindow:endWindow)); 
        end
        %SaccRate_Obj = smooth(Results.condition(kk).meanSaccRate_Obj(ii,:),Param.smoothWindow);
        %SaccRate_Bg = smooth(Results.condition(kk).meanSaccRate_Bg(ii,:),Param.smoothWindow);
        
        Results.condition(kk).SaccRate_Obj(ii,:)=SaccRate_Obj;
        Results.condition(kk).SaccRate_Bg(ii,:)=SaccRate_Bg;
    end
end
end