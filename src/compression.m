clc
clear all
input_ig=imread('d6.jpg');
figure,imtool(uint8(input_ig));
[X_axis,Y_axis,Z_axis]=size(input_ig);
input_img=zeros(X_axis/4,Y_axis/4,Z_axis);
for i=1:4:X_axis-4
    for j=1:4:Y_axis-4
        for k=1:Z_axis
            input_img(round(1+i/4),round(1+j/4),k)=round((input_ig(i,j,k)/16+input_ig(i,j+1,k)/16+input_ig(i,j+2,k)/16+input_ig(i,j+3,k)/16+input_ig(i+1,j+1,k)/16+input_ig(i+1,j+2,k)/16+input_ig(i+1,j+3,k)/16+input_ig(i+2,j+1,k)/16+input_ig(i+2,j+2,k)/16+input_ig(i+2,j+3,k)/16+input_ig(i+1,j,k)/16+input_ig(i+2,j,k)/16+input_ig(i+3,j,k)/16+input_ig(i+3,j+1,k)/16+input_ig(i+3,j+2,k)/16+input_ig(i+3,j+3,k)/16));
        end
    end
end
figure,imtool(uint8(input_img))