function [BadDivision,RandTrialsOrder]=divideTrialsImQ(Param,Num_Images,ExpStep,ImageType,RandData)
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

%Divide the images in C and UC in the lengthes needed
for subj=1:Param.NumSubjects %subjects
    SizeGroupU=length(RandData(subj).Condition(1).ImageBank_equal)+length(RandData(subj).Condition(1).ImageBank_equal_Control)*2;
    SizeGroupC=length(RandData(subj).Condition(2).ImageBank_equal)+length(RandData(subj).Condition(2).ImageBank_equal_Control)*2;
    
    if length(RandTrialsOrder(subj).Condition(1).ImageBank)~=SizeGroupU
        if length(RandTrialsOrder(subj).Condition(1).ImageBank)>SizeGroupU %UC group is too long
            [RandTrialsOrder(subj).Condition(1).ImageBank_equal,RandTrialsOrder(subj).Condition(2).ImageBank_equal]=equalizeImagesInTwoGroups(RandTrialsOrder(subj).Condition(1).ImageBank,RandTrialsOrder(subj).Condition(2).ImageBank,SizeGroupU);
        elseif length(RandTrialsOrder(subj).Condition(1).ImageBank)<SizeGroupU %C group is too long
            [RandTrialsOrder(subj).Condition(2).ImageBank_equal,RandTrialsOrder(subj).Condition(1).ImageBank_equal]=equalizeImagesInTwoGroups(RandTrialsOrder(subj).Condition(2).ImageBank,RandTrialsOrder(subj).Condition(1).ImageBank,SizeGroupC);
        end
    else
        RandTrialsOrder(subj).Condition(1).ImageBank_equal=RandTrialsOrder(subj).Condition(1).ImageBank;
        RandTrialsOrder(subj).Condition(2).ImageBank_equal=RandTrialsOrder(subj).Condition(2).ImageBank;
    end
end

%Check image divsion between subjects
BadDivision=CheckImageDivision(RandTrialsOrder,Param,ExpStep,Num_Images,ImageType);
end