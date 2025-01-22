function score=NSS(SaliencyMap,fix_h,fix_w,sigma)
%SaliencyMap - saliency map with the same size as original image
%fix_h,fix_w - height and width,correspondingly, of the locations of subjects fixations
%sigma - radius of circle around fiation, for which the NSS score is calculated 

%the NSS is calculated according to:
%Abeles, D., Amit, R., & Yuval-Greenberg, S. (2018). Oculomotor behavior during non-visual tasks: The role of visual saliency. PloS one, 13(6), e0198242.?

plotFlag=0;

%Normalize the saliency map to Z scores
mean_SaliencyMap=mean(SaliencyMap(:));
std_SaliencyMap=std(SaliencyMap(:),1); %std normalized by N
SaliencyMap_Z=(SaliencyMap-mean_SaliencyMap)./std_SaliencyMap;

%Parameters
radius=sigma;
imageSizeW = size(SaliencyMap,2);
imageSizeH = size(SaliencyMap,1);
for ii=1:length(fix_h) %fixation
    %create circle mask
    [columnsInImage rowsInImage] = meshgrid(1:imageSizeW, 1:imageSizeH);
    centerW = fix_w(ii);
    centerH = fix_h(ii);
    circleMask = (rowsInImage - centerH).^2 + (columnsInImage - centerW).^2 <= radius.^2;
    if plotFlag
        figure
        subplot(1,3,1)
        imshow(circleMask)
        title('Binary image of a circle');
        subplot(1,3,2)
        imshow(SaliencyMap_Z)
        title('Saliency map');
        subplot(1,3,3)
        imshow(SaliencyMap_Z.*circleMask)
        title('Saliency values in circle area');
    end
    %calculate average NSS score for this fixation
    NSS_fix(ii)=mean(SaliencyMap_Z(circleMask));
end
score=mean(NSS_fix);
end