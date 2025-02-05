% function masks = make_mondrian_masks(sz_x,sz_y,n_masks,shape,selection)

% 

% This function creates Mondrian masks that can be used for continuous

% flash suppression. The shape of the elements of the masks is normally

% square, but can be predefined as being circular or elliptic or adjusted 

% manually. Other variables are predefined, but can be changed within the

% code. If no output is provided, then the masks are drawn directly.

% My favorite settings for experiments are shape = 2 and colored = 1.

%

% Input variables:

%   sz_x:      Size of mask in x-dimension

%   sz_y:      Size of mask in y-dimension (large difference to sz_x may cause error)

%   n_masks:   Number of masks to be created

%   [shape]:   Shape of elements: 1 = square, 2 = circular, 3 = diamond, 4 = squares & circles 5 = diamonds & circles (default: square)

%   [colored]: Color style (1 = grayscale, 2 = BRGBYCMW, 3-15 other schemes

%              (try them out and let me know which work best!)

%

% Output variable:

%   masks:     1 x n_masks cell array, containing the Mondrian masks



% (c) 2009 Martin Hebart

% Please forgive me the (at times) unreadable code, but it's much easier

% this way ;)



function masks = make_mondrian_masks(sz_x,sz_y,n_masks,shape,selection,sz_rect,sizes,progressBar)


sizes = sizes.*sz_rect;



% how many shapes should be drawn?

loop_nr = round(8*(sz_y/sz_x)/mean(sizes.^2)); % if area is filled 8 times, this is normally sufficient



% Select colors in subfunction at bottom of this function

colors = select_colors(selection);



masks = cell(n_masks,1); % init

sizes = ceil(sizes * sz_x); % sizes relative to x-dimension

levels = colors;



mask = 0.5*ones(sz_y+max(sizes),sz_x+max(sizes),3); % background starting value is mid-grey



maskindex = mask;

maskindex(1:numel(mask)) = 1:numel(mask);



sizes_templates = cell(length(sizes),1); % init

switch shape

    case 1 % square shape

        angleV=0;

        for i = 1:length(sizes)

            template = 0*mask;

            square = ones(sizes(i),sizes(i),3);

            template(1:size(square,2),1:size(square,1),:) = square;

            sizes_templates{i} = find(template)-1;

        end

    case 2 % circle shape

        angleV=0;

        for i = 1:length(sizes)

            template = 0*mask;

            [cx,cy] = meshgrid(linspace(-sizes(i)/2+0.5,sizes(i)/2-0.5,sizes(i)));

            cz = sqrt(cx.^2+cy.^2);      % factors here!

            circle = cz<sizes(i)/2;

            template(1:sizes(i),1:sizes(i),:) = repmat(circle,[1 1 3]);

            sizes_templates{i} = find(template)-1;

        end

    case 3 % diamond shape

        angleV=[0 7 14 21 28 35 42 49 56 63 70 77 84];

        for iAngle = 1:length(angleV)

            for i = 1:length(sizes)

                template = 0*mask;

                square = ones(sizes(i),sizes(i));

                squarerot = imrotate(square,angleV(iAngle));

                template(1:size(squarerot,2),1:size(squarerot,1),:) = repmat(squarerot,[1 1 3]);

                sizes_templates{i,iAngle} = find(template)-1;

            end

        end

    case 4 % squares & circlres

        angleV=0;

        for i = 1:length(sizes)

            template = 0*mask;

            if rand>0.25

                square = ones(sizes(i),sizes(i),3);

                template(1:size(square,2),1:size(square,1),:) = square;

            else

                [cx,cy] = meshgrid(linspace(-sizes(i)/2+0.5,sizes(i)/2-0.5,sizes(i)));

                cz = sqrt(cx.^2+cy.^2);      % factors here!

                circle = cz<sizes(i)/2;

                template(1:sizes(i),1:sizes(i),:) = repmat(circle,[1 1 3]);

            end

            sizes_templates{i} = find(template)-1;

        end

    case 5 % squares & circlres

        angleV=[0 7 14 21 28 35 42 49 56 63 70 77 84];

        for iAngle = 1:length(angleV)

            for i = 1:length(sizes)

                template = 0*mask;

                if rand>0.25

                    square = ones(sizes(i),sizes(i));

                    squarerot = imrotate(square,angleV(iAngle));

                    template(1:size(squarerot,2),1:size(squarerot,1),:) = repmat(squarerot,[1 1 3]);

                else

                    [cx,cy] = meshgrid(linspace(-sizes(i)/2+0.5,sizes(i)/2-0.5,sizes(i)));

                    cz = sqrt(cx.^2+cy.^2);      % factors here!

                    circle = cz<sizes(i)/2;

                    template(1:sizes(i),1:sizes(i),:) = repmat(circle,[1 1 3]);

                end

                sizes_templates{i,iAngle} = find(template)-1;

            end

        end

end



excluded = maskindex(:,end-max(sizes)+1:end,1); % in the bottom additional area no shape may be started, otherwise error

if ismember( shape , [3 5] ) % for diamond special case

    excluded = maskindex(:,end-round(1.5*max(sizes))+1:end,1);

end

maskindex = maskindex(:,:,1);

maskindex = setdiff(maskindex(:),excluded(:));

progressBar.drawProgressBar(0);
for i_mask = 1:n_masks

    curr_maskindex = maskindex(ceil(length(maskindex)*rand(loop_nr,1))); % randomize maskindex for later starting position



    for i = 1:loop_nr

        cangle = ceil(length(angleV)*rand);

        csize = ceil(length(sizes)*rand); % current size, randomly defined



        randpos = curr_maskindex(i); % random starting position

        currindex = sizes_templates{csize,cangle}(:)+randpos;

        tmp = ones(length(currindex)/3,1)'; % vector of ones

        currlevel = levels(ceil(rand*size(levels,1)),:);



        mask(currindex) = [currlevel(1)*tmp currlevel(2)*tmp currlevel(3)*tmp]; % fill shape in mask



    end

    masks{i_mask} = mask((1:sz_y) +ceil(max(sizes)/2),(1:sz_x) +ceil(max(sizes)/2),:); % crop mask
    progressBar.addProgress(1/n_masks);
end



if nargout == 0

   

    h = figure;

    

    for i_mask = 1:n_masks

        

        imshow(masks{i_mask})

        pause(0.09)

        

    end    

    

    pause(0.5)

    close(h)

end

    



function colors = select_colors(selection)



switch selection

    

    case 1  % original colors for breaking, too

        colors = [0 0 0;...

            1 0 0;...

            0 1 0;...

            0 0 1;...

            1 1 0;...

            1 0 1;...

            0 1 1;...

            1 1 1];

        

    case 2  % grayscale

        colors = [0 0 0;...

            0.3 0.3 0.3;...

            0.5 0.5 0.5;...

            0.7 0.7 0.7;...

            1 1 1];

        

    case 3 % all relevant colors (works quite well):

        colors = [1 0 0;...   % red

            0.5 0 0;...       % dark red

            0 1 0;...         % green

            0 0.5 0;...       % dark green

            0 0 1;...         % blue

            0 0 0.5;...       % dark blue

            0.1 0.6 1;...     % light blue

            1 1 0;...         % yellow

            0.5 0.5 0;...     % dark yellow

            1 0 1;...         % magenta

            0 1 1;...         % cyan

            0 0.5 0.5;...     % dark cyan

            1 1 1;...         % white

            0 0 0;...         % black

            0.5 0.5 0.5;...   % gray

            0.3 0.1 0.5;...   % dark purple

            1 0.7 0];         % orange

        

    case 4 % works quite well

        colors = [

            1 0 0;...           % red

            0.5 0 0;...         % dark red

            0 0 1;...           % blue

            0 0 0.5;...         % dark blue

            0.1 0.6 1;...       % light blue

            1 0 1;...           % magenta

            0 0.5 0.5;...       % dark cyan

            0 0 0;...           % black

            0.3 0.1 0.5;...     % dark purple

            1 0.7 0;...         % orange

            ];

        

    case 5 % purples: works quite well

        colors = [0.4 0 0.8;...

            0.4 0.2 0.6;...

            0.2 0 0.5;...

            0.6 0.3 0.9;...

            0.7 0.5 0.9];

        

    case 6 % reds: works quite well

        colors = [0.5 0 0;...

            1.0 0.1 0.6;...

            0.5 0 0.3;...

            0.8 0.4 0.6;...

            0.5 0.2 0.4;...

            0.5 0.2 0.2;...

            0.8 0.1 0.5;...

            1.0 0.3 0;...

            0.5 0.1 0;...

            0.8 0.1 0.6;...

            0.5 0.1 0.3;...

            0.7 0.1 0.1;...

            0.5 0.1 0.1;...

            1.0 0 0;...

            0.5 0 0;...

            0.5 0.2 0.1];

        

    case 7 % blues: works quite well

        colors = [0.5 0.2 0.9;...

            0.4 0.6 0.6;...

            0.4 0.6 0.9;...

            0 0 0.5;...

            0 0.5 0.5;...

            0.3 0.2 0.5;...

            0 0.7 1.0;...

            0 0.6 0.8;...

            0 0.4 0.5;...

            0.1 0.3 0.5;...

            0.5 0.4 1.0;...

            0.4 0.8 0.7;...

            0 0 0.8;...

            0.5 0.4 0.9;...

            0.1 0.1 0.4;...

            0 0 0.5;...

            0.2 0.3 0.5;...

            0.4 0.4 0.8;...

            0.3 0.2 0.5;...

            0 0 1.0;...

            0 0.5 0.5];

        

    case 8 % Professional 1

        colors = [0 0 0.4;...

            1.0 1.0 1.0;...

            0.8 0.8 0.8;...

            0 0 0.8;...

            0.6 0.4 0;...

            0.4 0 0;...

            0.2 0 0];

        

    case 9 % Professional 2 (I like it)

        colors = [0 0.2 0.2;...

            0 0.4 0.4;...

            1.0 1.0 1.0;...

            0.4 0 0.2;...

            0.4 0.6 0.6;...

            0.4 0.2 0.2;...

            0 0 0];

        

    case 10 % Appetizing: tasty

        colors = [0.6 0 0;...

            1.0 0.8 0.6;...

            0.8 0.4 0.2;...

            0.4 0 0;...

            0 0.4 0.2;...

            0.8 0.2 0];

        

    case 11 % Electric (adjusted)

        colors = [0 1.0 0;...

            1.0 0 0.6;...

            0.8 1.0 0;...

            0 0 0;...

            1.0 0.7 0.2;...

            1.0 1.0 1.0];

        

    case 12 % Dependable 1

        colors = [0 0.2 0.2;...

            1.0 1.0 1.0;...

            0 0.4 0.2;...

            0.6 0.6 0.6;...

            0.2 0 0];

        

    case 13 % Dependable 2

        colors = [0.4 0.2 0.2;...

            0.4 0.4 0.4;...

            0 0 0.4;...

            0.2 0 0;...

            0.8 0.8 0.8;...

            0 0 0.6];

        

    case 14 % Earthy Ecological Natural

        colors = [0 0.4 0.2;...

            1.0 1.0 0.8;...

            0.4 0.2 0;...

            0.8 0.8 0.4;...

            0.6 0.4 0;...

            0 0.8 0.2;...

            0.4 0.6 0.2;...

            0 0 0];

        

    case 15  % Feminine

        colors = [0.8 0.6 0.2;...

            0.4 0 0.6;...

            0.8 0 0.6;...

            0 0.8 0.8;...

            0.6 0 0.4;...

            1.0 1.0 1.0;...

            0 0 0];

        

    case 16 % adapted from case 4

        colors = [

            1 0 0;...           % red

            0.5 0 0;...         % dark red

            0 0 1;...           % blue

            0 0 0.5;...         % dark blue

            0.1 0.6 1;...       % light blue

            1 0 1;...           % magenta

            0 0.5 0.5;...       % dark cyan

            0 0 0;...           % black

            0.3 0.1 0.5;...     % dark purple

            1 0.7 0;...         % orange

            1 1 1;...           % white

            0 1 0;...           % green

            ];

        

end