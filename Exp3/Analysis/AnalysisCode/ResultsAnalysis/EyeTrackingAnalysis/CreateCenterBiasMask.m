function CenterBiasMask=CreateCenterBiasMask(pixels_per_vdegree,CenterBiasRadius,ImSize)
imageSizeW=ImSize(2);
imageSizeH=ImSize(1);
radius=pixels_per_vdegree * CenterBiasRadius;

%create circle mask
[columnsInImage rowsInImage] = meshgrid(1:imageSizeW, 1:imageSizeH);
centerW=imageSizeW/2;
centerH=imageSizeH/2;

CenterBiasMask = (rowsInImage - centerH).^2 + (columnsInImage - centerW).^2 <= radius.^2;
CenterBiasMask = ~ CenterBiasMask;
end