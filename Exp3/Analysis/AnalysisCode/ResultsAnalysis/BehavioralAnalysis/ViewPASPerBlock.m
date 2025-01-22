subjNum=17;
cond=2;
blocks=unique([EXPDATA_ALL{subjNum,cond}.TrialsAnalysis.BlockNum]);
for bb=1:length(blocks)
    for pp=1:4
        numPAS(bb,pp)=sum([EXPDATA_ALL{subjNum,cond}.TrialsAnalysis([EXPDATA_ALL{subjNum,cond}.TrialsAnalysis.BlockNum]==bb).response_PAS_Q]==pp);
    end
end
figure;
bar(numPAS)
xlabel('Block')
legend({'PAS 1','PAS 2','PAS 3','PAS 4'})