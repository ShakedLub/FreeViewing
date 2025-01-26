classdef FixationMonitor < handle 
    properties (Access= public)
        FIXATION_MONITOR_RESULT_IS_ON_TARGET= 0;
        FIXATION_MONITOR_RESULT_IS_SUSPECTED= 1;
        FIXATION_MONITOR_RESULT_IS_OFF_TARGET= 2;
    end
    
    properties (Access= private)        
        state= [];
        counter= 0;
        eyelink_obj= [];
        gaze_offset_tolerance= []; 
        gaze_samples_for_verdict= [];
    end
            
    methods (Access= public)
        function obj= FixationMonitor(eyelink_obj, gaze_offset_tolerance, gaze_samples_for_verdict)
            obj.eyelink_obj= eyelink_obj;
            obj.gaze_offset_tolerance= gaze_offset_tolerance;                        
            obj.gaze_samples_for_verdict= gaze_samples_for_verdict;      
            obj.state= obj.FIXATION_MONITOR_RESULT_IS_ON_TARGET;
        end
        
        %if (and only if) test_result is
        %obj.FIXATION_MONITOR_RESULT_IS_OFF_TARGET, then fixation was broken.
        function [obj, test_result,is_eyemissing]= testFixationBreaking(obj, fixation_loc, is_blinking_allowed)
            test_result= obj.FIXATION_MONITOR_RESULT_IS_ON_TARGET;
            eye_used = Eyelink('EyeAvailable'); % get eye that's tracked                        
            if eye_used ~= -1 && Eyelink('NewFloatSampleAvailable') > 0                
                evt = Eyelink('NewestFloatSample');   % get the sample in the form of an event structure 
                gaze_coords = NaN(2,2);
                if (eye_used == obj.eyelink_obj.BINOCULAR || eye_used == obj.eyelink_obj.LEFT_EYE) && evt.gx(obj.eyelink_obj.LEFT_EYE+1) ~= obj.eyelink_obj.MISSING_DATA && evt.gy(obj.eyelink_obj.LEFT_EYE+1) ~= obj.eyelink_obj.MISSING_DATA
                    gaze_coords(1,:)= ceil([evt.gx(obj.eyelink_obj.LEFT_EYE+1), evt.gy(obj.eyelink_obj.LEFT_EYE+1)]);
                end
                
                if (eye_used == obj.eyelink_obj.BINOCULAR || eye_used == obj.eyelink_obj.RIGHT_EYE) && evt.gx(obj.eyelink_obj.RIGHT_EYE+1) ~= obj.eyelink_obj.MISSING_DATA && evt.gy(obj.eyelink_obj.RIGHT_EYE+1) ~= obj.eyelink_obj.MISSING_DATA
                    gaze_coords(2,:)= ceil([evt.gx(obj.eyelink_obj.RIGHT_EYE+1), evt.gy(obj.eyelink_obj.RIGHT_EYE+1)]);
                end
                
                x = nanmean(gaze_coords(:,1));
                y = nanmean(gaze_coords(:,2));                      
                if isnan(x) || isnan(y)
                    is_eyemissing= 1;
                    if is_blinking_allowed
                        resetState();
                    else
                        obj.state= obj.FIXATION_MONITOR_RESULT_IS_OFF_TARGET;
                    end                                       
                else
                    is_eyemissing= 0;
                    fix_dist_from_center = sqrt( (x - fixation_loc(1))^2 + (y - fixation_loc(2))^2 );
                    if fix_dist_from_center < obj.gaze_offset_tolerance                     
                        resetState();    
                    else                                            
                        incCounter();
                    end                         
                end
                
                test_result= obj.state;
            end
            
            function incCounter()
                obj.counter= obj.counter+1;                    
                if obj.counter < obj.gaze_samples_for_verdict
                    obj.state= obj.FIXATION_MONITOR_RESULT_IS_SUSPECTED;                   
                else
                    obj.state= obj.FIXATION_MONITOR_RESULT_IS_OFF_TARGET;                    
                    %obj.counter= obj.gaze_samples_for_verdict-1;
                    obj.counter=0;
                end                                
            end
            
            function resetState()
                obj.counter= 0;            
                obj.state= obj.FIXATION_MONITOR_RESULT_IS_ON_TARGET;            
            end
        end
        
        function [obj, test_result]= testFixationResponse(obj, fixation_loc)
            test_result= obj.FIXATION_MONITOR_RESULT_IS_OFF_TARGET;
            obj.state= obj.FIXATION_MONITOR_RESULT_IS_OFF_TARGET;
            eye_used = Eyelink('EyeAvailable'); % get eye that's tracked                        
            if eye_used ~= -1 && Eyelink('NewFloatSampleAvailable') > 0                
                evt = Eyelink('NewestFloatSample');   % get the sample in the form of an event structure 
                gaze_coords = NaN(2,2);
                if (eye_used == obj.eyelink_obj.BINOCULAR || eye_used == obj.eyelink_obj.LEFT_EYE) && evt.gx(obj.eyelink_obj.LEFT_EYE+1) ~= obj.eyelink_obj.MISSING_DATA && evt.gy(obj.eyelink_obj.LEFT_EYE+1) ~= obj.eyelink_obj.MISSING_DATA
                    gaze_coords(1,:)= ceil([evt.gx(obj.eyelink_obj.LEFT_EYE+1), evt.gy(obj.eyelink_obj.LEFT_EYE+1)]);
                end
                
                if (eye_used == obj.eyelink_obj.BINOCULAR || eye_used == obj.eyelink_obj.RIGHT_EYE) && evt.gx(obj.eyelink_obj.RIGHT_EYE+1) ~= obj.eyelink_obj.MISSING_DATA && evt.gy(obj.eyelink_obj.RIGHT_EYE+1) ~= obj.eyelink_obj.MISSING_DATA
                    gaze_coords(2,:)= ceil([evt.gx(obj.eyelink_obj.RIGHT_EYE+1), evt.gy(obj.eyelink_obj.RIGHT_EYE+1)]);
                end
                
                x = nanmean(gaze_coords(:,1));
                y = nanmean(gaze_coords(:,2));                      
                if ~isnan(x) && ~isnan(y)
                    fix_dist_from_center = sqrt( (x - fixation_loc(1))^2 + (y - fixation_loc(2))^2 );
                    if fix_dist_from_center < obj.gaze_offset_tolerance                     
                        incCounter();
                    else                                            
                        resetState();
                    end                                         
                else   
                    resetState();                                         
                end
                
                test_result= obj.state;
            end
            
            function incCounter()
                obj.counter= obj.counter+1;                    
                if obj.counter < obj.gaze_samples_for_verdict
                    obj.state= obj.FIXATION_MONITOR_RESULT_IS_SUSPECTED;                   
                else
                    obj.state= obj.FIXATION_MONITOR_RESULT_IS_ON_TARGET;                    
                    %obj.counter= obj.gaze_samples_for_verdict-1;
                    obj.counter=0;
                end                                
            end
            
            function resetState()
                obj.counter= 0;            
                obj.state= obj.FIXATION_MONITOR_RESULT_IS_OFF_TARGET;            
            end
        end
        
        function state= getState(obj)
            state= obj.state;
        end
    end        
end
    

