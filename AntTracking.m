clc; clear;
xCords = zeros(1,448);
yCords = zeros(1,448);
for index = 1:448
    if index <10
        jpgFileName = sprintf('img00%d.jpg',index);
        fullFileName = fullfile('ant',jpgFileName);
    elseif index < 100
        jpgFileName = sprintf('img0%d.jpg',index);
        fullFileName = fullfile('ant',jpgFileName);
    else
        jpgFileName = sprintf('img%d.jpg',index);
        fullFileName = fullfile('ant',jpgFileName);
    end
    if exist (fullFileName,'file')
        if index > 1
            prevImage = currentImage;
            currentImage = imread(fullFileName);
            currentImageHSV = rgb2hsv(currentImage);
            currentImageBright = currentImage(:,:,3);
            prevImageHSV = rgb2hsv(prevImage);
            prevImageBright = prevImage(:,:,3);
            
            diff = abs(currentImageBright - prevImageBright);
            iThresh = diff > 18;

            [labels,number] = bwlabel(iThresh,8);
            if number > 0
            iStats = regionprops(labels, 'basic','Centroid');
            [maxVal,maxIndex] = max([iStats.Area]);
           
                xCords(1,index) = iStats(maxIndex).Centroid(1);
                yCords(1,index) = iStats(maxIndex).Centroid(2);
                hold off;
                imshow(iThresh);
                hold on;
                rectangle('Position', [iStats(maxIndex).BoundingBox],'LineWidth',2,'EdgeColor','g');

                hold on;
                plot(iStats(maxIndex).Centroid(1),iStats(maxIndex).Centroid(2),'r*');
                text(iStats(maxIndex).Centroid(1)+10,iStats(maxIndex).Centroid(2)+10,'Object','fontsize',20,'color','r','fontweight','bold');
            end 
        else
            currentImage = imread(fullFileName);
        end
    else
        warningMessage = sprintf('Warning: image file does not exist:\n%s',fullFileName);
        uiwait(warndlg(warningMessage));
    end
   % imshow(imageData);
end
figure;
imshow(currentImage);
xCords = xCords(xCords~=0);
yCords = yCords(yCords~=0);
    hold on;
   plot(xCords(1,:),yCords(1,:));
 
