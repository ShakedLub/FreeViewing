function RandTrialsOrder=randomizeTrialsForBuild(Param,ExpStep,RandTrialsOrder_ThrFitting)
%% chose randomally threshold fitting image order
switch ExpStep
    case 'ThresholdFitting'
        Num_Wanted_Images=Param.MaxNumBlocksTHF*Param.NumImagesInBlockTHF+Param.NumStartImagesTHF;
        for subj=1:Param.NumSubjects %subjects
            randorder=randperm(Param.Num_Images_Thr_Fitting,Num_Wanted_Images);
            for ii=1:length(randorder)
                RandTrialsOrder(subj).Trials(ii).ImageID=randorder(ii);
                RandTrialsOrder(subj).Trials(ii).ImageName=Param.Image_Names_Thr_Fitting{randorder(ii)};
            end
        end
    case 'Extra'
        %create trials struct
        %Parameters
        for subj=1:Param.NumSubjects %subjects
            NumBlocks_Extra=ceil((Param.Num_Images_Thr_Fitting-size(RandTrialsOrder_ThrFitting(subj).Trials,2))/Param.NumTrialsInBlock_Extra);
            
            ThFittingImageID=[RandTrialsOrder_ThrFitting(subj).Trials.ImageID];
            %Randomize image order
            ExtraTrialsImageID=setdiff(1:Param.Num_Images_Thr_Fitting,ThFittingImageID);
            Ind_RandImagesOrder=randperm(length(ExtraTrialsImageID));
            RandImagesOrder=ExtraTrialsImageID(Ind_RandImagesOrder);
            
            %check 
            if length(RandImagesOrder)>Param.Num_Images_For_Q_Extra  
                error('Not enough Q images for extra trials')
            end
            
            %Randomize distractor for Q image order
            RandImagesOrder_Q=randperm(Param.Num_Images_For_Q_Extra,length(RandImagesOrder));
            
            RandTrialsOrder(subj).ControlTrialNum=Param.ControlTrialNum;
            RandTrialsOrder(subj).NumBlocks=NumBlocks_Extra;
            trialNumOverall=0;
            for bb=1:NumBlocks_Extra
                if bb==NumBlocks_Extra
                    numTrialsInBlock=length(RandImagesOrder)-(Param.NumTrialsInBlock_Extra*(NumBlocks_Extra-1));
                else
                    numTrialsInBlock=Param.NumTrialsInBlock_Extra;
                end
                for tt=1:numTrialsInBlock %trials
                    trialNumOverall=trialNumOverall+1;
                    RandTrialsOrder(subj).Trials(trialNumOverall).BlockNum=bb;
                    RandTrialsOrder(subj).Trials(trialNumOverall).TrialNum=tt;
                    %image data
                    RandTrialsOrder(subj).Trials(trialNumOverall).ImageID=RandImagesOrder(trialNumOverall);
                    RandTrialsOrder(subj).Trials(trialNumOverall).ImageName=Param.Image_Names_Thr_Fitting{RandImagesOrder(trialNumOverall)};
                    
                    %chose which side the image from the trial appears
                    side=round(rand); %0= image left, 1= image right
                    
                    if side==0 %image left, distractor right
                        %image Q left- image from trial
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageIDQLeft=RandTrialsOrder(subj).Trials(trialNumOverall).ImageID;
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageNameQLeft=RandTrialsOrder(subj).Trials(trialNumOverall).ImageName;
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageTypeQLeft=1; %0= distractor, 1= image from trial
                        
                        %image Q right - distractor
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageIDQRight=RandImagesOrder_Q(trialNumOverall);
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageNameQRight=Param.Image_Names_For_Q_Extra{RandImagesOrder_Q(trialNumOverall)};
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageTypeQRight=0; %0= distractor, 1= image from trial
                    elseif side==1 %image right, distractor left
                        %image Q left - distractor
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageIDQLeft=RandImagesOrder_Q(trialNumOverall);
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageNameQLeft=Param.Image_Names_For_Q_Extra{RandImagesOrder_Q(trialNumOverall)};
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageTypeQLeft=0; %0= distractor, 1= image from trial
                        
                        %image Q right - image from trial
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageIDQRight=RandTrialsOrder(subj).Trials(trialNumOverall).ImageID;
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageNameQRight=RandTrialsOrder(subj).Trials(trialNumOverall).ImageName;
                        RandTrialsOrder(subj).Trials(trialNumOverall).ImageTypeQRight=1; %0= distractor, 1= image from trial
                    end
                end
            end
        end
    otherwise
        %% checks
        %check there are two conditions
        if Param.NumConditions~=2
            error('This code is built for two conditions');
        end
        
        %Check the number of subjects is even
        if mod(Param.NumSubjects,2)
            error('The number of subjects should be even')
        end
        
        %number of images in both conditions
        switch ExpStep
            case 'Experiment'
                Num_Images=Param.Num_Images_Experiment;
                Num_Q_Images=Param.Num_Images_For_Q_Experiment;
            case 'Practice'
                Num_Images=Param.Num_Images_Practice;
                Num_Q_Images=Param.Num_Images_For_Q_Practice;
        end
        Num_Control_Images=max(2,round(Num_Images*Param.Percent_Control_Trials));
        
        %% divide images for image trials equally between the two conditions
        BadDivision1=1;
        while BadDivision1
            [BadDivision1,Im]=divideTrials(Param,Num_Images,ExpStep,'ImageTrials');
        end
        
        for subj=1:Param.NumSubjects %subjects
            for cond=1:Param.NumConditions
                RandTrialsOrder(subj).Condition(cond).ConditionLabel=Param.ConditionLabels{cond};
                RandTrialsOrder(subj).Condition(cond).ImageBank_equal=Im(subj).Condition(cond).ImageBank_equal;
            end
        end
        
        %% create random order of control images and divide them between the conditions
        for subj=1:Param.NumSubjects %subjects
            RandImagesOrder_Control_All=randperm(Num_Images,Num_Control_Images);
            if  mod(Num_Control_Images,2) %odd number
                NumImagesInGroupMax=ceil(Num_Control_Images/2);
                NumImagesInGroupMin=floor(Num_Control_Images/2);
            elseif ~mod(Num_Control_Images,2) %even number
                NumImagesInGroupMax=Num_Control_Images/2;
                NumImagesInGroupMin=Num_Control_Images/2;
            end
            
            LongerGroup=round(rand); %0- C group longer, 1- UC group longer
            
            if LongerGroup==0 %C group longer
                RandTrialsOrder(subj).Condition(1).ImageBank_equal_Control=RandImagesOrder_Control_All(1:NumImagesInGroupMin);
                RandTrialsOrder(subj).Condition(2).ImageBank_equal_Control=RandImagesOrder_Control_All((NumImagesInGroupMin+1):end);
            elseif LongerGroup==1 %UC group longer
                RandTrialsOrder(subj).Condition(1).ImageBank_equal_Control=RandImagesOrder_Control_All(1:NumImagesInGroupMax);
                RandTrialsOrder(subj).Condition(2).ImageBank_equal_Control=RandImagesOrder_Control_All((NumImagesInGroupMax+1):end);
            end
        end
        
        %% divide images for Q trials equally between the two conditions
        BadDivision2=1;
        while BadDivision2
            [BadDivision2,QIm]=divideTrialsImQ(Param,Num_Q_Images,ExpStep,'QImages',RandTrialsOrder);
        end
        
        for subj=1:Param.NumSubjects %subjects
            for cond=1:Param.NumConditions
                RandTrialsOrder(subj).Condition(cond).ImageBank_equal_Q=QIm(subj).Condition(cond).ImageBank_equal;
            end
        end
        
        %%% 1) Create random order of images
        %%% 2) add control trials
        %%% 3) add Q images
        for subj=1:Param.NumSubjects %subjects
            for cond=1:Param.NumConditions %conditions
                RandTrialsOrder(subj).Condition(cond).ControlTrialNum=Param.ControlTrialNum;
                
                %Calculate how many trial types in each block
                switch ExpStep
                    case 'Experiment'
                        NumBlocks=Param.NumBlocksPerCondition;
                        
                        %Regular block
                        RandTrialsOrder(subj).Condition(cond).Num_Image_Trials_In_Block=round(length(RandTrialsOrder(subj).Condition(cond).ImageBank_equal)./Param.NumBlocksPerCondition);
                        RandTrialsOrder(subj).Condition(cond).Num_Control_Trials_In_Block=round(length(RandTrialsOrder(subj).Condition(cond).ImageBank_equal_Control)./Param.NumBlocksPerCondition);
                        
                        %Last block
                        RandTrialsOrder(subj).Condition(cond).Num_Image_Trials_In_Last_Block=length(RandTrialsOrder(subj).Condition(cond).ImageBank_equal)-(RandTrialsOrder(subj).Condition(cond).Num_Image_Trials_In_Block*(Param.NumBlocksPerCondition-1));
                        RandTrialsOrder(subj).Condition(cond).Num_Control_Trials_In_Last_Block=length(RandTrialsOrder(subj).Condition(cond).ImageBank_equal_Control)-(RandTrialsOrder(subj).Condition(cond).Num_Control_Trials_In_Block*(Param.NumBlocksPerCondition-1));
                    case 'Practice'
                        NumBlocks=1;
                        
                        RandTrialsOrder(subj).Condition(cond).Num_Image_Trials_In_Block=length(RandTrialsOrder(subj).Condition(cond).ImageBank_equal);
                        RandTrialsOrder(subj).Condition(cond).Num_Control_Trials_In_Block=length(RandTrialsOrder(subj).Condition(cond).ImageBank_equal_Control);
                end
                
                %Randomize image order
                Ind_RandImagesOrder=randperm(length(RandTrialsOrder(subj).Condition(cond).ImageBank_equal));
                RandImagesOrder=RandTrialsOrder(subj).Condition(cond).ImageBank_equal(Ind_RandImagesOrder);
                
                %Randomize distractor for Q image order
                Ind_RandImagesOrder=randperm(length(RandTrialsOrder(subj).Condition(cond).ImageBank_equal_Q));
                RandImagesOrder_Q=RandTrialsOrder(subj).Condition(cond).ImageBank_equal_Q(Ind_RandImagesOrder);
                
                %Randomized control trial order (they are already randomized)
                RandImagesOrder_Control=RandTrialsOrder(subj).Condition(cond).ImageBank_equal_Control;
                
                %Add control trials and divide trials to blocks
                trialNumOverall=0;
                ind_Q_image=0;
                for block=1:NumBlocks %blocks
                    Ind_FirstImageInBlock=1+(block-1)*RandTrialsOrder(subj).Condition(cond).Num_Image_Trials_In_Block;
                    Ind_FirstControlImageInBlock=1+(block-1)*RandTrialsOrder(subj).Condition(cond).Num_Control_Trials_In_Block;
                    
                    if block~=NumBlocks || strcmp(ExpStep,'Practice')
                        NumImagesInBlock=RandTrialsOrder(subj).Condition(cond).Num_Image_Trials_In_Block;
                        NumControlTrialsInBlock=RandTrialsOrder(subj).Condition(cond).Num_Control_Trials_In_Block;
                    else
                        NumImagesInBlock=RandTrialsOrder(subj).Condition(cond).Num_Image_Trials_In_Last_Block;
                        NumControlTrialsInBlock=RandTrialsOrder(subj).Condition(cond).Num_Control_Trials_In_Last_Block;
                    end
                    
                    Ind_LastImageInBlock=Ind_FirstImageInBlock-1+NumImagesInBlock;
                    Ind_LastControlImageInBlock=Ind_FirstControlImageInBlock-1+NumControlTrialsInBlock;
                    
                    TempRandImagesOrder_InBlock=RandImagesOrder(Ind_FirstImageInBlock:Ind_LastImageInBlock);
                    TempRandImagesOrder_OnlyImages=TempRandImagesOrder_InBlock;
                    
                    RandImagesOrder_Control_InBlock=RandImagesOrder_Control(Ind_FirstControlImageInBlock:Ind_LastControlImageInBlock);
                    
                    flag=1;
                    while flag
                        Ind_ControlTrials=randperm(NumImagesInBlock+NumControlTrialsInBlock,NumControlTrialsInBlock);
                        sorted_Ind_ControlTrials=sort(Ind_ControlTrials);
                        if length(sorted_Ind_ControlTrials)>1
                            if all(diff(sorted_Ind_ControlTrials)>Param.MinimalDistanceBetweenNonImageTrials) %check that non image trials are not closer than Param.MinimalDistanceBetweenNonImageTrials
                                flag=0;
                            end
                        else
                            flag=0;
                        end
                    end
                    
                    %Add control trials
                    for ii=1:length(sorted_Ind_ControlTrials)
                        ind=sorted_Ind_ControlTrials(ii);
                        TempRandImagesOrder_InBlock=[TempRandImagesOrder_InBlock(1:(ind-1)),RandTrialsOrder(subj).Condition(cond).ControlTrialNum,TempRandImagesOrder_InBlock(ind:end)];
                    end
                    %check there are no zeros in TempRandImagesOrder after
                    %adding the control trials
                    if any(TempRandImagesOrder_InBlock==0)
                        error('Problem with adding control trials. it added zeros')
                    end
                    
                    %create trials struct
                    ind_controlTrial=0;
                    for tt=1:length(TempRandImagesOrder_InBlock) %trials
                        trialNumOverall=trialNumOverall+1;
                        RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).BlockNum=block;
                        RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).TrialNum=tt;
                        RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).TrialNumOverall=trialNumOverall;
                        %image data
                        RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageID=TempRandImagesOrder_InBlock(tt);
                        
                        if RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageID==RandTrialsOrder(subj).Condition(cond).ControlTrialNum %control trial
                            %control image data
                            ind_controlTrial=ind_controlTrial+1;
                            RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageName=Param.(['Image_Names_',ExpStep]){RandImagesOrder_Control_InBlock(ind_controlTrial)};
                            RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageIDControl=RandImagesOrder_Control_InBlock(ind_controlTrial);
                            
                            %image Q left- distractor
                            ind_Q_image=ind_Q_image+1;
                            RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageIDQLeft=RandImagesOrder_Q(ind_Q_image);
                            RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageNameQLeft=Param.(['Image_Names_For_Q_',ExpStep]){RandImagesOrder_Q(ind_Q_image)};
                            RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageTypeQLeft=0;
                            
                            %image Q right - distractor
                            ind_Q_image=ind_Q_image+1;
                            RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageIDQRight=RandImagesOrder_Q(ind_Q_image);
                            RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageNameQRight=Param.(['Image_Names_For_Q_',ExpStep]){RandImagesOrder_Q(ind_Q_image)};
                            RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageTypeQRight=0;
                        else %image trial
                            %image data
                            RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageName=Param.(['Image_Names_',ExpStep]){TempRandImagesOrder_InBlock(tt)};
                            
                            %control image data
                            RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageIDControl=NaN;
                            
                            %chose which side the image from the trial appears
                            side=round(rand); %0= image left, 1= image right
                            
                            if side==0 %image left, distractor right
                                %image Q left- image from trial
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageIDQLeft=RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageID;
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageNameQLeft=RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageName;
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageTypeQLeft=1; %0= distractor, 1= image from trial
                                
                                %image Q right - distractor
                                ind_Q_image=ind_Q_image+1;
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageIDQRight=RandImagesOrder_Q(ind_Q_image);
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageNameQRight=Param.(['Image_Names_For_Q_',ExpStep]){RandImagesOrder_Q(ind_Q_image)};
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageTypeQRight=0; %0= distractor, 1= image from trial
                            elseif side==1 %image right, distractor left
                                %image Q left - distractor
                                ind_Q_image=ind_Q_image+1;
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageIDQLeft=RandImagesOrder_Q(ind_Q_image);
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageNameQLeft=Param.(['Image_Names_For_Q_',ExpStep]){RandImagesOrder_Q(ind_Q_image)};
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageTypeQLeft=0; %0= distractor, 1= image from trial
                                
                                %image Q right - image from trial
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageIDQRight=RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageID;
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageNameQRight=RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageName;
                                RandTrialsOrder(subj).Condition(cond).Trials(trialNumOverall).ImageTypeQRight=1; %0= distractor, 1= image from trial
                            end
                        end
                    end
                    
                    %save the data to RandTrialsOrder
                    RandTrialsOrder(subj).Condition(cond).Blocks(block).NumTrials=length(TempRandImagesOrder_InBlock);
                    RandTrialsOrder(subj).Condition(cond).Blocks(block).NumImageTrials=length(TempRandImagesOrder_OnlyImages);
                    RandTrialsOrder(subj).Condition(cond).Blocks(block).ControlTrialsInd=find(TempRandImagesOrder_InBlock==RandTrialsOrder(subj).Condition(cond).ControlTrialNum);
                    RandTrialsOrder(subj).Condition(cond).Blocks(block).NumControlTrials=length(RandTrialsOrder(subj).Condition(cond).Blocks(block).ControlTrialsInd);
                    
                    %check
                    if length(RandTrialsOrder(subj).Condition(cond).Blocks(block).ControlTrialsInd)~=NumControlTrialsInBlock
                        error('Wrong number of control trials')
                    end
                end
                
                %Calculated the number of trials in a condition
                NumTrialsInCondition=0;
                NumImageTrialsInCondition=0;
                NumControlTrialsInCondition=0;
                for aa=1:size(RandTrialsOrder(subj).Condition(cond).Blocks,2) %blocks
                    NumTrialsInCondition=NumTrialsInCondition+RandTrialsOrder(subj).Condition(cond).Blocks(aa).NumTrials;
                    NumImageTrialsInCondition=NumImageTrialsInCondition+RandTrialsOrder(subj).Condition(cond).Blocks(aa).NumImageTrials;
                    NumControlTrialsInCondition=NumControlTrialsInCondition+RandTrialsOrder(subj).Condition(cond).Blocks(aa).NumControlTrials;
                end
                RandTrialsOrder(subj).Condition(cond).NumTrialsInCondition=NumTrialsInCondition;
                RandTrialsOrder(subj).Condition(cond).NumImageTrialsInCondition=NumImageTrialsInCondition;
                RandTrialsOrder(subj).Condition(cond).NumControlTrialsInCondition=NumControlTrialsInCondition;
            end
        end
end
end
