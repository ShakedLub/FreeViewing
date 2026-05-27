function createIttiAndKochSalMaps(Paths)
% documentation is in http://saliencytoolbox.net/doc/index.html
PlotFlag=0;

addpath(Paths.IttiKochModelPath);

%check the save saliency maps folder exists and empty
checkDirExistAndEmpty([Paths.SaliencyMapsPath,'\IttiKochModel']);

cd(Paths.ImagesPath);
d=dir('*.jpg');
cd(Paths.IttiKochModelPath)
for ii=1:size(d,1) %Images
    clear  image params salmap ind savename
    image=initializeImage([Paths.ImagesPath,'\',d(ii).name]);
    params = defaultSaliencyParams;
    salmap = makeSaliencyMap(image,params);
    %Change saliency maps to the original image size
    salmap.OrigSizeMap = imresize(salmap.data,salmap.origImage.size(1:2));
    salmap.ImageName=d(ii).name;
    if PlotFlag
        %Show example images
        figure;
        subplot(2,1,1)
        imshow(salmap.origImage.data)
        title('Original Image')
        subplot(2,1,2)
        imshow(salmap.OrigSizeMap)
        title('Saliency Map')
    end
    %saveImage
    ind=find('.'==d(ii).name);
    savename=[d(ii).name(1:(ind-1)),'.mat'];
    save([Paths.SaliencyMapsPath,'\IttiKochModel\',savename],'salmap')
end
cd(Paths.ImageAnalysisFolder)
end