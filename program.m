% import image
I = imread('image/Fig0222(a)(face).tif');
imshow(I)
histogram = showHistogram(I);
I_bright = makebright(I, 1.2, 200);
I_log = logTransform(I,2);
I_power = powerTransform(I,1,2);
I_coffee = imread('image/Fig0320(2)(2nd_from_top).tif');
I_stretch = contrastStretching(I_coffee,87, 135);
I_equal = histogramEqualization(I_coffee);

% No. 1
function [counts, grayLevels] = showHistogram(grayImage)
[rows, columns, ~] = size(grayImage);
counts = zeros(1, 256);
for col = 1 : columns
	for row = 1 : rows
		% Get the gray level.
		grayLevel = grayImage(row, col);
		% Add 1 because graylevel zero goes into index 1 and so on.
		counts(grayLevel+ 1) = counts(grayLevel+1) + 1;
	end
end

% Plot the histogram.
grayLevels = 0 : 255;
bar(grayLevels, counts, 'BarWidth', 1, 'FaceColor', 'b');
xlabel('Gray Level', 'FontSize', 20);
ylabel('Pixel Count', 'FontSize', 20);
title('Histogram', 'FontSize', 20);
grid on;

end

% No. 2.a - image brightening
function [ s ] = makebright(r, a, b) 
   s = r*a + b; 
   s(s > 255) = 255;
   subplot(1,2,1),imshow(r),title("Original Image")
   subplot(1,2,2),imshow(s),title("Image after Transformation")
end

% No. 2.b - Transformasi log (𝑠 = 𝑐 𝑙𝑜𝑔(1 + 𝑟), 𝑐 dan r konstanta
% parameter input dari pengguna
function [ s ] = logTransform(r, c) 
   r_double = double(r)/255;
   s = c*log(1+(r_double)); 
   subplot(1,2,1),imshow(r),title("Original Image")
   subplot(1,2,2),imshow(s),title("Image after Log Transformation")
end

% No. 2.c - Transformasi pangkat (𝑠 = 𝑐𝑟^y, 𝑐 dan 𝛾 adalah parameter input dari pengguna)
function [ s ] = powerTransform(r, c,y) 
    s = c*power(double(r)/255,double(y));
   subplot(1,2,1),imshow(r),title("Original Image")
   subplot(1,2,2),imshow(s),title("Image after Power Transformation")
end

% No. 2.d - Contrast Stretching
function [ s ] = contrastStretching(r, rmin, rmax) 
   s = (r - rmin).*(255/(rmax - rmin)); 
   subplot(1,2,1),imshow(r),title("Original Image")
   subplot(1,2,2),imshow(s),title("Image after Power Transformation")
end

% No. 3 Histogram Equalization

function [ result_image ] = histogramEqualization(input_image) 
    
    [rows,columns,~] = size(input_image);
    result_image = uint8(zeros(rows,columns));
    pixel_number = rows*columns;
    frequency = zeros(256,1);
    pdf = zeros(256,1);
    cdf = zeros(256,1);
    cummulative = zeros(256,1);
    outpic = zeros(256,1);
    for i = 1:1:rows
        for j = 1:1:columns
            val = input_image(i,j);
            frequency(val+1) = frequency(val+1)+1;
            pdf(val+1) = frequency(val+1)/pixel_number;
        end
    end
    sum =0 ;
    %we want the 256 - 1 that's why we initailzed the intensity_level with 255
    %instead of 256
    intensity_level = 255;
    
    for i = 1:1:size(pdf)
        sum =sum +frequency(i);
        cummulative(i) = sum;
        cdf(i) = cummulative(i)/ pixel_number;
        outpic(i) = round(cdf(i) * intensity_level);
    end
    
    
    for i = 1:1:rows
        for j = 1:1:columns
            result_image(i,j) = outpic(input_image(i,j) + 1);
        end
    end
    subplot(2,2,1),imshow(input_image),title('Original Image');
    subplot(2,2,2),imshow(result_image),title('After Histogram Equalization');
    subplot(2,2,3),showHistogram(input_image),title('Original Image');
    subplot(2,2,4),showHistogram(result_image),title('After Histogram Equalization');
    
end


