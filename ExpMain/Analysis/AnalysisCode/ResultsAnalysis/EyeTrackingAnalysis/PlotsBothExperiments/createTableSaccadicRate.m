function tbl_all=createTableSaccadicRate(ResultsPerm_Objects1,ResultsPerm_Objects2,Param)
%the p-value in the table is not corrected
table_ObjVsBg1=extractData(ResultsPerm_Objects1,Param,'Obj vs Bg',1);
table_ObjVsBg2=extractData(ResultsPerm_Objects2,Param,'Obj vs Bg',2);

tbl_all=[table_ObjVsBg1;table_ObjVsBg2];

    function tbl=extractData(Results,Param,name,expNum)
        visCond=[];
        startTime=[];
        endsTime=[];
        scoreCluster=[];
        pval=[];
        for kk=1:length(Results) %visibility condition
            viscond_new=[];
            startTime_new=[];
            endsTime_new=[];
            ScoreCluster_new=[];
            pval_new=[];
            if isfield(Results{kk}, 'pval')
                for aa=1:length(Results{kk}.pval<Param.alpha)
                    viscond_new(aa)=kk;
                    startTime_new(aa)=Results{kk}.clusters.startsTime(aa);
                    endsTime_new(aa)=Results{kk}.clusters.endsTime(aa);
                    ScoreCluster_new(aa)=Results{kk}.clusters.ScoreCluster(aa);
                    pval_new(aa)=Results{kk}.pval(aa);
                end
                visCond=[visCond,viscond_new];
                startTime=[startTime,startTime_new];
                endsTime=[endsTime,endsTime_new];
                scoreCluster=[scoreCluster,ScoreCluster_new];
                pval=[pval,pval_new];
            end
        end
        compName=repmat({name}, 1, length(pval));
        expNumber=ones(1,length(pval))*expNum;
        
        %% Create table
        tbl = table(compName',expNumber',visCond',startTime',endsTime',scoreCluster',pval','VariableNames',{'compName','expNumber','visCond','startTime','endsTime','scoreCluster','pval'}); 
    end
end
