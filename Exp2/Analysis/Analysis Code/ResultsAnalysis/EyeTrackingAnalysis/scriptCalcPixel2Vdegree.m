%Param
Param.SCREEN_WIDTH=53.2;
Param.window_size= [1920 1080];
Param.SUBJECT_DISTANCE_FROM_SCREEN=70;
Param.cm_per_pixels= Param.SCREEN_WIDTH/Param.window_size(1);

%calculate pixels to visual degree in place holder
pixels=[452,339];
v_angles= pixels2vAngles(pixels,Param);

%caculate pixels in vdegree
screen_width_in_visual_degrees= pixels2vAngles(Param.window_size(1),Param);
pixels_per_vdegree= Param.window_size(1)/screen_width_in_visual_degrees;

%calculate ppi
screen_width_in_pixels= Param.window_size(1);
screen_width_in_cm= Param.SCREEN_WIDTH;
screen_width_in_inch= screen_width_in_cm*0.393700787;
pixel_per_inch=screen_width_in_pixels/screen_width_in_inch;

function v_angles= pixels2vAngles(pixels,Param)
v_angles= [];
for pixel_i= 1:numel(pixels)
    v_angles= [v_angles, rad2deg(2*atan(((pixels(pixel_i)/2)*Param.cm_per_pixels)/Param.SUBJECT_DISTANCE_FROM_SCREEN))];
end
end
    
function pixels= vAngles2pixels(v_angles,Param)
pixels= [];
pixels_per_cm= Param.window_size(1)/Param.SCREEN_WIDTH;
for v_angle_i= 1:numel(v_angles)
    pixels= [pixels, 2*Param.SUBJECT_DISTANCE_FROM_SCREEN*tan(deg2rad(v_angles(v_angle_i)/2))*pixels_per_cm];
end
end

function rads = deg2rad(degs)
rads = degs*pi/180;
end

function degs = rad2deg(rads)
degs = rads*180/pi;
end