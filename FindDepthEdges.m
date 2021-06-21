

img1 = imread('up.bmp');img2 = imread( 'right.bmp' );img3 = imread( 'down.bmp' );img4 = imread( 'left.bmp' );

% make gray scale images
gimg1 = mean( img1, 3 ); mean1 = mean(gimg1(:));
gimg2 = mean( img2, 3 ); mean2 = mean(gimg2(:));
gimg3 = mean( img3, 3 ); mean3 = mean(gimg3(:));
gimg4 = mean( img4, 3 ); mean4 = mean(gimg4(:));

all_mean = mean( [mean1; mean2; mean3; mean4] );

% normalize intensities
gimg1 = gimg1 *all_mean/mean1;
gimg2 = gimg2 *all_mean/mean2;
gimg3 = gimg3 *all_mean/mean3;
gimg4 = gimg4 *all_mean/mean4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%========== Start of Depth Edge Detection Algorithm 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% max color and gray images
maxrgbimg = max( max(img1, img2), max(img3, img4) );
maximg = max( max( gimg1, gimg2 ), max( gimg3, gimg4 ) );

% compute ratio images
r1 = (gimg1+5) ./ (maximg+5);
r2 = (gimg2+5) ./ (maximg+5);
r3 = (gimg3+5) ./ (maximg+5);
r4 = (gimg4+5) ./ (maximg+5);


% compute confidence map
v = fspecial( 'sobel' );
h = v';
d2 = imfilter( r2, h );
d4 = imfilter( r4, h );
d1 = imfilter( r1, v );
d3 = imfilter( r3, v );
silhouette1  = d1 .* (d1>0);      %Keep only negative transition in left image
silhouette2 = abs( d2 .* (d2<0) );%Keep only negative transition in left image
silhouette3 = abs( d3 .* (d3<0) );
silhouette4  = d4 .* (d4>0);

confidence = max(max(silhouette1,  silhouette2), max(silhouette3,  silhouette4));
imwrite( confidence, 'confidence.bmp');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%========== End of Depth Edge Detection Algorithm 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% threshold confidence map to get in Canny style edges of depth map
low_thresh = 0.5;
hi_thresh = 1.0;
edges1 = hysteresis_thresholding( silhouette1, low_thresh, hi_thresh );
edges2 = hysteresis_thresholding( silhouette2, low_thresh, hi_thresh );
edges3 = hysteresis_thresholding( silhouette3, low_thresh, hi_thresh );
edges4 = hysteresis_thresholding( silhouette4, low_thresh, hi_thresh );

edges = edges1 | edges2 | edges3 | edges4 ;

% save results in BMP files 
imwrite( maxrgbimg, 'max.bmp' );
imwrite( edges, 'edges.bmp' );
imwrite( confidence, 'confidence.bmp');

% display results 
figure(1)
imshow(maxrgbimg);
figure(2)
imshow(1-confidence);
figure(3);
imshow(edges);

