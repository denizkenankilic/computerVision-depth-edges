
% Perform 2-level canny-like hysteresis

function [ good_contours ] = hysteresis_thresholding( confidence, low_thresh, hi_thresh )


low_contours = confidence>low_thresh;
high_contours = confidence>hi_thresh;

segments = bwlabel( low_contours, 8 );
high_segments = bwlabel( high_contours,8 );
good_segments = unique( segments( find( high_contours) ));
good_contours = ismember( segments, good_segments );
