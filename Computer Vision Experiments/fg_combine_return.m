function [ samples, images ] = fg_combine_return( F1, F2, who )
%Combine Samples for the sample from different folders
%   
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(F1) || ~isdir(F2) 
  errorMessage = sprintf...
      ('Error: The following folders do not exist:\n%s\n%s',...
      F1,F2);
  uiwait(warndlg(errorMessage));
  return;
end

% Get size of pedestrian sampleType samples
imagesFiles_1 = dir(fullfile(F1, '*.jpg'));
imagesFiles_2 = dir(fullfile(F2, '*.jpg'));
% Get size of back samples in PortlandDogWalking folder
% Sample_in_Folder = return_size(PortlandFolder,sampleType,who);
% Total size of expected back samples
% size = length(imagesFiles) + Sample_in_Folder;
% pre-allocate array size based on info above
% 20736 is not arbitrary, its the number of columns returned when a 200x200
% image is passed into extractHOGFeatures(). The choice of resizing all 
% images to 200x200 is however arbitrary. 

if strcmp(strtrim(who),'dog')
    Files = dir(fullfile(F1, '*.jpg'));
    lFiles = dir(fullfile(F1, '*.labl'));
    
    temp_2 = zeros(length(imagesFiles_1),20736);
    temp_2_img = repmat({'F'},length(imagesFiles_1),1);

    counter2 = 1;
    for j = 1 : length(Files)
      ImagesName = Files(j).name;
      LabelName = lFiles(j).name;

      ImageName = fullfile(F1, ImagesName);
      LabelName = fullfile(F1, LabelName);
      
      bbox_dimension = prasing(LabelName, strtrim(who));
      im = imresize(imcrop(imread(ImageName), bbox_dimension), [200,200]);
      [hog,~] = extractHOGFeatures(im);
      temp_2(counter2,:) = hog;
      temp_2_img(counter2) = {ImageName};
      counter2 = counter2 + 1;
    end

    samples = temp_2;
    images = temp_2_img;
    
else
    Files = dir(fullfile(F1, '*.jpg'));
    lFiles = dir(fullfile(F1, '*.labl'));
    
    temp_2 = zeros(length(imagesFiles_1)+length(imagesFiles_2),20736);
    temp_2_img = repmat({'F'},length(imagesFiles_1)+length(imagesFiles_2),1);
    
    counter = 1;
    for j = 1 : length(Files)
      ImagesName = Files(j).name;
      LabelName = lFiles(j).name;

      ImageName = fullfile(F1, ImagesName);
      LabelName = fullfile(F1, LabelName);
      
      bbox_dimension = prasing(LabelName, strtrim(who));
      im = imresize(imcrop(imread(ImageName), bbox_dimension), [200,200]);
      [hog,~] = extractHOGFeatures(im);
      temp_2(counter,:) = hog;
      temp_2_img(counter) = {ImageName};
      counter = counter + 1;
    end
    
    Files2 = dir(fullfile(F2, '*.jpg'));
    
    for j = 1 : length(Files2)
      ImagesName = Files2(j).name;
      ImageName = fullfile(F2, ImagesName);   
      im = imresize(imread(ImageName), [200,200]);
      [hog,~] = extractHOGFeatures(im);
      temp_2(counter,:) = hog;
      temp_2_img(counter) = {ImageName};
      counter = counter + 1;
    end
    
    samples = temp_2;
    images = temp_2_img;
    
end

