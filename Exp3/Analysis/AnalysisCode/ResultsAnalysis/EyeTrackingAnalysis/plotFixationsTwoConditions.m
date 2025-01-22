function plotFixationsTwoConditions(ImNumber,fixations,Results,Param,Paths)
%OneSubject==1 plot data of only one subject
%OneSubject==0 plot data of all subjects
for kk=1:size(fixations(ImNumber).condition,2) %conditions
    fix_w_all{kk}=[];
    fix_h_all{kk}=[];
    fix_class_all{kk}=[];
    subj_all{kk}=[];
end

%organize data
for kk=1:size(fixations(ImNumber).condition,2) %conditions
    for jj=1:size(fixations(ImNumber).condition(kk).subject,2) %subjects
        clear fix_w_plot fix_h_plot fixClassifications subj
        fix_w_plot=fixations(ImNumber).condition(kk).subject(jj).processed.fix_w_final;
        fix_h_plot=fixations(ImNumber).condition(kk).subject(jj).processed.fix_h_final;
        
        fixClassifications=Results.image(ImNumber).condition(kk).subject(jj).fixClassifications;
        
        subj=ones(1,length(fix_w_plot))*jj;
        
        fix_w_all{kk}=[fix_w_all{kk};fix_w_plot];
        fix_h_all{kk}=[fix_h_all{kk};fix_h_plot];
        fix_class_all{kk}=[fix_class_all{kk},fixClassifications];
        subj_all{kk}=[subj_all{kk},subj];
    end
end

%create figure
if ~isempty(fix_w_all{1}) | ~isempty(fix_w_all{2})
    figure
    I=imread([Paths.ImagesFolder,'\',fixations(ImNumber).img]);
    I=imresize(I,size(Param.HighLevelfixationMap_B));

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
            imcontour(Param.HighLevelfixationMap_B,'LineColor','b')
            imcontour(Param.LowLevelSalMap_B,'LineColor','r')
            imcontour(Param.HighAndLowMap,'LineColor','m')
            
            numclass=1:4;
            for ss=1:length(numclass)
                indclass{ss}=find(fix_class_all{kk}==numclass(ss));
            end
            
            numsubj=unique(subj_all{kk});
            for ss=1:length(numsubj)
                indsubj{ss}=find(subj_all{kk}==numsubj(ss));
            end
            
            allSymbols={'o','s','d','x','*','+','^','V','<','>','p','h'};
            
            allColors={'r','b','m','k'}; %the colors are for: low ,high, high and low, background
            for aa=1:length(indsubj) %subject
                for bb=1:length(indclass) %class
                    clear indcategory symbol color
                    indcategory=intersect(indsubj{aa},indclass{bb});
                    symbol=allSymbols{aa};
                    color=allColors{numclass(bb)};
                    plot(fix_w_all{kk}(indcategory),fix_h_all{kk}(indcategory),symbol,'MarkerEdgeColor',color,'MarkerFaceColor',color,'MarkerSize',10)
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