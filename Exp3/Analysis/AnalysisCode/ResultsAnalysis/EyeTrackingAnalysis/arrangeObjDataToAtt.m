function [countFixAtt,fixDurAtt,countFixNoAtt,fixDurNoAtt]=arrangeObjDataToAtt(countFixObj,fixDurObj,objs)
%Parameters
FaceAtt=2;
EmFaAtt=3;
PesonAtt=13;

%initialize attribute data
countFixAtt=zeros(1,length(objs{1}.features));
countFixNoAtt=0;
fixDurAtt=cell(1,length(objs{1}.features));
fixDurNoAtt=[];

for oo=1:length(countFixObj) %objects
    if countFixObj(oo)~=0
        Count=countFixObj(oo);
        Dur=fixDurObj{oo};
        
        ObjAttributes=find(logical(objs{oo}.features));
        if ~isempty(ObjAttributes)
            for aa=1:length(ObjAttributes)
                if ObjAttributes(aa)==FaceAtt || ObjAttributes(aa)==EmFaAtt 
                    %if face or emotional face, count in attribute, and in
                    %person
                    countFixAtt(PesonAtt)=countFixAtt(PesonAtt)+Count;
                    fixDurAtt{PesonAtt}=[fixDurAtt{PesonAtt},Dur];
                end
                countFixAtt(ObjAttributes(aa))=countFixAtt(ObjAttributes(aa))+Count;
                fixDurAtt{ObjAttributes(aa)}=[fixDurAtt{ObjAttributes(aa)},Dur];
            end
        else
            countFixNoAtt=countFixNoAtt+Count;
            fixDurNoAtt=[fixDurNoAtt,Dur];
        end
    end
end
end