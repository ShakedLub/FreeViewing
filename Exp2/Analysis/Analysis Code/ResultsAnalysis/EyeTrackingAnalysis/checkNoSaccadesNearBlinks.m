function non_nan_times=checkNoSaccadesNearBlinks(FixData,non_nan_times,Param)
%If there is a saccade in some delta around a blink (delta=10msec) mark it
%as part of the blink
for ii=1:length(FixData.sacc_onsets) %saccades
    %find gaze during saccades
    sacc_start=FixData.sacc_onsets(ii);
    sacc_end=sacc_start+FixData.sacc_duration(ii);
    sacc_NNT=non_nan_times(max(1,(sacc_start-Param.DeltaAroundBlinkFrames)):min((sacc_end+Param.DeltaAroundBlinkFrames),length(non_nan_times)));
    if any(sacc_NNT==0)
        non_nan_times(sacc_start:sacc_end)=0;
    end
end
end