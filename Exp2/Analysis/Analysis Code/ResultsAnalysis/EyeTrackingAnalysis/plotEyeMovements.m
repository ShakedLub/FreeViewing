function plotEyeMovements(EXPDATA,EYETRACKING,EyeTrackerFrameRate)
IFI=1/EyeTrackerFrameRate;
DOM_EYE=EXPDATA.info.subject_info.dominant_eye;
switch DOM_EYE
    case 'R'
        GAZE_DATA='gazeRight';
    case 'L'
        GAZE_DATA='gazeLeft';
end
TimeVec=EYETRACKING.(GAZE_DATA).time;
x=EYETRACKING.(GAZE_DATA).x;
y=EYETRACKING.(GAZE_DATA).y;

for ii=1:size(EXPDATA.Trials_Analysis,2) %trials
    %TrackerTime returns the time in sec. The eyelink gives time in msec.
    %Therefore I multiply in 1000 to convert the number to msec
    %The data is rounded beacuse also EYETRACKING.(GAZE_DATA).time is
    %rounded.
    TrackerTimeStart=round(EXPDATA.Trials_Analysis(ii).check_Triggers.image_start.TrackerTime*1000);
    TrackerTimeEnd=round(EXPDATA.Trials_Analysis(ii).check_Triggers.image_end.TrackerTime*1000);
    
    ind_SampleStartTime=min(find(TimeVec>=TrackerTimeStart));
    ind_SampleEndTime=max(find(TimeVec<=TrackerTimeEnd));
    
    x_trial=x(ind_SampleStartTime:ind_SampleEndTime);
    y_trial=y(ind_SampleStartTime:ind_SampleEndTime);
    n=length(x_trial); %include blinks samples in the count as they are not nans in the analyzer.
    
    %In the analyzer NaN of blinks are filled with values (maybe interpolated 50 msec before and after the blink).
    %Length of analyzer: length without NaNs in the end (added so that all trials will be in the same length)
    x_analyzer=EXPDATA.Trials_Analysis(ii).gazeX;
    x_analyzer_l=x_analyzer;
    lastNaN=[];
    for aa=length(x_analyzer_l):-1:1
        if ~isnan(x_analyzer_l(aa))
            if aa==length(x_analyzer_l)
                lastNaN=[];
            else
                lastNaN=aa+1;
            end
            break
        end
    end
    if ~isempty(lastNaN)
        x_analyzer_l(lastNaN:end)=[];
    end
    n_analyzer=length(x_analyzer_l);
    
    y_analyzer=EXPDATA.Trials_Analysis(ii).gazeY;
    
    if n~=n_analyzer
        disp('Different number of indicess between analyzer and eyetracker raw data')
    end
    
    figure;
    %timevec=(0:(length(x_analyzer)-1))*IFI;
    subplot(2,2,1)
    plot(x_trial)
    ylabel('gaze x raw data')
    
    subplot(2,2,2)
    plot(x_analyzer)
    hold on
    ylabel('gaze x analyzer')
    indVec=1:length(x_analyzer);
    for ss=1:length(EXPDATA.Trials_Analysis(ii).saccadeOnsets) %saccades
        sacc_start=EXPDATA.Trials_Analysis(ii).saccadeOnsets(ss);
        sacc_end=sacc_start+EXPDATA.Trials_Analysis(ii).saccadeDurations(ss);
        plot(indVec(sacc_start:sacc_end),x_analyzer(sacc_start:sacc_end),'c')
    end
    for ff=1:length(EXPDATA.Trials_Analysis(ii).fixationsOnsets) %fixations
        fix_start=EXPDATA.Trials_Analysis(ii).fixationsOnsets(ff);
        fix_end=fix_start+EXPDATA.Trials_Analysis(ii).fixationsDurations(ff);
        plot(indVec(fix_start:fix_end),x_analyzer(fix_start:fix_end),'m')
    end
    hold off
    
    subplot(2,2,3)
    plot(y_trial)
    ylabel('gaze y raw data')
    
    subplot(2,2,4)
    plot(y_analyzer)
    hold on
    ylabel('gaze y analyzer')
    for ss=1:length(EXPDATA.Trials_Analysis(ii).saccadeOnsets) %saccades
        sacc_start=EXPDATA.Trials_Analysis(ii).saccadeOnsets(ss);
        sacc_end=sacc_start+EXPDATA.Trials_Analysis(ii).saccadeDurations(ss);
        plot(indVec(sacc_start:sacc_end),y_analyzer(sacc_start:sacc_end),'c')
    end
    for ff=1:length(EXPDATA.Trials_Analysis(ii).fixationsOnsets) %fixations
        fix_start=EXPDATA.Trials_Analysis(ii).fixationsOnsets(ff);
        fix_end=fix_start+EXPDATA.Trials_Analysis(ii).fixationsDurations(ff);
        plot(indVec(fix_start:fix_end),y_analyzer(fix_start:fix_end),'m')
    end
    hold off
end
end