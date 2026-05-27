function Results=excludeFixSacc(FixData,RECT,Param)
plotFlag=0;

%% decide which variable is the horizontal and which the vertical
rawGazeW=FixData.gazeX;
rawGazeH=FixData.gazeY;

fix_w=round(FixData.fix_x);  %horizontal/ width
fix_h=round(FixData.fix_y);  %vertical/ height

gazeW=round(rawGazeW);
gazeH=round(rawGazeH);

if ~Param.RemoveTrialsWithBlinks
    non_nan_times=FixData.non_nan_times;
    %If there is a saccade in some delta around a blink (delta=10msec) mark it
    %as part of the blink
    non_nan_times=checkNoSaccadesNearBlinks(FixData,non_nan_times,Param);
end

%% Scaling the images 
%Scaling the images so that (widthmin,heightmin) is now (1,1)
rect=[RECT(1),RECT(2),RECT(3)-RECT(1),RECT(4)-RECT(2)];%rect=[widthmin heightmin width height]

fix_h=round(fix_h)-round(rect(2))+1;
fix_w=round(fix_w)-round(rect(1))+1;

gazeH=round(gazeH)-round(rect(2))+1;
gazeW=round(gazeW)-round(rect(1))+1;

%% Exclude fixations
if Param.RemoveCenterBias
    ImSize=[rect(4),rect(3)];
    CenterBiasMask=CreateCenterBiasMask(Param.pixels_per_vdegree,Param.CenterBiasRadius,ImSize);
end

%Finding fixations that should be excluded
indFixExclude=[];
for ii=1:length(fix_h) %fixations
    %find gaze during fixations
    fix_start=FixData.fix_onsets(ii);
    fix_end=fix_start+FixData.fix_duration(ii);
    Fix_gH=gazeH(fix_start:fix_end);
    Fix_gW=gazeW(fix_start:fix_end);

    %find fixations that are not inside the image
    if any(Fix_gH>rect(4) | Fix_gH<1 | Fix_gW>rect(3) | Fix_gW<1)
        indFixExclude=[indFixExclude,ii];
    end
    
    %find fixations in the center
    if Param.RemoveCenterBias && ~ismember(ii,indFixExclude)
        if CenterBiasMask(fix_h(ii),fix_w(ii))==0
            indFixExclude=[indFixExclude,ii];
            indFixExclude=unique(indFixExclude);
        end
        if plotFlag==1
            figure
            imshow(CenterBiasMask)
            hold on
            plot(Fix_gW,Fix_gH,'c')
            scatter(fix_w(ii),fix_h(ii),30,'m')
            hold off
        end
    end
    
    %find fixations that are near blinks or include blinks
    if ~Param.RemoveTrialsWithBlinks
        Fix_NNT=non_nan_times(max(1,(fix_start-1)):min((fix_end+1),length(non_nan_times)));
        if any(Fix_NNT==0)
            indFixExclude=[indFixExclude,ii];
            indFixExclude=unique(indFixExclude);
        end
    end
end

%find fixations outside the specified time 
if Param.AnalysisTimeLimitFlag==1
    fix_ends=FixData.fix_onsets+FixData.fix_duration;
    
    if ~isempty(find(FixData.fix_onsets<Param.AnalysisMinTimeLimitFrames & fix_ends<=Param.AnalysisMinTimeLimitFrames))
        indFixExclude=[indFixExclude,find(FixData.fix_onsets<Param.AnalysisMinTimeLimitFrames & fix_ends<=Param.AnalysisMinTimeLimitFrames)];
        indFixExclude=unique(indFixExclude);
    end
    if ~isempty(find(FixData.fix_onsets>Param.AnalysisMaxTimeLimitFrames))
        indFixExclude=[indFixExclude,find(FixData.fix_onsets>Param.AnalysisMaxTimeLimitFrames)];
        indFixExclude=unique(indFixExclude);
    end
end

%find fixations shorter than minFixDurationFrames
if ~isempty(find(FixData.fix_duration<Param.minFixDurationFrames))
    indFixExclude=[indFixExclude,find(FixData.fix_duration<Param.minFixDurationFrames)];
    indFixExclude=unique(indFixExclude);
end

%exclude fixations
fix_h_final=fix_h;
fix_w_final=fix_w;
fix_duration_final=FixData.fix_duration;
fix_onsets_final=FixData.fix_onsets;
ind_fix=1:length(fix_h);
if ~isempty(indFixExclude)
    fix_h_final(indFixExclude)=[];
    fix_w_final(indFixExclude)=[];
    fix_duration_final(indFixExclude)=[];
    fix_onsets_final(indFixExclude)=[];
    ind_fix(indFixExclude)=[];
end

%When trials with blinks are excluded:
%if a fixation outside the time zone is included make sure it doesn't include a blink
%%%%%% First fixation included
if Param.AnalysisTimeLimitFlag && Param.RemoveTrialsWithBlinks
    if ~isempty(fix_onsets_final) && fix_onsets_final(1)<Param.AnalysisMinTimeLimitFrames
        non_nan_times_vec=FixData.non_nan_times(fix_onsets_final(1):(fix_onsets_final(1)+fix_duration_final(1)));
        if ~isempty(find(non_nan_times_vec==0))
            indFixExclude=[ind_fix(1),indFixExclude];
            indFixExclude=unique(indFixExclude);
            
            fix_h_final(1)=[];
            fix_w_final(1)=[];
            fix_duration_final(1)=[];
            fix_onsets_final(1)=[];
            ind_fix(1)=[];
        end
    end
end

%%%%%% Last fixation included
if Param.AnalysisTimeLimitFlag && Param.RemoveTrialsWithBlinks  
    if ~isempty(fix_onsets_final) && (fix_onsets_final(end)+fix_duration_final(end)) > Param.AnalysisMaxTimeLimitFrames
        non_nan_times_vec=FixData.non_nan_times(fix_onsets_final(end):(fix_onsets_final(end)+fix_duration_final(end)));
        if ~isempty(find(non_nan_times_vec==0))
            indFixExclude=[indFixExclude,ind_fix(end)];
            indFixExclude=unique(indFixExclude);
            
            fix_h_final(end)=[];
            fix_w_final(end)=[];
            fix_duration_final(end)=[];
            fix_onsets_final(end)=[];
            ind_fix(end)=[];
        end
    end
end

numFixExclude=length(indFixExclude);
if numFixExclude==length(fix_w)
    includeSubj=0;
else
    includeSubj=1;
end

%% Exclude saccades
%Finding saccades that should be excluded
indSaccExclude=[];
for ii=1:length(FixData.sacc_onsets)
    %find gaze during saccades
    sacc_start=FixData.sacc_onsets(ii);
    sacc_end=sacc_start+FixData.sacc_duration(ii);
    Sacc_gH=gazeH(sacc_start:sacc_end);
    Sacc_gW=gazeW(sacc_start:sacc_end);
 
    %find saccades that are not inside the place holder
    if any(Sacc_gH>rect(4) | Sacc_gH<1 | Sacc_gW>rect(3) | Sacc_gW<1)
        indSaccExclude=[indSaccExclude,ii];
    end
    
    %find saccades that are near blinks or include blinks
    if ~Param.RemoveTrialsWithBlinks
        sacc_NNT=non_nan_times(max(1,(sacc_start-1)):min((sacc_end+1),length(non_nan_times)));
        if any(sacc_NNT==0)
            indSaccExclude=[indSaccExclude,ii];
            indSaccExclude=unique(indSaccExclude);
        end
    end
end

%find saccades that start outside the specified time
if Param.AnalysisTimeLimitFlag==1
    if ~isempty(find(FixData.sacc_onsets<Param.AnalysisMinTimeLimitFrames))
        indSaccExclude=[indSaccExclude,find(FixData.sacc_onsets<Param.AnalysisMinTimeLimitFrames)];
        indSaccExclude=unique(indSaccExclude);
    end
    if ~isempty(find(FixData.sacc_onsets>Param.AnalysisMaxTimeLimitFrames))
        indSaccExclude=[indSaccExclude,find(FixData.sacc_onsets>Param.AnalysisMaxTimeLimitFrames)];
        indSaccExclude=unique(indSaccExclude);
    end
end

%exclude saccades
sacc_duration_final=FixData.sacc_duration;
sacc_amp_final=FixData.sacc_amp;
sacc_vel_final=FixData.sacc_vel;
sacc_onsets_final=FixData.sacc_onsets;
if ~isempty(indSaccExclude)
    sacc_duration_final(indSaccExclude)=[];
    sacc_amp_final(indSaccExclude)=[];
    sacc_vel_final(indSaccExclude)=[];
    sacc_onsets_final(indSaccExclude)=[];
end

%When trials with blinks are excluded:
%if a saccade outside the time zone is included make sure it doesn't
%include a blink
%%%%%% Last saccade
if Param.AnalysisTimeLimitFlag && Param.RemoveTrialsWithBlinks 
    if ~isempty(sacc_onsets_final) && (sacc_onsets_final(end)+sacc_duration_final(end)) > Param.AnalysisMaxTimeLimitFrames
        non_nan_times_vec=FixData.non_nan_times(sacc_onsets_final(end):(sacc_onsets_final(end)+sacc_duration_final(end)));
        if ~isempty(find(non_nan_times_vec==0))
            sacc_duration_final(end)=[];
            sacc_amp_final(end)=[];
            sacc_vel_final(end)=[];
            sacc_onsets_final(end)=[];
        end
    end
end

%% Update data
%fixation data
Results.fix_w=fix_w;
Results.fix_h=fix_h;
Results.fix_w_final=fix_w_final;
Results.fix_h_final=fix_h_final;
Results.fix_duration_final=fix_duration_final;
Results.fix_onsets_final=fix_onsets_final;

%saccade data
Results.sacc_duration_final=sacc_duration_final;
Results.sacc_amp_final=sacc_amp_final;
Results.sacc_vel_final=sacc_vel_final;
Results.sacc_onsets_final=sacc_onsets_final;

%general data
Results.rect=rect;
Results.indFixExclude=indFixExclude;
Results.numFixExclude=numFixExclude;
Results.includeSubj=includeSubj;
end