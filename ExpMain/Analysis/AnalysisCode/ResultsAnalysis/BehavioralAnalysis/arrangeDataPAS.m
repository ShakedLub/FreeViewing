function dataPAS=arrangeDataPAS(Results)
%Parameters
for kk=1:size(Results,2) %condition
    for aa=1:size(Results{1,kk},2) %PAS answers
        dataPAS(aa).Answer=Results{1,kk}(aa).PASAnswer;
        for ii=1:size(Results,1) %subjects
            dataPAS(aa).countPAS(ii,kk)=Results{ii,kk}(aa).countPAS;
            dataPAS(aa).PercentPAS(ii,kk)=Results{ii,kk}(aa).PercentPAS;
        end
        dataPAS(aa).meanCount(kk)=mean(dataPAS(aa).countPAS(:,kk));
        dataPAS(aa).stdCount(kk)=std(dataPAS(aa).countPAS(:,kk));
        dataPAS(aa).stdErrCount(kk)=std(dataPAS(aa).countPAS(:,kk))/sqrt(length(dataPAS(aa).countPAS(:,kk)));
        
        dataPAS(aa).meanPercent(kk)=mean(dataPAS(aa).PercentPAS(:,kk));
        dataPAS(aa).stdPercent(kk)=std(dataPAS(aa).PercentPAS(:,kk));
    end
end
end