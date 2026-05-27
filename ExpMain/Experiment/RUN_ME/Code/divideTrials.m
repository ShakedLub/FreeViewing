function [BadDivision,RandTrialsOrder]=divideTrials(Param,Num_Images,ExpStep,ImageType)
%initaite struct
for subj=1:Param.NumSubjects %subjects
    for cond=1:Param.NumConditions
        RandTrialsOrder(subj).Condition(cond).ConditionLabel=Param.ConditionLabels{cond};
        RandTrialsOrder(subj).Condition(cond).ImageBank=[];
        RandTrialsOrder(subj).Condition(cond).ImageBank_equal=[];
    end
end

%Divide images to C and UC condition for all subjects
for imageNumber=1:Num_Images %image
    clear SubjectsDivision
    %Randomly decide for which subjects the image will be presented in the first condition and for which in the second
    Subjects= randperm(Param.NumSubjects);
    SubjectsDivision{1}=Subjects(1:(Param.NumSubjects/2));
    SubjectsDivision{2}=Subjects(((Param.NumSubjects/2)+1):end);
    %Assign the division to RandTrialsOrder in ImageBank field
    for subj=1:Param.NumSubjects %subject
        if ismember(subj,SubjectsDivision{2}) %the image will be C for this subject
            RandTrialsOrder(subj).Condition(2).ImageBank=[RandTrialsOrder(subj).Condition(2).ImageBank,imageNumber];
        elseif ismember(subj,SubjectsDivision{1})  %the image will be UC for this subject
            RandTrialsOrder(subj).Condition(1).ImageBank=[RandTrialsOrder(subj).Condition(1).ImageBank,imageNumber];
        end
    end
end

%Make the number of images in C and UC condition equal
%Calculate the wanted number of images in conditions
if  mod(Num_Images,2) %odd number
    NumImagesInGroupMax=ceil(Num_Images/2);
    NumImagesInGroupMin=floor(Num_Images/2);
elseif ~mod(Num_Images,2) %even number
    NumImagesInGroupMax=Num_Images/2;
    NumImagesInGroupMin=Num_Images/2;
end
            
for subj=1:Param.NumSubjects %subjects
    if ~ismember(length(RandTrialsOrder(subj).Condition(1).ImageBank),[NumImagesInGroupMax,NumImagesInGroupMin])
        %Randomly decide if the longer group will be the C or UC one
        LongerGroup=round(rand); %0=C group longer, 1=UC group longer
        if length(RandTrialsOrder(subj).Condition(1).ImageBank)>length(RandTrialsOrder(subj).Condition(2).ImageBank) %UC group is too long
            if LongerGroup==0 %C group longer
                UCWantedLength=NumImagesInGroupMin;
            elseif LongerGroup==1 %UC group longer
                UCWantedLength=NumImagesInGroupMax;
            end
            [RandTrialsOrder(subj).Condition(1).ImageBank_equal,RandTrialsOrder(subj).Condition(2).ImageBank_equal]=equalizeImagesInTwoGroups(RandTrialsOrder(subj).Condition(1).ImageBank,RandTrialsOrder(subj).Condition(2).ImageBank,UCWantedLength);
        elseif length(RandTrialsOrder(subj).Condition(2).ImageBank)>length(RandTrialsOrder(subj).Condition(1).ImageBank) %C group is too long
            if LongerGroup==0 %C group longer
                CWantedLength=NumImagesInGroupMax;
            elseif LongerGroup==1 %UC group longer
                CWantedLength=NumImagesInGroupMin;
            end
            [RandTrialsOrder(subj).Condition(2).ImageBank_equal,RandTrialsOrder(subj).Condition(1).ImageBank_equal]=equalizeImagesInTwoGroups(RandTrialsOrder(subj).Condition(2).ImageBank,RandTrialsOrder(subj).Condition(1).ImageBank,CWantedLength);
        end
    else
        RandTrialsOrder(subj).Condition(1).ImageBank_equal=RandTrialsOrder(subj).Condition(1).ImageBank;
        RandTrialsOrder(subj).Condition(2).ImageBank_equal=RandTrialsOrder(subj).Condition(2).ImageBank;
    end
end

%Check image divsion between subjects
BadDivision=CheckImageDivision(RandTrialsOrder,Param,ExpStep,Num_Images,ImageType);
end