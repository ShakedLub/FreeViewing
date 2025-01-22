%calculate pixels to visual degree
pixels=[452,339];
v_angles= [];
SUBJECT_DISTANCE_FROM_SCREEN=70;
cm_per_pixels= 52/1920;
for pixel_i= 1:numel(pixels)
    v_angles= [v_angles, rad2deg(2*atan(((pixels(pixel_i)/2)*cm_per_pixels)/SUBJECT_DISTANCE_FROM_SCREEN))];
end

%calculate ppi
screen_width_in_pixels= 1920;
screen_width_in_cm= 52;
screen_width_in_inch= screen_width_in_cm*0.393700787;
pixel_per_inch=screen_width_in_pixels/screen_width_in_inch;