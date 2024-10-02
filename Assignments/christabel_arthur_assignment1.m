%% Load images
fdir = '/Users/christabelarthur/Documents/MATLAB/PSY 627/fLoc_stimuli';

%% 1. Create a sorted list of all images in that folder.
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
disp(sortedList);

%% 2. Select a random sample of 12 images.
numImages = length(sortedList);
randomIndices = randperm(numImages, 12);
randomSampleImages = sortedList(randomIndices);
disp(randomSampleImages);

%% 3. Display each of the 12 randomly chosen images sequentially in the same figure.
figure;
for i = 1:12
    image = imread(fullfile(fdir, randomSampleImages{i}));
    imshow(image);
    waitforbuttonpress %can comment this line out or not
end

%% 4. Concatenate the images into an array and save them as one big array in an appropriate file called 'randomly_selected_images'.
imageArray = cell(1, numImages);
for i = 1:12
    image = imread(fullfile(fdir, randomSampleImages{i}));
    imageArray{i} = image;
end
concatenatedImages = cat(ndims(imageArray{1}) + 1, imageArray{:});
save('randomly_selected_images.mat', 'concatenatedImages');

%% 5. Make a figure with subplots to display each of the 12 images in a 4 x 3 'light table" grid. 
figure;
for i = 1:12
    image = imread(fullfile(fdir, randomSampleImages{i}));
    subplot(3, 4, i);
     imshow(image);
end
