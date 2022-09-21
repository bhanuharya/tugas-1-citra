% import image
clc;
I = imread('girl.bmp');
ref = imread('referensi_girl.bmp');
specific = histogramSpecification(I, ref);
imshow(specific)

function [result] = histogramSpecification(I,ref)
    %size
    b = size(I);
    I = double(I);

    b_ref = size(ref);
    ref = double(ref);

    % Histogram image
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

    c_ref = zeros(1,256);
    for i_ref=1 : b_ref(1)
        for j_ref=1 : b_ref(2)
            for k_ref = 0 : 255
                 if ref(i_ref,j_ref) == k_ref
                     c_ref(k_ref+1) = c_ref(k_ref+1) +1;
                 end
            end
        end
    end

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

    %Generate hostogram of the result image
    c_result = zeros(1,256);
    for i=1 : b_ref(1)
        for j=1 : b_ref(2)
            for k=0 : 255
                if result(i,j) == k
                    c_result(k+1) = c_result(k+1)+1;
                end
            end
        end
    end

    %Plotting output
    figure;
    subplot(2,3,1),imshow(uint8(I));
    title('Input Image');
    subplot(2,3,2),imshow(uint8(ref));
    title('Reference Image');
    subplot(2,3,3),imshow(uint8(result));
    title('Result Image');
    subplot(2,3,4),bar(c);
    subplot(2,3,5),bar(c_ref);
    subplot(2,3,6),bar(c_result);
    
end



