function createStereograms(canvasSize,savefolder)

%parameters
%canvasSize=[180 150]; %final size of bmp file
imageSize=0.75; %in percent from canvas size
figBackgrDepth=15; %determines observed height of figure from background, best is between 15 and -15

%%
minDim = min(canvasSize);

% %create shape - oval
% [x y]=meshgrid(-1:2/(minDim-1):1,-1:2/(minDim-1):1); %create BW image
% G =figBackgrDepth*round(exp(-1.*(x.^2+y.^2)./imageSize^2));
% ovalCanvas=zeros(canvasSize); %fit to canvas size
% ovalCanvas((1+(canvasSize(1)-minDim)/2):(minDim+(canvasSize(1)-minDim)/2), (1+(canvasSize(2)-minDim)/2):(minDim+(canvasSize(2)-minDim)/2))=G;
% 
% [leftStereogramOval rightStereogramOval] = makeStereogram(ovalCanvas); %create stereograms
% 
% imwrite(leftStereogramOval, [savefolder,'\','leftStereogramOval.bmp']) %write to file
% imwrite(rightStereogramOval, [savefolder,'\','rightStereogramOval.bmp'])

%create shape - square
G=zeros(minDim); %create BW image
G((1-imageSize)*minDim:imageSize*minDim, (1-imageSize)*minDim:imageSize*minDim)=figBackgrDepth;
squareCanvas=zeros(canvasSize); %fit to canvas size
squareCanvas((1+(canvasSize(1)-minDim)/2):(minDim+(canvasSize(1)-minDim)/2), (1+(canvasSize(2)-minDim)/2):(minDim+(canvasSize(2)-minDim)/2))=G;

[leftStereogramSquare rightStereogramSquare] = makeStereogram(squareCanvas); %create stereograms

imwrite(leftStereogramSquare, [savefolder,'\','leftStereogramSquare.bmp']) %write to file
imwrite(rightStereogramSquare, [savefolder,'\','rightStereogramSquare.bmp'])

%%

function [leftStereogramImage rightStereogramImage] = makeStereogram(A)

%modified from stereogram.m by Iari-Gabriel Marino, Ph.D. University of Parma, Physics Department

A=double(A);
A=round(A);

RDM = round(rand(size(A))); % Random Dot Matrix

% Initial left and right images
SX = RDM;
DX = RDM;

% For each region of A, a random dot pattern
% is shifted of an amount depending on the level
for k = min(min(A)):max(max(A))
    if k<0
        level = size(A,2)+k;
        TT = [RDM(:,level+1:end) RDM(:,1:level)];
    elseif k>0
        level = k;
        TT = [RDM(:,level+1:end) RDM(:,1:level)];
    elseif k==0
        level = 1;
        TT = RDM;
    end
    DX(A==k) = TT(A==k);
end

leftStereogramImage = SX;
rightStereogramImage = DX;

