% Initialize video reader and writer objects
vid = VideoReader("RoadTraffic.mp4");
vidWr = VideoWriter("RoadTrafficFiltered","MPEG-4");
vidWr.FrameRate = vid.FrameRate;
open(vidWr);

% Process each frame to remove noise and convert to grayscale
while hasFrame(vid)
    % Read a frame
    frame = readFrame(vid);
    
    % Remove noise using a 2D median filter
    frame(:,:,1) = medfilt2(frame(:,:,1));
    frame(:,:,2) = medfilt2(frame(:,:,2));
    frame(:,:,3) = medfilt2(frame(:,:,3));
    
    % Convert to grayscale
    frame = im2gray(frame);
    
    % Write frame to new video
    writeVideo(vidWr,frame);
end
close(vidWr);

% Isolate cars using background subtraction
vid = VideoReader("RoadTrafficFiltered.mp4");
backImg = readFrame(vid);
backImg = im2gray(backImg);
backImg = im2double(backImg);

% Segment cars and calculate region properties
vid = VideoReader("RoadTrafficFiltered.mp4");
NumberRegions = [];
MeanRegionSize = [];
TotalRegionSize = [];

while hasFrame(vid)
    % Read a frame
    frame = readFrame(vid);
    frame = im2gray(frame);
    frame = im2double(frame);
    
    % Perform background subtraction
    subImg = abs(frame - backImg);
    
    % Segment cars from subtraction result
    mask = segmentCars(subImg);
    
    % Filter out small regions
    mask = bwpropfilt(mask,'Area',[4000 inf]);
    
    % Collect region properties
    props = regionprops("table", mask, "Area");
    numReg = height(props);
    meanRegS = mean(props.Area);
    totRegS = sum(props.Area);
    
    % Append results to arrays
    NumberRegions = [NumberRegions; numReg];
    MeanRegionSize = [MeanRegionSize; meanRegS];
    TotalRegionSize = [TotalRegionSize; totRegS];
end

% Convert arrays to a table variable
carData = table(NumberRegions, MeanRegionSize, TotalRegionSize);