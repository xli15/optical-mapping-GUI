function [data_binned,mask] = bin_thresholding_data(data,bg, bin_size, thresh, perc_ex )
%mask data
BG = mat2gray(bg);
level = graythresh(BG);
BW = im2bw(BG,level*thresh);
BW2 = bwareaopen(BW, perc_ex*size(BG,1)*size(BG,2));
BW3=imfill(BW2, 'holes'); %added this line from Rhythmv2
mask = repmat(BW3,[1 1 size(data,3)]);
 

new_data = data.*mask;
ThreshData=new_data;

data_binned = zeros(size(data));

N=bin_size;
avePattern = ones(N,N);
data=ThreshData;
for i = 1:size(data,3)
    temp = data(:,:,i);
    counts=double(temp>0);
    no_non0=conv2(counts, avePattern, 'same'); %modified from rhythm for distribution
    temp =conv2(temp,avePattern,'same')./no_non0;
    data_binned(:,:,i) = temp;
end
