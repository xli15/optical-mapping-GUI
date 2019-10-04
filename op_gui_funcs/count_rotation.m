function [minpos,n_rotaion] = count_rotation(s_edge_distance, win)

datapoint = s_edge_distance;
B = datapoint';
dB = B(2:end) - B(1:length(B)-1);

minpos_raw = find((( dB(2:end) .* dB(1:length(dB)-1)) <= 0) &  ( dB(2:end) > 0))+1 ;
minpos_raw = [minpos_raw,length(s_edge_distance)];
minpos = nan(1,length(minpos_raw));

for jj=1:length(minpos_raw)
    int=max([1, minpos_raw(jj)-win]):min([length(datapoint), minpos_raw(jj)+win]);
     
    if datapoint(minpos_raw(jj)) == min(datapoint(int))
       minpos(jj) =  minpos_raw(jj);
    end
end

minpos = minpos(~isnan(minpos));
n_rotaion = length(minpos);
 
