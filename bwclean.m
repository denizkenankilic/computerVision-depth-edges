

function [ clean_img ]= bwclean( img, min_blob_size)

clean_img = zeros( size( img));

[limg,num_blobs] = bwlabel( img,8 );

for i=1:num_blobs
    blobidx = find( limg == i );
    if length( blobidx )>min_blob_size
        
        clean_img(blobidx)= img( blobidx);
    end
end

return;