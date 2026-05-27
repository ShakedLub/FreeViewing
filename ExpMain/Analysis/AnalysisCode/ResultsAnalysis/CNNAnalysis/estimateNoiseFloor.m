function noise=estimateNoiseFloor(fixations,subjNum,imagesToInclude,Param,Paths)

%change fixations to include only images that were included in creating the
%fixation map RDMs (images that include data from both conditions)
if ~isequal(Param.ImageNames(imagesToInclude),{fixations.img})
    ImageNames=Param.ImageNames(imagesToInclude);
    indinfixvec=[];
    for aa=1:size(ImageNames,2) %images
        ind=find(strcmp(ImageNames{aa},{fixations.img}));
        indinfixvec=[indinfixvec,ind];
    end
    fixations=fixations(indinfixvec);
end

for nn=1:Param.numReptitionsSTDERR
    %% split participants to two groups
    N=round(length(subjNum)/2);
    subjNumRand=subjNum(randperm(length(subjNum)));
    group1=subjNumRand(1:N);
    group2=subjNumRand((N+1):end);

    %% for each group delete from fixations participants that are not included in the group
    fixations1=deleteParticipants(fixations,group2);
    fixations2=deleteParticipants(fixations,group1);

    %% exclude image that do not appear in both fixations structs
    for aa=1:length(Param.ImageNames)
        ind1=find(strcmp(Param.ImageNames{aa},{fixations1.img}));
        ind2=find(strcmp(Param.ImageNames{aa},{fixations2.img}));
        if isempty(ind1) && ~isempty(ind2)
            fixations2(ind2)=[];
        elseif isempty(ind2) && ~isempty(ind1)
            fixations1(ind1)=[];
        end
    end

    numImVec(nn)=size(fixations1,2);

    %% create fixation maps
    [FixMaps1,~]=createFixationMaps(fixations1,Param,Paths);
    [FixMaps2,~]=createFixationMaps(fixations2,Param,Paths);

    %% calculate RDM for fixation maps
    FixMaps1=calculateRDMFixationMaps(FixMaps1);
    FixMaps2=calculateRDMFixationMaps(FixMaps2);

    %% calcaulte correlation between RDMs for each visibility condition
    for cc=1:size(FixMaps1.condition,2) %conditions
        %compute spearman correlation
        RDM1=FixMaps1.condition(cc).RDM;
        %zeros in diagonal
        RDM1(1:1+size(RDM1,1):end) = 0;
        %converts a square symmetric matrix with zeros along the diagonal,
        % into a vector containing the elements below the diagonal
        RDMvec1 = squareform(RDM1);

        RDM2=FixMaps2.condition(cc).RDM;
        %zeros in diagonal
        RDM2(1:1+size(RDM2,1):end) = 0;
        %converts a square symmetric matrix with zeros along the diagonal,
        % into a vector containing the elements below the diagonal
        RDMvec2 = squareform(RDM2);

        R(1,cc)=corr(RDMvec1',RDMvec2','type','Spearman');
    end

    %% calcaulte 1 minus split half correlation
    Rsb=(2*R)./(1+R);
    noiseMat(nn,:)=1-Rsb;
end
noise.noise=mean(noiseMat); %This is an estimation of noise ceiling lower bound.
noise.noiseMat=noiseMat;
noise.numImVec=numImVec;
noise.meanNumIm=mean(numImVec);
noise.stdNumIm=std(numImVec);

    function fix=deleteParticipants(fix,subjExclude)
        for ii=1:size(fix,2) %images
            for kk=1:size(fix(ii).condition,2) %condition
                subjs=[fix(ii).condition(kk).subject.subjNum];
                if any(ismember(subjs,subjExclude))
                    %delete trial of participant from main data
                    fix(ii).condition(kk).subject(ismember(subjs,subjExclude))=[];
                end
            end
        end

        % delete from fixations images that don't have data from both visibility
        %conditions, if no subj were left in one of the visibility
        %conditions, after deleting subjects
        indDel=[];
        for ii=1:size(fix,2) %images
            if isempty(fix(ii).condition(1).subject) || isempty(fix(ii).condition(2).subject)
                indDel=[indDel,ii];
            end
        end
        if ~isempty(indDel)
            fix(indDel)=[];
        end
    end

end