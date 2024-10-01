% Load images
fdir = '/Users/christabelarthur/Documents/MATLAB/PSY 627/fLoc_stimuli';

%% Create a sorted list of all images in that folder.
imageFiles = dir(fullfile(fdir, '*.*'));
imageList = {};
imageExtensions = {'.jpg'};
for i = 1:length(imageFiles)
    [~, ~, ext] = fileparts(imageFiles(i).name);
    if ismember(lower(ext), imageExtensions)     
        imageList{end+1} = imageFiles(i).name;  
    end
end
sortedList = sort(imageList);

%% Select a sample of images based on name of file
filteredImages = {};
for i = 1:length(sortedList)
    if contains(sortedList{i}, 'adult')
        filteredImages{end+1} = sortedList{i};
    elseif contains(sortedList{i}, 'child')
         filteredImages{end+1} = sortedList{i};
    end
end

filteredImages2 = {};
for i = 1:length(sortedList)
    if contains(sortedList{i}, 'house')
        filteredImages2{end+1} = sortedList{i};
    elseif contains(sortedList{i}, 'corridor')
         filteredImages2{end+1} = sortedList{i};
    end
end

filteredImages3 = {};
for i = 1:length(sortedList)
    if contains(sortedList{i}, 'instrument')
        filteredImages3{end+1} = sortedList{i};
    elseif contains(sortedList{i}, 'car')
         filteredImages3{end+1} = sortedList{i};
    end
end

allFilteredImages = {filteredImages, filteredImages2, filteredImages3};

%% set up screen
screenColor = [128, 128, 128]; 
screenSize = [400, 400];       
screenUpperLeft = [200, 200]; 
screenRect = [screenUpperLeft, screenUpperLeft + screenSize]; 
screens = Screen('Screens');
screenNumber = max(screens); 
Screen('Preference', 'SkipSyncTests', 1); 
[w, windowRect] = Screen('OpenWindow', screenNumber, screenColor, screenRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', w); 

%% Define the image block size and screen position
imageWidth = screenXpixels * 0.4;   % 40% of the screen width
imageHeight = screenYpixels * 0.4; 

leftRect = [screenXpixels * 0.1, (screenYpixels - imageHeight)/2, ...
            screenXpixels * 0.1 + imageWidth, (screenYpixels + imageHeight)/2];  % Position on the left
rightRect = [screenXpixels * 0.6, (screenYpixels - imageHeight)/2, ...
             screenXpixels * 0.6 + imageWidth, (screenYpixels + imageHeight)/2];  % Position on the right

%% Define variables
nImages = length(sortedList); % Total number of images
nBlocks = 6; % Total number of blocks (3 left, 3 right)
imagesPerBlock = floor(nImages / nBlocks); % How many images per block
nPresentations = imagesPerBlock; % How many images per block presentation

%% Set timing parameters
imageDuration = 1;
gapDuration = 0.25;
blockDuration = 20;
blockGap = 3; 

%% Run experiment by selecting a random sample of images per each block
for block = 1:3
        blockStart = GetSecs();  
        currentImages = allFilteredImages{block};  
        randOrder = randperm(length(currentImages));  
        randomizedImages = currentImages(randOrder);
        
        % Display images for the block within 20 seconds
        for imgIdx = 1:length(randomizedImages)
            elapsedTime = GetSecs() - blockStart;
            if elapsedTime >= blockDuration
                break;  
            end

            % Load the image and resize it to fit within the smaller block size
            imgPath = fullfile(fdir, randomizedImages{imgIdx});
            imgData = imread(imgPath);
            imgData = imresize(imgData, [imageHeight, imageWidth]); 
            
            % Create texture and display the image on the left
            imgTexture = Screen('MakeTexture', w, imgData);
            Screen('DrawTexture', w, imgTexture, [], leftRect);
            Screen('Flip', w);
           
            WaitSecs(min(imageDuration, blockDuration - elapsedTime));

            % Clear screen for the gap
            Screen('FillRect', w, screenColor);
            Screen('Flip', w);
            WaitSecs(min(gapDuration, blockDuration - elapsedTime - imageDuration));
        end

        % Ensure exactly 20 seconds for the block
        while GetSecs() - blockStart < blockDuration
            WaitSecs(0.01);
        end

        % Wait 3 seconds between blocks
        Screen('FillRect', w, screenColor);
        Screen('Flip', w);
        WaitSecs(blockGap);
    end
    
    % Next 3 blocks on the right
    for block = 1:3
        blockStart = GetSecs(); 
        currentImages = allFilteredImages{block}; 
        randOrder = randperm(length(currentImages));
        randomizedImages = currentImages(randOrder);
        
        % Display images for the block within 20 seconds
        for imgIdx = 1:length(randomizedImages)
            elapsedTime = GetSecs() - blockStart;
            if elapsedTime >= blockDuration
                break; 
            end

            % Load the image and resize it to fit within the smaller block size
            imgPath = fullfile(fdir, randomizedImages{imgIdx});
            imgData = imread(imgPath);
            imgData = imresize(imgData, [imageHeight, imageWidth]);
            
            % Create texture and display the image on the right
            imgTexture = Screen('MakeTexture', w, imgData);
            Screen('DrawTexture', w, imgTexture, [], rightRect);
            Screen('Flip', w);
       
            WaitSecs(min(imageDuration, blockDuration - elapsedTime));

            % Clear screen for the gap
            Screen('FillRect', w, screenColor);
            Screen('Flip', w);
            WaitSecs(min(gapDuration, blockDuration - elapsedTime - imageDuration));
        end

        % Ensure exactly 20 seconds for the block
        while GetSecs() - blockStart < blockDuration
            WaitSecs(0.01);
        end

        % Wait 3 seconds between blocks
        Screen('FillRect', w, screenColor);
        Screen('Flip', w);
        WaitSecs(blockGap);
    end

    sca;