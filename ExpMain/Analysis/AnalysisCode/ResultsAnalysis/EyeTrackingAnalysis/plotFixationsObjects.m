function plotFixationsObjects(ImNumber,fixations,Results,objs,Param,Paths)

%% load or create all maps
imsize=ceil([fixations(1).condition(1).subject(1).processed.rect(4),fixations(1).condition(1).subject(1).processed.rect(3)]);

%center bias mask
if Param.RemoveCenterBias
    CenterBiasMask=CreateCenterBiasMask(Param.pixels_per_vdegree,Param.CenterBiasRadius,imsize);
end

%Object maps
%change the binarized image to the correct size and remove center
for o = 1:size(objs,1) %objects
    objs{o}.bw=imresize(objs{o}.map,imsize);
    if Param.RemoveCenterBias
        objs{o}.bw= CenterBiasMask & objs{o}.bw;
    end
end

%Some more parameters
radius=Param.pixels_per_vdegree/2; %Pixels in 0.5 deg
imageSizeW = imsize(2);
imageSizeH = imsize(1);

%original image
I=imread([Paths.ImagesFolder,'\',fixations(ImNumber).img]);
I=imresize(I,imsize);

%% arrange fixations
%initialise cell arrays
for kk=1:size(fixations(ImNumber).condition,2) %conditions
    fix_w_all{kk}=[];
    fix_h_all{kk}=[];
    fix_obj_all{kk}=[];
    subj_all{kk}=[];
end

%organize data
for kk=1:size(fixations(ImNumber).condition,2) %conditions
    for jj=1:size(fixations(ImNumber).condition(kk).subject,2) %subjects
        clear fix_w_plot fix_h_plot fixObjs subj
        fix_w_plot=fixations(ImNumber).condition(kk).subject(jj).processed.fix_w_final;
        fix_h_plot=fixations(ImNumber).condition(kk).subject(jj).processed.fix_h_final;
        
        fixObjs=[Results.image(ImNumber).condition(kk).subject(jj).objectClass];
        
        subj=ones(1,length(fix_w_plot))*jj;
        
        fix_w_all{kk}=[fix_w_all{kk};fix_w_plot];
        fix_h_all{kk}=[fix_h_all{kk};fix_h_plot];
        fix_obj_all{kk}=[fix_obj_all{kk},fixObjs];
        subj_all{kk}=[subj_all{kk},subj];
    end
    
    %create circle mask
    [columnsInImage rowsInImage] = meshgrid(1:imageSizeW, 1:imageSizeH);
    
    for ff=1:length(fix_w_all{kk}) %fixations
        centerW = fix_w_all{kk}(ff);
        centerH = fix_h_all{kk}(ff);
        map = (rowsInImage - centerH).^2 + (columnsInImage - centerW).^2 <= radius.^2;
        FixCirclesMap{kk}{ff}= map;
    end
end

%% create figure
allColors={'r','b','m','c','y','g','w'};
if ~isempty(fix_w_all{1}) | ~isempty(fix_w_all{2})
    figure
    
    for kk=1:size(fixations(ImNumber).condition,2) %conditions
        clear indclass indsubj
        if ~isempty(fix_w_all{kk})           
            if kk==1
                subplot(1,2,1)
            elseif kk==2
                subplot(1,2,2)
            end
            imagesc(I,'AlphaData',0.4)
            hold on
                      
            numObj=size(objs,1);
            
            Colors=repmat(allColors,1,ceil(numObj/length(allColors)));
            for oo=1:size(objs,1)
                imcontour(objs{oo}.bw,'LineColor',Colors{oo})
            end

            numclass=1:(size(objs,1)+1);
            for ss=1:(length(numclass)-1)
                indclass{ss}=find(fix_obj_all{kk}==numclass(ss));
            end
            indclass{ss+1}=find(isnan(fix_obj_all{kk})); %background fixations
            
            numsubj=unique(subj_all{kk});
            for ss=1:length(numsubj)
                indsubj{ss}=find(subj_all{kk}==numsubj(ss));
            end
            
            allSymbols={'o','s','d','x','*','+','^','V','<','>','p','h','o','s','d','x','*','+','^','V','<','>','p','h'};
            
            for aa=1:length(indsubj) %subject
                for bb=1:length(indclass) %class
                    clear indcategory symbol color
                    indcategory=intersect(indsubj{aa},indclass{bb});
                    symbol=allSymbols{aa};
                    
                    for ff=indcategory
                        if bb==length(indclass) %fixation on background
                            imcontour(FixCirclesMap{kk}{ff},'LineColor','k')
                            plot(fix_w_all{kk}(ff),fix_h_all{kk}(ff),symbol,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',10)
                        else
                            color=Colors{numclass(bb)};
                            imcontour(FixCirclesMap{kk}{ff},'LineColor',color)
                            plot(fix_w_all{kk}(ff),fix_h_all{kk}(ff),symbol,'MarkerEdgeColor',color,'MarkerFaceColor',color,'MarkerSize',10)
                        end
                    end
                end
            end
            hold off
            set(gca,'FontSize',18)
            
            if kk==1                
                title(['U, Image Num: ',num2str(ImNumber)])
            elseif kk==2
                title(['C, Image Num: ',num2str(ImNumber)])
            end
        end
    end
end
end