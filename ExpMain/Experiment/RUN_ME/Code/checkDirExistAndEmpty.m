function checkDirExistAndEmpty(Path)
if ~isfolder(Path)
    mkdir(Path);
else
    ff=dir(Path);
    if size(ff,1)>=3 %Folder is not empty       
        cd(Path)
        error(['The output folder: ',Path,' is not empty'])
    end
end
end