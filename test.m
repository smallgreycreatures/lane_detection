close all
clear all

img  = imread('images/mono_0000000270.png');
%img = img(size(img,1)*0.55:size(img,1)*0.85,:);
img = imgaussfilt(img,2);
%img = triangle128;
%img  = imread('download.jpg');img = rgb2gray(img);

%lines = detect_best_lines(img,170,90,75,105);

%for the first image
    %left
         imgL = img(:,1:size(img,2)*0.5);
         lines = line_detect(img, 0.5, 20,70); %detect left line
         draw_line(img, lines, 'red');

    %right
%         imgR = img(:,size(img,2)*0.5:size(img,2));
%         lines = line_detect(img, 0.5, -70, -20);%detect right line
%         draw_line(img, lines, 'green');

%for the second image
%lines = line_detect(img, 0.5, -90,90); %detect left line


%draw_line(img, lines, 'green');
