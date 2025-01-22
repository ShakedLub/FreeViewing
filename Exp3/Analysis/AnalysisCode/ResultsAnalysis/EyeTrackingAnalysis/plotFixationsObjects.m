function plotFixationsObjects(ImNumber,fixations,Results,objs,Param,Paths)
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
end

imsize=ceil([fixations(1).condition(1).subject(1).processed.rect(4),fixations(1).condition(1).subject(1).processed.rect(3)]);

%create figure
allColors={'r','b','m','c','y','g','w'};
if ~isempty(fix_w_all{1}) | ~isempty(fix_w_all{2})
    figure
    I=imread([Paths.ImagesFolder,'\',fixations(ImNumber).img]);
    I=imresize(I,imsize);

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
                    
                    if bb==length(indclass)
                        plot(fix_w_all{kk}(indcategory),fix_h_all{kk}(indcategory),symbol,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',10)
                    else
                        color=Colors{numclass(bb)};
                        plot(fix_w_all{kk}(indcategory),fix_h_all{kk}(indcategory),symbol,'MarkerEdgeColor',color,'MarkerFaceColor',color,'MarkerSize',10)
                    end
                end
            end
            hold off
            set(gca,'FontSize',18)
            
            if kk==1                
                title(['U condition, Image Num: ',num2str(ImNumber)])
            elseif kk==2
                title(['C condition, Image Num: ',num2str(ImNumber)])
            end
        end
    end
end
end