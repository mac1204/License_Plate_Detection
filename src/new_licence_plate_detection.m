clc
clear all
input_img=imread('d13.jpg');
% figure,imshow(uint8(input_img))
[X Y Z]=size(input_img);
% input_gray = zeros(X,Y,1);
input_gray = rgb2gray(input_img);
% figure,imshow(uint8(input_gray))
mrows = X/(X/270);
ncolumns = Y/(Y/360);
input_resize_image = imresize(input_gray,[mrows ncolumns]);
% figure,imshow(uint8(input_resize_image))
[X Y Z] = size(input_resize_image);
% img_noiseRemoval = medfilt2(input_resize_image);
% figure,imshow(uint8(img_noiseRemoval))
img_Enhancement = histeq(input_resize_image);
% figure,imtool(uint8(img_Enhancement))
% level = graythresh(img_Enhancement)
level = 0.38
img_thresholding = im2bw(img_Enhancement,level);
figure,imshow((img_thresholding))
% xx = 0:255;
% figure,hist(img_noiseRemoval,xx)
% figure,hist(img_Enhancement,xx)
% % H = fspecial('roberts');
% % img_edge = imfilter(img_Enhancement,H);
img_edge = edge(img_thresholding,'canny');
% figure,imshow((img_edge))
se = strel('rectangle',[1 10]);
img_dilate = imdilate(img_edge,se);
% figure,imshow((img_dilate))
img_erode = imerode(img_dilate,se);
% figure,imshow((img_erode))
% img_dilate = imdilate(img_erode,se);
% figure,imshow((img_dilate))
img_fill1 = imfill(img_erode,'holes');
% figure,imshow((img_fill1))
img_sum = img_fill1 + img_erode + img_dilate;
figure,imshow((img_sum))
img_sum = img_sum./3;
img_thresholding2 = im2bw(img_sum,0.7);
% figure,imshow((img_thresholding2))
img_edge_canny = edge(img_thresholding,'canny');
% figure,imshow((img_edge_canny))
img_ans = img_thresholding2 - img_edge_canny;
% figure,imshow((img_ans))
se = strel('rectangle',[1 1]);
img_erode3 = imerode(img_ans,se);
% figure,imshow((img_erode3))
img_dilate3 = imdilate(img_erode3,se);
% figure,imshow((img_dilate3))
se = strel('rectangle',[2 1]);
img_erode4 = imerode(img_dilate3,se);
% figure,imshow((img_erode4))
se = strel('square',5);
img_dilate4 = imdilate(img_erode4,se);
% figure,imshow((img_dilate4))
se = strel('line',20,0);
img_dilate5 = imdilate(img_dilate4,se);
% figure,imshow((img_dilate5))
[Ilabel num] = bwlabel(img_dilate5);
disp(num);
figure,imtool((Ilabel));
Iprops = regionprops(Ilabel);
count = 0;
for cnt = 1:num
%     disp(cnt)
%     disp(Iprops(cnt,1).BoundingBox(1,2))
%     disp(X/2)
%     disp(Iprops(cnt,1).BoundingBox(1,1))
%     disp(Y/3)
%     disp(Iprops(cnt,1).BoundingBox(1,3))
%     disp(100)
%     disp(Iprops(cnt,1).BoundingBox(1,4))
%     disp(20)
    if ((Iprops(cnt,1).BoundingBox(1,2)>(X/2)) && (Iprops(cnt,1).BoundingBox(1,1)>(Y/4)) && ((Iprops(cnt,1).BoundingBox(1,1)+ Iprops(cnt,1).BoundingBox(1,3))<((3*Y)/4)) && (Iprops(cnt,1).BoundingBox(1,3)>100) && (Iprops(cnt,1).BoundingBox(1,4)>15) && (Iprops(cnt,1).BoundingBox(1,3)<150) && (Iprops(cnt,1).BoundingBox(1,3)>35))
        count = count +1;
        ans = Iprops(cnt,1).BoundingBox;
        disp(ans);
    end
end
 disp(count);
 ans_img = imcrop(input_resize_image,ans);
 figure,imshow(uint8(ans_img))


% % % % ------------------------------------------------------------------------- out of code ---------------------------------------------------------% % % % %
% % % % % % % % % disp(count);
% % % % % % % % % Ibox = [Iprops.BoundingBox];
% % % % % % % % % Ibox = reshape(Ibox,[4 num]);
% % % % % % % % % figure,imshow(img_dilate5);
% % % % % % % % % hold on; 
% % % % % % % % % for cnt = 1:num 
% % % % % % % % %     rectangle('position',Ibox(:,cnt),'edgecolor','r');
% % % % % % % % % end
% figure,imshow((img_fill1))
% img_erode2 = imerode(img_erode,se);
% figure,imshow((img_erode2))
% img_dilate2 = imdilate(img_erode2,se);
% figure,imshow((img_dilate2))
% img_fill2 = imfill(img_dilate2,'holes');
% figure,imshow((img_fill2))
% ans = img_fill2 & img_fill1;
% figure,imshow((ans))
% % % % % % % % % % img_edge_canny = edge(img_thresholding,'roberts');
% % % % % % % % % % figure,imshow((img_edge_canny))
% % % % % % % % % % se = strel('disk',1);
% % % % % % % % % % img_dilate3 = imdilate(img_edge_canny,se);
% % % % % % % % % % figure,imshow((img_dilate3))
% % % % % % % % % % img_ans = img_fill1 - img_dilate3;
% % % % % % % % % % figure,imtool((img_ans))

% % % % ------------------------------------------------------------------------- end comment ---------------------------------------------------------% % % % %