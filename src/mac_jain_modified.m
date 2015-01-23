clc
clear all
input_img=imread('d13.jpg');
% figure,imtool(uint8(input_ig));
% [X_axis,Y_axis,Z_axis]=size(input_ig);
% input_img=zeros(X_axis/4,Y_axis/4,Z_axis);
% for i=1:4:X_axis-4
%     for j=1:4:Y_axis-4
%         for k=1:Z_axis
%             input_img(round(1+i/4),round(1+j/4),k)=round((input_ig(i,j,k)/16+input_ig(i,j+1,k)/16+input_ig(i,j+2,k)/16+input_ig(i,j+3,k)/16+input_ig(i+1,j+1,k)/16+input_ig(i+1,j+2,k)/16+input_ig(i+1,j+3,k)/16+input_ig(i+2,j+1,k)/16+input_ig(i+2,j+2,k)/16+input_ig(i+2,j+3,k)/16+input_ig(i+1,j,k)/16+input_ig(i+2,j,k)/16+input_ig(i+3,j,k)/16+input_ig(i+3,j+1,k)/16+input_ig(i+3,j+2,k)/16+input_ig(i+3,j+3,k)/16));
%         end
%     end
% end
figure,imshow(uint8(input_img))
[X Y Z]=size(input_img);
a=zeros(X,Y,1);
for i=1:X
    for j=1:Y 
        a(i,j,1)=round(input_img(i,j,1)/3+input_img(i,j,2)/3+input_img(i,j,3)/3);
    end
end
figure,imshow(uint8(a))
[x y z]=size(a);
b=[-1 -1 0 1 1;-1 -1 0 1 1;-1 -1 0 1 1;-1 -1 0 1 1;-1 -1 0 1 1];
ba=[1 1 0 -1 -1;1 1 0 -1 -1;1 1 0 -1 -1;1 1 0 -1 -1;1 1 0 -1 -1];
bm=[-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;0 0 0 0 0;1 1 1 1 1;1 1 1 1 1];
bn=[-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;0 0 0 0 0;1 1 1 1 1;1 1 1 1 1];
[p q r]=size(b);
c=zeros(x+4,y+4,z);
d=zeros(x,y,z);
da=zeros(x,y,z);
dc=zeros(x,y,z);
db=zeros(x,y,z);
for k=1:z
    for i=3:x+2
        for j=3:y+2
            c(i,j,k)=a(i-2,j-2,k);
        end
    end
end
for i=3:x+2
    for j=3:y+2
        for l=1:p
            for m=1:q
                for k=1:z    
                    d(i-2,j-2,k)=d(i-2,j-2,k)+(b(l,m)*c(i+l-3,j+m-3,k));
                    da(i-2,j-2,k)=da(i-2,j-2,k)+(ba(l,m)*c(i+l-3,j+m-3,k));
                    dc(i-2,j-2,k)=dc(i-2,j-2,k)+(bm(l,m)*c(i+l-3,j+m-3,k));
                    db(i-2,j-2,k)=db(i-2,j-2,k)+(bn(l,m)*c(i+l-3,j+m-3,k));
                end
            end
        end
    end
end
ma=255-d;
mn=255-dc;
mm=255-db;
% figure,imshow(ma)
% figure,imshow(mn)
% figure,imshow(mm)
bk=255-zeros(x,y,1);
bl=255-zeros(x,y,1);

for i=2:x-1
    for j=1:y
        if (mn(i-1,j) < mn(i,j)) && (mn(i-1,j) <= mn(i+1,j))
            bk(i,j)=mn(i-1,j);
        end
        if mn(i+1,j) < mn(i,j) && (mn(i-1,j) > mn(i+1,j))
            bk(i,j)=mn(i+1,j);
        end
        if mn(i+1,j) > mn(i,j) && (mn(i-1,j) > mn(i,j))
            bk(i,j)=mn(i,j);
        end
    end
end

% figure,imshow(bk)

for i=2:x-1
    for j=1:y
        if (bk(i-1,j) <= bk(i,j)) && (bk(i-1,j) <= bk(i+1,j))
            bl(i,j)=bk(i-1,j);
        end
        if bk(i+1,j) <= bk(i,j) && (bk(i-1,j) >= bk(i+1,j))
            bl(i,j)=bk(i+1,j);
        end
        if bk(i+1,j) >= bk(i,j) && (bk(i-1,j) >= bk(i,j))
            bl(i,j)=bk(i,j);
        end
    end
end

% figure,imshow(bl)
la=255-da;
% figure,imshow(la)
ka(:,:,:)=la(:,:,:);
for i=1:x
    for j=1:y
        for k=1:z
        if ka(i,j,k)<1 || ma(i,j,k)<1 || mn(i,j,k)<1 ||mm(i,j,k)<1
        ka(i,j,k)=0;
        else
            ka(i,j,k)=255;
        end
        end
    end
end
% figure,imshow(uint8(ka))
ct=0;
l1=0;
ct1=0;
l2=0;
max=0;
for i1=3:x-10
    for j1=3:y-20
        for k1=1:z
            while ma(i1+l1,j1,k1)<(-500)
                ct=ct+1;
                l1=l1+1;
            end
                if ct > 10
                   ct;
                    while bl(i1,j1+l2,k1)<(0)
                        ct1=ct1+1;
                        l2=l2+1;
                        l2;
                    end
                        if ct1 > 50
                            I=i1;
                            J=j1;
                            I1=I+ct;
                            J1=J+ct1;
                        end
                        ct1=0;
                        l2=0;
                end
                ct=0;
                l1=0;
        end
    end
end
MA=(I1-I)+1;
NA=(J1-J)+1;
bart=zeros(MA+5,NA+5,Z);
for i=1:MA+5
    for j=1:NA+5
        for k=1:Z
            bart(i,j,k)=input_img(I+i-2,J+j-2,k);
        end
    end
end
figure,imshow(uint8(bart));