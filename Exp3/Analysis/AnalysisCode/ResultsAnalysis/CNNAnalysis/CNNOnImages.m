function Activations=CNNOnImages(Param,Paths,imagesToInclude)
% load googlenet
net = googlenet('Weights','places365');
inputSize = net.Layers(1).InputSize;

%layer names
LayerNames={net.Layers(Param.LayerNum).Name};

%create center bias mask
if Param.RemoveCenterBias
    CenterBiasMask(:,:,1)=CreateCenterBiasMask(Param.pixels_per_vdegree,Param.CenterBiasRadius,Param.ImSize);
    CenterBiasMask(:,:,2)=CenterBiasMask(:,:,1);
    CenterBiasMask(:,:,3)=CenterBiasMask(:,:,1);
end

for ii=1:length(imagesToInclude)
    % load image
    I=imread([Paths.ImagesFolder,'\',Param.ImageNames{imagesToInclude(ii)}]);
    %resize image to screen presentation size
    I = imresize(I,Param.ImSize);

    if Param.RemoveCenterBias
        I(~CenterBiasMask)=0;
    end

    %resize image
    I = imresize(I,inputSize(1:2));

    for ll=1:length(LayerNames)
        Activations.imageActivations{ii}{ll}=double(activations(net,I,LayerNames{ll}));
    end
end
Activations.ImageNames={Param.ImageNames{imagesToInclude}};
Activations.LayerNum=Param.LayerNum;
Activations.LayerNames=LayerNames;
%shorten layer names
for ii=1:size(Activations.LayerNames,2) %layers
    Activations.LayerNamesShort{ii}=Activations.LayerNames{ii};
    Activations.LayerNamesShort{ii}=regexprep(Activations.LayerNamesShort{ii},'-','(');
    Activations.LayerNamesShort{ii}=['L', num2str(ii),', ',Activations.LayerNamesShort{ii},')'];
    Activations.LayerNamesShort{ii}=regexprep(Activations.LayerNamesShort{ii},'_','');
    Activations.LayerNamesShort{ii}=regexprep(Activations.LayerNamesShort{ii},'relu','');
end
end