function [ ans_img ] = new_licence_plate_detection( image_name )
% Reading the Image
input_img=imread(image_name);
[X Y Z]=size(input_img);

%Convert the image to grayscale
input_gray = rgb2gray(input_img);

%Resize the image to 270 *  360
mrows = X/(X/270);
ncolumns = Y/(Y/360);
input_resize_image = imresize(input_gray,[mrows ncolumns]);
[X Y Z] = size(input_resize_image);

%Imgae Enhancing bu histogram equilization
img_Enhancement = histeq(input_resize_image);

%Image converted to black and white
level = 0.38;
img_thresholding = im2bw(img_Enhancement,level);

% Retrive the edges of image
img_edge = edge(img_thresholding,'canny');

% Enhance the edges
se = strel('rectangle',[1 10]);
img_dilate = imdilate(img_edge,se);
img_erode = imerode(img_dilate,se);

% Fills the whole of image
img_fill1 = imfill(img_erode,'holes');


img_sum = img_fill1 + img_erode + img_dilate;
figure,imshow((img_sum))
img_sum = img_sum./3;
img_thresholding2 = im2bw(img_sum,0.7);


img_edge_canny = edge(img_thresholding,'canny');


img_ans = img_thresholding2 - img_edge_canny;

se = strel('rectangle',[1 1]);
img_erode3 = imerode(img_ans,se);
img_dilate3 = imdilate(img_erode3,se);

se = strel('rectangle',[2 1]);
img_erode4 = imerode(img_dilate3,se);

se = strel('square',5);
img_dilate4 = imdilate(img_erode4,se);

se = strel('line',20,0);
img_dilate5 = imdilate(img_dilate4,se);

[Ilabel num] = bwlabel(img_dilate5);
disp(num);
figure,imtool((Ilabel));
Iprops = regionprops(Ilabel);
count = 0;
for cnt = 1:num
    if ((Iprops(cnt,1).BoundingBox(1,2)>(X/2)) && (Iprops(cnt,1).BoundingBox(1,1)>(Y/4)) && ((Iprops(cnt,1).BoundingBox(1,1)+ Iprops(cnt,1).BoundingBox(1,3))<((3*Y)/4)) && (Iprops(cnt,1).BoundingBox(1,3)>100) && (Iprops(cnt,1).BoundingBox(1,4)>15) && (Iprops(cnt,1).BoundingBox(1,3)<150) && (Iprops(cnt,1).BoundingBox(1,3)>35))
        count = count +1;
        ans = Iprops(cnt,1).BoundingBox;
        disp(ans);
    end
end
 disp(count);
 ans_img = imcrop(input_resize_image,ans);
end