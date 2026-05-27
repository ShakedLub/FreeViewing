function createTableForMixedModel(fixations_perSubj,objects_perSubj,attrs,saveFlag,Param)
%% Fixation level
participant=[]; %subject number
session=[]; %visibility condition 1 = U, 2 = C
trial_number_overall=[]; %Trial number overall
image_name=[];
fixation_duration=[]; %fixation duration
eccentricity_fix=[]; %eccentricity of the fixations relative to the center of the image
eccentricity_obj=[];%classify each fixation to objects, eccentricity of the object
%relative to the center of the image
sacc_amp=[]; %saccade amplitude
ROI_size=[]; %ROI size - classify each fixation to objects, and write the size of the object

imsize=ceil([fixations_perSubj(1).condition(1).trial(1).processed.rect(4),fixations_perSubj(1).condition(1).trial(1).processed.rect(3)]);
center=[imsize(1)/2,imsize(2)/2];

%create center bias mask
if Param.RemoveCenterBias
    CenterBiasMask=CreateCenterBiasMask(Param.pixels_per_vdegree,Param.CenterBiasRadius,imsize);
end

for aa=1:size(attrs,1) %images
    %Image names in object struct
    ImgNamesAttr{aa}=attrs{aa}.img;
    
    for o = 1:size(attrs{aa}.objs,1) %objects
        %calcualte objs centers
        attrs{aa}.objs{o}.bw=imresize(attrs{aa}.objs{o}.map,imsize);
        label = im2double(attrs{aa}.objs{o}.bw);
        label(~attrs{aa}.objs{o}.bw) = 2; %change image to 1 and 2
        st = regionprops(label, {'Centroid'});
        attrs{aa}.objs{o}.ObjCenter = st.Centroid; %1 is width, 2 is height
        
        %calculate object ROI sizes
        if Param.RemoveCenterBias
            attrs{aa}.objs{o}.bw= CenterBiasMask & attrs{aa}.objs{o}.bw;
        end
        attrs{aa}.objs{o}.numPixObj=sum(sum(attrs{aa}.objs{o}.bw));
    end
end

%% Create vectors of data for table
for ii=1:size(fixations_perSubj,2) %subjects
    for kk=1:size(fixations_perSubj(ii).condition,2) %visibility condition
        for jj=1:size(fixations_perSubj(ii).condition(kk).trial,2) %trial
            numFix=length(fixations_perSubj(ii).condition(kk).trial(jj).processed.fix_duration_final);
            objectClass=objects_perSubj(ii).condition(kk).trial(jj).objectClass;  
            img=objects_perSubj(ii).condition(kk).trial(jj).img;
            indAttrs=find(strcmp(img,ImgNamesAttr));
            fix_w=fixations_perSubj(ii).condition(kk).trial(jj).processed.fix_w_final;
            fix_h=fixations_perSubj(ii).condition(kk).trial(jj).processed.fix_h_final;
            fix_onsets=fixations_perSubj(ii).condition(kk).trial(jj).processed.fix_onsets_final;
            sacc_onsets=fixations_perSubj(ii).condition(kk).trial(jj).processed.sacc_onsets_final;
            sacc_duration=fixations_perSubj(ii).condition(kk).trial(jj).processed.sacc_duration_final;
            sacc_amplitude=fixations_perSubj(ii).condition(kk).trial(jj).processed.sacc_amp_final;
            
            %Extract data for all fixations together
            new_par=ones(1,numFix)*fixations_perSubj(ii).subjNum;
            new_sess=ones(1,numFix)*kk;
            trial_num_overall=fixations_perSubj(ii).condition(kk).trial(jj).TrialNumberOverall;
            new_trial_number_overall=ones(1,numFix)*trial_num_overall; 
            new_dur=fixations_perSubj(ii).condition(kk).trial(jj).processed.fix_duration_final;
            
            %Extract data for each fixation alone
            new_eccentricity_fix=[];
            new_eccentricity_obj=[];
            new_sacc_amp=[];
            new_ROI_size=[];
            for ff=1:length(fix_w)
                indobj=objectClass(ff);
                if isnan(indobj) %fixation on the background
                    new_eccentricity_obj(ff)=NaN;
                    new_ROI_size(ff)=objects_perSubj(ii).condition(kk).trial(jj).numPixBg;
                else %fixation on an object
                    ObjCenter=attrs{indAttrs}.objs{indobj}.ObjCenter;
                    new_eccentricity_obj(ff)=sqrt( (center(1)-ObjCenter(2))^2 + (center(2)-ObjCenter(1))^2 );
                    new_ROI_size(ff)=attrs{indAttrs}.objs{indobj}.numPixObj; 
                end
                
                new_eccentricity_fix(ff)=sqrt( (center(1)-fix_h(ff))^2 + (center(2)-fix_w(ff))^2 );
                
                %saccade onset + saccade duration = fixation onset + 1
                fix_onset=fix_onsets(ff);
                sacc_offsets=sacc_onsets+sacc_duration-1;
                saccToInclude=find(sacc_offsets==fix_onset);
                if isempty(saccToInclude)
                    new_sacc_amp(ff)=NaN;
                else
                    new_sacc_amp(ff)=sacc_amplitude(saccToInclude);
                end
            end

            new_image_name=repmat({img},1,numFix);
            
            %Save data of this trial
            participant=[participant,new_par];
            session=[session,new_sess];
            trial_number_overall=[trial_number_overall,new_trial_number_overall];     
            if ii==1 && kk==1 && jj==1
                image_name=new_image_name;
            else
                image_name={image_name{:},new_image_name{:}};
            end
            
            fixation_duration=[fixation_duration,new_dur];
            
            eccentricity_fix=[eccentricity_fix,new_eccentricity_fix]; 
            eccentricity_obj=[eccentricity_obj,new_eccentricity_obj];
            sacc_amp=[sacc_amp,new_sacc_amp]; 
            ROI_size=[ROI_size,new_ROI_size]; 
        end
    end
end

%% Create table
tbl = table(participant',session',trial_number_overall',image_name',fixation_duration',eccentricity_fix',eccentricity_obj',sacc_amp',ROI_size','VariableNames',{'participant','session','trial_number_overall','image_name','fixation_duration','eccentricity_fix','eccentricity_obj','sacc_amp','ROI_size'});

%% Save table
if saveFlag    
    writetable(tbl,['FixationDurationControlAnalysis',Param.EXP_NUM,'.csv'])
end
