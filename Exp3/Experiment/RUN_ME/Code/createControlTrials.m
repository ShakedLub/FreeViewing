function Param=createControlTrials(Param,ExpStep)
for ii=1:length(Images_ID_For_Control) %control images
    %load image
    imName=ImageBank{Images_ID_For_Control(ii)};
    im=imread([ImageFolder,'\',imName]);
    
    %phase scrambel image
    im_scrambled = imscramble(im);
    
    %save image
    saveName=['contIm',num2str(ii),'.jpg'];
    imwrite(im_scrambled, [ImageSaveFolder,'\',saveName],'jpg');    
    if imPlot
        figure 
        subplot(1,2,1) 
        imshow(im); 
        title('Original image')
        subplot(1,2,2)
        imshow(im_scrambled)
        title('Phase scrambled image')
    end
end
Param.(['Images_ID_For_Control_',ExpStep])=Images_ID_For_Control;
current_folder=cd(ImageSaveFolder);
Images = dir('*.jpg');
cd(current_folder);
Param.(['Num_Images_Control_',ExpStep])=size(Images,1);
Param.(['Image_Names_Control_',ExpStep])={Images.name};
end