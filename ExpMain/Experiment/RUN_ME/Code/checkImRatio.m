function checkImRatio(FolderPath,ImageSize)
IsSame=1;
%load image names
currFolder=cd(FolderPath);
d=dir('*.jpg');

if length(d)<1
    cd(currFolder)
    error('One of the folders is empty')
end

wanted_imratio=ImageSize(2)/ImageSize(1);

%find image size
for ii=1:length(d)
    info=imfinfo(d(ii).name);
    imratio(ii)=info.Width/info.Height;
end

%check all images have the same ratio
if ~all(imratio==wanted_imratio)
   IsSame=0;
end

cd(currFolder)

if ~IsSame
    error('Not all images have the same ratio as ImageSize')
end
end