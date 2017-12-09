%Adds noise to a video file
videoFolder = 'C:/Users/bschneider/Documents/School/Thesis/Hexoskin/pivotheadVids/120601/';
videoName = 'VID_0011';
videoExt = '.mp4';

reader = VideoReader(strcat(videoFolder, videoName, videoExt));

for mult=1:5
    %creat a Gaussian filter up front
    blurFilt = fspecial('gaussian', [10*mult, 10*mult], 20*mult);
    
    writer = VideoWriter(strcat(videoFolder, videoName, '_gaussBlur_', num2str(mult)), 'MPEG-4');
    writer.Quality = 100;
    open(writer);

    %reset the video reader to the beginning
    reader.currentTime = 0;
    i = 0;
    while (hasFrame(reader) & i < 485)
       frame = readFrame(reader); 
       i = i + 1
    end

    while (hasFrame(reader) & i <= 1160)
       frame = readFrame(reader);
       % ATTEMPT 1: add noise with greater variance - didn't quite increase
       % noise as desired
       %frame  = imnoise(frame,'gaussian', 0, mult*0.1);
       
       %ATTEMPT 2: add noise x times
       %for j = 1:mult
       %   frame  = imnoise(frame,'salt & pepper', 0.1);
       %end
       frame = imfilter(frame, blurFilt);
       
       writeVideo(writer, frame);
       i = i + 1
    end
    close(writer);
    
end
