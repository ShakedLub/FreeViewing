function [dataI,dataC]=deletePracticeAndExtraTrials(dataI,dataC,trialsPI,trialsPC,trialsExI,trialsExC)
[m,n]=size(dataI);
if m==1 || n==1 %cell or vector
    dataI(1:trialsPI)=[];
    dataI((end-trialsExI+1):end)=[];
    
    dataC(1:trialsPC)=[];
    dataC((end-trialsExC+1):end)=[];
elseif m>1 && n>1  %matrix
    dataI(1:trialsPI,:)=[];
    dataI((end-trialsExI+1):end,:)=[];
    
    dataC(1:trialsPC,:)=[];
    dataC((end-trialsExC+1):end,:)=[];
end
end