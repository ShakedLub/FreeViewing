function checkImSize(FolderPath,ImageSize)
IsSame=1;
%load image names
currFolder=cd(FolderPath);
d=dir('*.jpg');

if length(d)<1
    cd(currFolder)
    error('One of the folders is empty')
end

%find image size
for ii=1:length(d)
    info=imfinfo(d(ii).name);
    width(ii)=info.Width;
    height(ii)=info.Height;
end

%check all images are in the same size
if ~all(width==ImageSize(2))
   IsSame=0;
end
if ~all(height==ImageSize(1))
   IsSame=0;
end

cd(currFolder)

if ~IsSame
    error('Not all images are in the same size as ImageSize')
end
end