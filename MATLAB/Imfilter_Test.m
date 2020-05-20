I = imread('1.jpg');
%imshow(I);
G = rgb2gray(I);
imshow(G);
h = [-1,2,-1];
C = imfilter(G,h);
%C = uint8(C);
C=C+0.5;
imshow(C);  
