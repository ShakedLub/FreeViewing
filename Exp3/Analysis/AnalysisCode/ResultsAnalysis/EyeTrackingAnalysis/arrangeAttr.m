function attrs=arrangeAttr(attrs,attrNames)
%delete duplications in attribute classification based on 
%De Haas, B., Iakovidis, A. L., Schwarzkopf, D. S., & Gegenfurtner, K. R. (2019). Individual differences in visual salience vary along semantic dimensions. Proceedings of the National Academy of Sciences, 116(24), 11687-11692.
%described in the supplemantary

%Modifications: 
%The (neutral) Faces label was removed from all objects with the Emotion label (i.e. emotional faces); 
%The Smell label was removed from all objects with the Taste label; 
%The Operable and Gazed labels were removed from all objects with the Touched label; 
%The Watchable label was removed from all objects with the Text label. 

for ii=1:size(attrs,1) %images
    for jj=1:size(attrs{ii}.objs,1) %objects
        features=find(attrs{ii}.objs{jj}.features);
        nameFeatures={attrNames{features}};
        
        featuresDel=[];
        %The (neutral) Faces label was removed from all objects with the Emotion label (i.e. emotional faces)
        if any(strcmp('emotion',nameFeatures))
            ind=find(strcmp('face',nameFeatures));
            if ~isempty(ind)
                featuresDel=[featuresDel,ind];
            end
        end
        
        %The Smell label was removed from all objects with the Taste label
        if any(strcmp('taste',nameFeatures))
            ind=find(strcmp('smell',nameFeatures));
            if ~isempty(ind)
                featuresDel=[featuresDel,ind];
            end
        end
        
        %The Operable and Gazed labels were removed from all objects with the Touched label;
        if any(strcmp('touched',nameFeatures))
            ind1=find(strcmp('operability',nameFeatures));
            ind2=find(strcmp('gazed',nameFeatures));
            if ~isempty(ind1)
                featuresDel=[featuresDel,ind1];
            end
            if ~isempty(ind2)
                featuresDel=[featuresDel,ind2];
            end
        end
        
        %The Watchable label was removed from all objects with the Text label.
        if any(strcmp('text',nameFeatures))
            ind=find(strcmp('watchability',nameFeatures));
            if ~isempty(ind)
                featuresDel=[featuresDel,ind];
            end
        end
        
        %delete wanted features
        if ~isempty(featuresDel)
            features(featuresDel)=[];
            nameFeatures(featuresDel)=[];
        end
        
        if length(features)>1
            disp(nameFeatures)
        end
        
        %save data to attrs
        attrs{ii}.objs{jj}.origFeatures=attrs{ii}.objs{jj}.features;
        logicalFeatures=zeros(1,length(attrNames));
        logicalFeatures(features)=1;
        attrs{ii}.objs{jj}.features=logicalFeatures;
    end
end
end