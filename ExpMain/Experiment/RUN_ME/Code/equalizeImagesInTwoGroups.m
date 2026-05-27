function [vec_Shorter,vec_Longer]=equalizeImagesInTwoGroups(vecTooLong,vecTooShort,wantedLengthGroupTooLong)
%Move images from vecTooLong to vecTooShort to make vecTooLong in 
%length wantedLengthGroupTooLong the number of images
%in both vecs

NumImagesToMove=length(vecTooLong)-wantedLengthGroupTooLong;
IndImagesToMove=randperm(length(vecTooLong),NumImagesToMove);
ImagesToMove=vecTooLong(IndImagesToMove);

%Change Images
vec_Shorter=vecTooLong;
vec_Shorter(IndImagesToMove)=[];
vec_Longer=vecTooShort;
vec_Longer=[vec_Longer,ImagesToMove];
end