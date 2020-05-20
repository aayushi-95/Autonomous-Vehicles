I = imread('1.jpg');
Gray = rgb2gray(I);
imshow(Gray);
BW = edge(Gray, 'canny');
imshow(BW);
[H,theta,rho] = hough(BW);
figure
imshow(imadjust(rescale(H)),[],...
       'XData',theta,...
       'YData',rho,...
       'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal 
hold on     

HP = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = theta(HP(:,2));
y = rho(HP(:,1));
plot(x,y,'s','color','cyan');

lines = houghlines(BW,theta,rho,HP,'FillGap',5,'MinLength',7);

figure, imshow(Gray), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');