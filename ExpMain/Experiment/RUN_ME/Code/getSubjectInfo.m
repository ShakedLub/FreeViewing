function [subInfo,IS_EXP_GO] = getSubjectInfo(IS_EXP_GO)
% function for getting subject basic info
% @output subInfo = a struct containing subjNum, expCond, age, gender ,
% dominant hand and dominant eye
SubjNum = '\fontsize{15} Subject number (number keys):  ';
ExpCond = '\fontsize{15} Experiment condition (1/2):  ';
Age = '\fontsize{15} Age (number keys):  ';
Gender = '\fontsize{15} Gender (M/F/O):  ';
DominantHand = '\fontsize{15} Dominant hand (R/L):  ';
DominantEye = '\fontsize{15} Dominant eye (R/L):  ';
prompt= {SubjNum,ExpCond,Age,Gender,DominantHand,DominantEye};
currentAnswer = {'','','','','',''};
opts.Interpreter = 'tex';

load('ExpDesignAllSubjects')
TotalNumSubjects=size(ExpDesignAllSubjects.RandTrialsOrder,2);
clear ExpDesignAllSubjects

repeat=1;
while (repeat)
    currentAnswer = inputdlg(prompt, 'Subject Info', 1, currentAnswer,opts);
    if length(currentAnswer)==0
        IS_EXP_GO=0;
        subInfo=[];
        repeat=0;
    else
        [subInfo.subjNum,subInfo.expCond,subInfo.age,subInfo.gender,subInfo.hand,subInfo.eye] = deal(currentAnswer{:});
        subInfo.subjNum=str2num(subInfo.subjNum);
        subInfo.expCond=str2num(subInfo.expCond);
        subInfo.age=str2num(subInfo.age);
        subInfo.gender = upper(subInfo.gender);
        subInfo.hand = upper(subInfo.hand);
        subInfo.eye= upper(subInfo.eye);
        if any(cellfun(@isempty, currentAnswer))
            h = errordlg('Please fill in all fields','Input Error'); uiwait(h);
        elseif (subInfo.subjNum<1) | (subInfo.subjNum>TotalNumSubjects)
            h = errordlg('Please enter a valid subject number','Input Error'); uiwait(h);
        elseif ~((subInfo.expCond==1) | (subInfo.expCond==2))
            h = errordlg('Please indicate 1 or 2 for experiment condition','Input Error'); uiwait(h);
        elseif (subInfo.age<1) | (subInfo.age>99)
            h = errordlg('Please enter a valid age','Input Error'); uiwait(h);
        elseif ~ismember(subInfo.gender,{'M','F','O'})
            h = errordlg('Please indicate M, F or O for gender','Input Error'); uiwait(h);
        elseif ~ismember(subInfo.hand,{'R','L'})
            h = errordlg('Please indicate R or L for dominant hand','Input Error'); uiwait(h);
        elseif ~ismember(subInfo.eye,{'R','L'})
            h = errordlg('Please indicate R or L for dominant eye','Input Error'); uiwait(h);
        else
            repeat = 0;
        end
    end
end
end
