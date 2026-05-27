function plotSaccadeRateTraceObjects(Results,ResultsPermObj,Paths,Param,aa,kk,ylab,ylimits)
% plot 
cd(Paths.ShadedStdPlot)

subplot(4,1,aa);
lineOut1=stdshade(Results.condition(kk).SaccRate_Obj(:,Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames), 0.3, 'b',Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames);
hold on;
lineOut2=stdshade(Results.condition(kk).SaccRate_Bg(:,Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames), 0.3, 'r',Param.AnalysisMinTimeLimitFrames:Param.AnalysisMaxTimeLimitFrames);
if aa == 1
    title('Saccade rate trace','FontWeight','normal')
end
if aa == 4
    xlabel('time (msec)')
end
ylabel(ylab)
set(gca,'FontSize',20)

ylim(ylimits)
limits=axis; %[x1,x2,y1,y2]
df=(limits(4)-limits(3))/5;
if isfield(ResultsPermObj{kk}, 'pval')
    sigpval=find(ResultsPermObj{kk}.pval<Param.alpha);
    for ii=1:length(sigpval)
        line([ResultsPermObj{kk}.clusters.startsTime(sigpval(ii)),ResultsPermObj{kk}.clusters.endsTime(sigpval(ii))],[limits(4)-df,limits(4)-df],'Color','blue','LineWidth',1)
    end
end
Ax = gca;
Ax.Box = 'off';
hold off
if aa == 1
    legend([lineOut1,lineOut2],{'Object','Background'})
    lgd.Location='best';
end
cd(Paths.codePath)
end