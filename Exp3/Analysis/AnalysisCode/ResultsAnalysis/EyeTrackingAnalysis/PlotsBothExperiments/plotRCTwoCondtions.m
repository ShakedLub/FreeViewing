function plotRCTwoCondtions(dataP,prc,titleText,measure,rows,columns,plotNum,Paths,FlagAstU,FlagAstC,xexponent)
%%rain cloud plot
%addpath cd cbrewer
wd=cd(Paths.RainCloudPlot);
cbrewer_dir=fullfile(pwd,'cbrewer');
addpath(cbrewer_dir);

% get nice colours from colorbrewer
cb = cbrewer('qual', 'Set3', 12, 'pchip');
cl2=cb(10,:);
clline2=[0.4940 0.1840 0.5560];

cl1=cb(5,:);
clline1=[0 0.4470 0.7410];

%divide or multiply data to the wanted units
%x axis
if ~isempty(xexponent)
    f=fieldnames(dataP);
    for ii=1:size(f,1)
        dataP.(f{ii})=dataP.(f{ii})*10^xexponent;
    end
end

%create two plots one for each experiment
for ii=1:2 %two experiments
    ax{ii}=subplot(rows,columns,plotNum(ii));
    if ii==1
        data1=dataP.data1Exp1;
        data2=dataP.data2Exp1;
    else
        data1=dataP.data1Exp2;
        data2=dataP.data2Exp2;
    end
    h2{ii} = raincloud_plot(data2, 'box_on', 1, 'color', cl2, 'cloud_edge_col', cl2,'alpha', 0.5,...
        'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35, 'box_col_match', 0);
    h1{ii} = raincloud_plot(data1, 'box_on', 1, 'color', cl1,'cloud_edge_col', cl1, 'alpha', 0.5,...
        'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
        'box_col_match', 0);
    box off
    xlimits{ii}=xlim;
    alpha1(ii)=prctile(data1,prc);
    alpha2(ii)=prctile(data2,prc);
    
    %add vertical lines
    if ii==1
        realVal1=dataP.realVal1Exp1;
        realVal2=dataP.realVal2Exp1;
    else
        realVal1=dataP.realVal1Exp2;
        realVal2=dataP.realVal2Exp2;
    end
    
    hold on
    
    %alpha U & C
    xline(alpha1(ii),'Color',clline1,'LineStyle','--','LineWidth',2);
    xline(alpha2(ii),'Color',clline2,'LineStyle','--','LineWidth',2);
    
    % real value U & C
    xline(realVal1,'Color',clline1,'LineWidth',2);
    xline(realVal2,'Color',clline2,'LineWidth',2);

    %astricks
    lim=axis;
    height=((lim(4)-lim(3))/12);
    if ~isempty(FlagAstU)
        if ( (prc == 5 && realVal1 < alpha1(ii)) || (prc == 95 && realVal1 > alpha1(ii)) ) &&  FlagAstU(ii)==1 %significant
            plot(realVal1,lim(4),'*','MarkerSize',10,'Color',[0 0.4470 0.7410]);
        end
    else
        if (prc == 5 && realVal1 < alpha1(ii)) || (prc == 95 && realVal1 > alpha1(ii))  %significant
            plot(realVal1,lim(4),'*','MarkerSize',10,'Color',[0 0.4470 0.7410]);
        end
    end
    if ~isempty(FlagAstC)
        if ( (prc == 5 && realVal2 < alpha2(ii)) || (prc == 95 && realVal2 > alpha2(ii)) ) &&  FlagAstC(ii)==1 %significant
            plot(realVal2,lim(4),'*','MarkerSize',10,'Color',[0.4940 0.1840 0.5560]);
        end
    else
        if (prc == 5 && realVal2 < alpha2(ii)) || (prc == 95 && realVal2 > alpha2(ii)) %significant
            plot(realVal2,lim(4),'*','MarkerSize',10,'Color',[0.4940 0.1840 0.5560]);
        end
    end
    
    %% change ticks before breaking axis
    %change yticks to be only positive and only 2 ticks
    yedge=ylim;
    yt = yticks;
    yt = yt(yt>=0);
    yt = [yt(1),yedge(2)];
    if round(yt(2),1)>yt(2)
        yt(2)=yt(2)-0.05;
    end   
    yt=round(yt,1);
    yticks(yt)
    
    %change xticks not to have a scientific notation
    % if the exponent is -3 or bigger
    xt = xticks;
    if xt(end)>1e-3
        bx = ancestor(ax{ii}, 'axes');
        bx.XAxis.Exponent = 0;
    end
    
    %xtickangle(45)
end

%change x-axis to be the same
linkaxes([ax{1},ax{2}],'x')

cd(wd);

switch measure
    case 'FPP'
        if ~isempty(xexponent)
            xlabelText=['Number of fixations per 10^',num2str(xexponent),' pixels'];
        else
            xlabelText='Number of fixations per pixel';
        end
    case 'FDPP'
        if ~isempty(xexponent)
            xlabelText=['Fixation duration (msec) per 10^',num2str(xexponent),' pixels'];
        else
            xlabelText='Fixation duration (msec) per pixel';
        end
end

%continue working on both plots
for ii=1:2 %two experiments
    clear h
    subplot(rows,columns,plotNum(ii))
    
    if ii==2 && ismember(plotNum(2),[columns+2,columns+4,columns*3+2,columns*3+4])
        xlabel(xlabelText)
    end
    
    firstRowVec=1:columns;
    if any(ismember(plotNum(ii),firstRowVec))
        title(titleText)
    end
    
    beginingOfRowVec=1:columns:(rows*columns);
    if any(ismember(plotNum(ii),beginingOfRowVec)) 
        if ii==1
            ylabel('Exp 1')
        else
            ylabel('Exp 2')
        end
    end
    
    set(gca,'FontSize',20)
    
    %Ideal xlimits
    lim=[min(xlimits{1}(1),xlimits{2}(1)),max(xlimits{1}(2),xlimits{2}(2))];
    
    %vertical lines
    if ii==1
        realVal1=dataP.realVal1Exp1;
        realVal2=dataP.realVal2Exp1;
    else
        realVal1=dataP.realVal1Exp2;
        realVal2=dataP.realVal2Exp2;
    end
    
    %add a break in the axis if the lines are far from the initial plot
    %limits
    rth=((lim(2)-lim(1))/2)*2;
    r=((lim(2)-lim(1))/7)*2;
    if realVal2<(lim(1)-rth) && realVal1<(lim(1)-rth)
        if all(sort(realVal2,realVal1,lim(1))==[realVal2,realVal1,lim(1)]) && (lim(1)-realVal1 > realVal1-realVal2)
            wd=cd(Paths.breakAxis);
            %Break The Axes
            if realVal1+r >= lim(1)-r
                r=((lim(2)-lim(1))/15)*2;
                breakint=[realVal1+r,lim(1)-r];
            else
                breakint=[realVal1+r,lim(1)-r];
            end
            h = breakxaxis(breakint);
        elseif all(sort(realVal2,realVal1,lim(1))==[realVal2,realVal1,lim(1)]) && (lim(1)-realVal1 <= realVal1-realVal2)
            wd=cd(Paths.breakAxis);
            %Break The Axes
            if realVal2+r >= realVal1-r
                r=((lim(2)-lim(1))/15)*2;
                breakint=[realVal2+r,realVal1-r];
            else
                breakint=[realVal2+r,realVal1-r];
            end
            h = breakxaxis(breakint);
        elseif all(sort(realVal1,realVal2,lim(1))==[realVal1,realVal2,lim(1)]) && (lim(1)-realVal2 > realVal2-realVal1)
            wd=cd(Paths.breakAxis);
            %Break The Axes
            if realVal2+r >= lim(1)-r
                r=((lim(2)-lim(1))/15)*2;
                breakint=[realVal2+r,lim(1)-r];
            else
                breakint=[realVal2+r,lim(1)-r];
            end
            h = breakxaxis(breakint);
        elseif all(sort(realVal1,realVal2,lim(1))==[realVal1,realVal2,lim(1)]) && (lim(1)-realVal2 <= realVal2-realVal1)
            wd=cd(Paths.breakAxis);
            %Break The Axes
            if realVal1+r >= realVal2-r
                r=((lim(2)-lim(1))/15)*2;
                breakint=[realVal1+r,realVal2-r];
            else
                breakint=[realVal1+r,realVal2-r];
            end
            h = breakxaxis(breakint);
        end
    elseif realVal2<(lim(1)-rth) && realVal1>=(lim(1)-rth)
        wd=cd(Paths.breakAxis);
        %Break The Axes
        if realVal2+r >= lim(1)-r
            r=((lim(2)-lim(1))/15)*2;
            breakint=[realVal2+r,lim(1)-r];
        else
            breakint=[realVal2+r,lim(1)-r];
        end
        h = breakxaxis(breakint);
    elseif realVal1<(lim(1)-rth) && realVal2>=(lim(1)-rth)
        wd=cd(Paths.breakAxis);
        %Break The Axes
        if realVal1+r >= lim(1)-r
            r=((lim(2)-lim(1))/15)*2;
            breakint=[realVal1+r,lim(1)-r];
        else
            breakint=[realVal1+r,lim(1)-r];
        end
        h = breakxaxis(breakint);
    elseif realVal2>(lim(2)+rth) && realVal1>(lim(2)+rth)
        if all(sort(lim(2),realVal1,realVal2)==[lim(2),realVal1,realVal2]) && (realVal1-lim(2) > realVal2-realVal1)
            wd=cd(Paths.breakAxis);
            %Break The Axes
            if lim(2)+r >= realVal1-r
                r=((lim(2)-lim(1))/15)*2;
                breakint=[lim(2)+r,realVal1-r];
            else
                breakint=[lim(2)+r,realVal1-r];
            end
            h = breakxaxis(breakint);
        elseif all(sort(lim(2),realVal1,realVal2)==[lim(2),realVal1,realVal2]) && (realVal1-lim(2) <= realVal2-realVal1)
            wd=cd(Paths.breakAxis);
            %Break The Axes
            if realVal1+r >= realVal2-r
                r=((lim(2)-lim(1))/15)*2;
                breakint=[realVal1+r,realVal2-r];
            else
                breakint=[realVal1+r,realVal2-r];
            end
            h = breakxaxis(breakint);
        elseif all(sort(lim(2),realVal2,realVal1)==[lim(2),realVal2,realVal1]) && (realVal2-lim(2) > realVal1-realVal2)
            wd=cd(Paths.breakAxis);
            %Break The Axes
            if lim(2)+r >= realVal2-r
                r=((lim(2)-lim(1))/15)*2;
                breakint=[lim(2)+r,realVal2-r];
            else
                breakint=[lim(2)+r,realVal2-r];
            end
            h = breakxaxis(breakint);
        elseif all(sort(lim(2),realVal2,realVal1)==[lim(2),realVal2,realVal1]) && (realVal2-lim(2) <= realVal1-realVal2)
            wd=cd(Paths.breakAxis);
            %Break The Axes
            if realVal2+r >= realVal1-r
                r=((lim(2)-lim(1))/15)*2;
                breakint=[realVal2+r,realVal1-r];
            else
                breakint=[realVal2+r,realVal1-r];
            end
            h = breakxaxis(breakint);
        end
    elseif realVal2>(lim(2)+rth) && realVal1<=(lim(2)+rth)
        wd=cd(Paths.breakAxis);
        %Break The Axes
        if lim(2)+r >= realVal2-r
            r=((lim(2)-lim(1))/15)*2;
            breakint=[lim(2)+r,realVal2-r];
        else
            breakint=[lim(2)+r,realVal2-r];
        end
        h = breakxaxis(breakint);
    elseif realVal1>(lim(2)+rth) && realVal1<=(lim(2)+rth)
        wd=cd(Paths.breakAxis);
        %Break The Axes
        if lim(2)+r >= realVal1-r
            r=((lim(2)-lim(1))/15)*2;
            breakint=[lim(2)+r,realVal1-r];
        else
            breakint=[lim(2)+r,realVal1-r];
        end
        h = breakxaxis(breakint);
    end
    
    %% change x ticks after breaking the axis   
    if exist('h','var')
        %same exponent in the two parts of breaking the axis
        lx = ancestor(h.leftAxes, 'axes');
        rx = ancestor(h.rightAxes, 'axes');
        if lx.XAxis.Exponent < rx.XAxis.Exponent
            lx.XAxis.Exponent = rx.XAxis.Exponent;
        elseif rx.XAxis.Exponent < lx.XAxis.Exponent
            rx.XAxis.Exponent = lx.XAxis.Exponent;
        end
        
        %display only two x ticks
        % the smallest tick in left axis
        xt=lx.XTick;
        xt = xt(1);
        lx.XTick=xt;
        % the biggest tick in right axis
        xt=rx.XTick;
        xt = xt(end);
        rx.XTick=xt;
    else
        %display only two x ticks
        xt=xticks;
        xt = xt([1,end]);
        xticks(xt)
    end
    
    cd(wd)
    hold off
    
    if plotNum(ii)==1 
        lgd=legend([h1{ii}{1} h2{ii}{1}], {'U', 'C'});
        lgd.Location='best';
        lgd.FontSize=18;
    end
end

cd(wd)
end