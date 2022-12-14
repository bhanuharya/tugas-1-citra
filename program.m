% import image
I = imread('image/Fig0222(a)(face).tif');
imshow(I)
histogram = histogram_show(I);
I_bright = makebright(I, 1.2, 200);
I_log = logTransform(I,2);
I_power = powerTransform(I,1,2);
I_coffee = imread('image/peppers512warna.bmp');
I_bright = makebright(I_coffee, 1.2, 100);

%{
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

%}

% No. 1 - Getting the component
function [c] = histogram_calculation(I)
    b = size(I);
    I = double(I);
    c = zeros(1,256);
    for i=1 : b(1)
        for j=1 : b(2)
            for k = 0 : 255
                 if I(i,j) == k
                     c(k+1) = c(k+1) +1;
                 end
            end
        end
    end
    

end

% No. 1 - Bar Use Case
function [histogram] = histogram_bar(I)
    histogram = histogram_calculation(I);
    bar(histogram, 'BarWidth', 1, 'FaceColor', 'b');
end

% No. 1 - Show Histogram with subplot
function [n] = histogram_show(I)
    [~,~,n] = size(I);
    if n == 3
        r1 = I(:,:,1);
        g1 = I(:,:,2);
        b1 = I(:,:,3);

        subplot(1,3,1),histogram_bar(r1),title('Red');
        subplot(1,3,2),histogram_bar(g1),title('Green');
        subplot(1,3,3),histogram_bar(b1),title('Blue');
    else
        subplot(1,1,1),histogram_bar(I),title('Grayscale');

    end

end    

% No. 2.a - image brightening
function [ s ] = makebright(r, a, b) 
   s = r*a + b; 
   s(s > 255) = 255;
   subplot(1,2,1),imshow(r),title("Original Image")
   subplot(1,2,2),imshow(s),title("Image after Transformation")
end

% No. 2.b - Transformasi log (???? = ???? ????????????(1 + ????), ????  konstanta
% parameter input dari pengguna
function [ s ] = logTransform(r, c) 
   r_double = double(r)/255;
   s = c*log(1+(r_double)); 
   subplot(1,2,1),imshow(r),title("Original Image")
   subplot(1,2,2),imshow(s),title("Image after Log Transformation")
end

% No. 2.c - Transformasi pangkat (???? = ????????^y, ???? dan ???? adalah parameter input dari pengguna)
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

function [ result_image] = equalization(input_image) 
    
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
    
end

function [ result_image ] = histeq_manual(I) 

    [~,~,n] = size(I);
    if n == 3
        r1 = I(:,:,1);
        g1 = I(:,:,2);
        b1 = I(:,:,3);

        r = equalization(r1);
        g = equalization(g1);
        b = equalization(b1);

        result_image = cat(3,r,g,b);
        subplot(2,4,1),imshow(I),title('Original Image');
        subplot(2,4,2),histogram_bar(r1),title('Red Input');
        subplot(2,4,3),histogram_bar(g1),title('Green Input');
        subplot(2,4,4),histogram_bar(b1),title('Blue Input');
        subplot(2,4,5),imshow(result_image),title('After Histogram Equalization');
        subplot(2,4,6),histogram_bar(r),title('Red Output');
        subplot(2,4,7),histogram_bar(g),title('Green Putput');
        subplot(2,4,8),histogram_bar(b),title('Blue Output');

    else

        result_image = equalization(I);
        subplot(2,2,1),imshow(I),title('Original Image');
        subplot(2,2,3),imshow(result_image),title('After Histogram Equalization');
        subplot(2,2,2),histogram_bar(I),title('Original Image');
        subplot(2,2,4),histogram_bar(result_image),title('After Histogram Equalization');

    end

end

function [result] = histogramMatching(I,ref)
    %size
    b = size(I);
    I = double(I);

    b_ref = size(ref);
    ref = double(ref);

    % Histogram image
    c = histogram_calculation(I);

    c_ref = histogram_calculation(ref);

    %Generate PDF out of histogram
    pdf = (1/(b(1)*b(2)))*c;

    pdf_ref = (1/(b_ref(1)*b_ref(2)))*c_ref;

    %Generate CDF out of PDF
    cdf = zeros(1,256);
    cdf(1)= pdf(1) ;
    for i=2 : 256
        cdf(i) = cdf(i-1) + pdf(i) ;
    end
    cdf = round(255*cdf) ;

    cdf_ref = zeros(1,256);
    cdf_ref(1)= pdf_ref(1) ;
    for i=2 : 256
        cdf_ref(i) = cdf_ref(i-1) + pdf_ref(i) ;
    end
    cdf_ref = round(255*cdf_ref) ;


    %Comparing CDF of input and reference
    d = 255*ones(1,256);
    for k=1 : 256
        for k_ref=1 : 256
            if cdf(k) < cdf_ref(k_ref)
                d(k) = k_ref;
                break
            end
        end
    end

    %Generate the result image(final output image)
    result = zeros(b(1),b(2));
    for i=1 : b(1)
        for j=1 : b(2)
            t= (I(i,j)+1);
            result(i,j) = d(t);
        end
    end
end

function [out] = histogramSpecification(I,ref)
    [~,~,n] = size(I);
    if n == 3
        r1 = I(:,:,1);
        g1 = I(:,:,2);
        b1 = I(:,:,3);

        r2 = ref(:,:,1);
        g2 = ref(:,:,2);
        b2 = ref(:,:,3);
        
        r = histogramMatching(r1,r2);
        g = histogramMatching(g1,g2);
        b = histogramMatching(b1,b2);
        
        out = cat(3,r,g,b);
        
        cR1 = histogram_calculation(r1);
        cG1 = histogram_calculation(g1);
        cB1 = histogram_calculation(b1);
        
        cR2 = histogram_calculation(r2);
        cG2 = histogram_calculation(g2);
        cB2 = histogram_calculation(b2);
        
        cR = histogram_calculation(r);
        cG = histogram_calculation(g);
        cB = histogram_calculation(b);
        
        figure;
        subplot(5,3,1),imshow(uint8(I));
        title('Input Image')
        subplot(5,3,2),imshow(uint8(ref));
        title('Reference Image');
        subplot(5,3,3),imshow(uint8(out));
        title('Result Image');
        subplot(5,3,4),bar(cR1),title('Red Input');
        subplot(5,3,5),bar(cG1),title('Green Input');
        subplot(5,3,6),bar(cB1),title('Blue Input');
        subplot(5,3,7),bar(cR2),title('Red Reference');
        subplot(5,3,8),bar(cG2),title('Green Reference');
        subplot(5,3,9),bar(cB2),title('Blue Reference');
        subplot(5,3,10),bar(cR),title('Red Result');
        subplot(5,3,11),bar(cG),title('Green Result');
        subplot(5,3,12),bar(cB),title('Blue Result');
        subplot(5,3,13);
    else
        out = histogramMatching(I,ref);
        
        cI = histogram_calculation(I);
        cR = histogram_calculation(ref);
        cO = histogram_calculation(out);
        
        figure;
        subplot(3,3,1),imshow(uint8(I));
        title('Input Image')
        subplot(3,3,2),imshow(uint8(ref));
        title('Reference Image');
        subplot(3,3,3),imshow(uint8(out));
        title('Result Image');
        subplot(3,3,4),bar(cI),title('Input');
        subplot(3,3,5),bar(cR),title('Reference');
        subplot(3,3,6),bar(cO),title('Result');
        subplot(3,3,7);
    end
    
end


