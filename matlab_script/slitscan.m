% Maya Roman, 2025.10.20
% A script that creates slitscan images from videos.

% other notes on use: it can't read .MOV files straight from iPhones, the
% video needs to be saved-as to a different format (.mp4 works via VLC)

clear all
close all

%% initial variables to edit
maxLength = 20; % max width of image, will be compared to length of video
center = false; % boolean if X slice is in center of video or not
direction = 'R'; % define as left (L) or right(R), dictates in which direction columns add to form photo
startDelay = 0; % seconds, time delay to start image later in video
rotate90 = false; % boolean on whether to rotate the video when creating the image - sometimes videos that opened in a media player fine were rotated in matlab

%% select video file
[fileName,pathName,~] ...
    = uigetfile( ...
    {'*.avi;*.mpg;*.wmv;*.asf;*.asx;*.mp4;*.m4v;*.mov;*.ogg','Video Files (*.avi,*.mpg,*.wmv,*.asf,*.asx,*.mp4,*.m4v,*.mov,*.ogg)';
    '*.*',  'All Files (*.*)'}, ...
    'Pick a video file','source\');
movFile        = strcat('source/',fileName);

%% Read video file
imgFile = "images\slitscan_"; % prefix name of saved image, will be saved in script's parent folder
ext = ".png";
videoObj            = VideoReader(movFile);
vidHeight           = videoObj.Height;
vidWidth            = videoObj.Width;
VidSampleRate       = videoObj.FrameRate;
newFrame = startDelay * VidSampleRate;
fprintf("Sample rate = %.f FPS \n", VidSampleRate);
fprintf("Total video duration = %.f seconds \n", videoObj.Duration);

%% preview image to find desired slice
if center == false
    vidFrame = readFrame(videoObj);
    imshow(vidFrame)
    prompt = "Enter desired slice position, for rotated videos enter the Y value: ";
    videoSliceX = input(prompt);
elseif center == true
    videoSliceX = vidWidth / 2; % position slice in center of video
end

if rotate90 == false
    if videoSliceX > vidWidth % edit to compare to vidWidth if image reads in right side up
        fprintf("ERROR! Slice position is greater than width of video! Choose a number less than %.f \n", vidHeight);
    end
    g = zeros(vidHeight,1,3);
elseif rotate90 == true
    if videoSliceX > vidHeight % edit to compare to vidWidth if image reads in sideways
        fprintf("ERROR! Slice position is greater than width of video! Choose a number less than %.f \n", vidHeight);
    end
    g = zeros(vidWidth,1,3);
end

%% set size of display window based on height and length of video
len =  (videoObj.Duration - startDelay) * VidSampleRate;

if len > maxLength
    defineW = maxLength; % if video is long, define length
else
    defineW = len; %if video isnt too long, make as long as the video is
end

fprintf("length of video = %.f frames \n", len);
fprintf("length of image = %.f frames \n", defineW);
fprintf("video width = %.f \n",vidWidth);
fprintf("video height = %.f \n",vidHeight);
i = 1;

while hasFrame(videoObj)
    vidFrame = readFrame(videoObj);
    if rotate90 == false
        switch direction
            case 'L'
                g = [vidFrame(:,videoSliceX,:) g];
            case 'R'
                g = [g vidFrame(:,videoSliceX,:)];
        end
    elseif rotate90 == true
        switch direction
            case 'L'
                g = [pagectranspose(vidFrame(videoSliceX,:,:)) g];
            case 'R'
                g = [g pagectranspose(vidFrame(videoSliceX,:,:))];
        end
    end
    if mod(i, 1000) == 0
        comp = i/defineW*100;
        fprintf("frame %.f / %.f, %.f %% \n",i,defineW,comp)
    end

    i = i+1;
    if i > maxLength
        break;
    end
    clear vidFrame
end

imshow(g)
fileName = strcat(imgFile,string(datetime('now', 'format', 'uuuu.MM.dd_HH.mm.ss')),ext);
imwrite(g,fileName)
fprintf("file saved as %s \n",fileName)
