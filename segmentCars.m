% Segmentation function
function [BW,maskedImage] = segmentCars(X)
    % Threshold image - manual threshold
    BW = X > 0.1;
    
    % Close mask with disk
    radius = 3;
    decomposition = 0;
    se = strel('disk', radius, decomposition);
    BW = imclose(BW, se);
    
    % Fill holes
    BW = imfill(BW, 'holes');
    
    % Open mask with disk
    radius = 5;
    decomposition = 0;
    se = strel('disk', radius, decomposition);
    BW = imopen(BW, se);
    
    % Close mask with rectangle
    dimensions = [1 39];
    se = strel('rectangle', dimensions);
    BW = imclose(BW, se);
    
    % Fill holes
    BW = imfill(BW, 'holes');
    
    % Create masked image.
    maskedImage = X;
    maskedImage(~BW) = 0;
end