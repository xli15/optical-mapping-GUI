function [minpos, maxpos]= find_minmax_pos_b(datapoint,win)
B = datapoint';
dB = B(2:end) - B(1:length(B)-1);

minpos_raw = find((( dB(2:end) .* dB(1:length(dB)-1))< 0) &  ( dB(2:end) > 0))+1 ;
minpos = nan(1,length(minpos_raw));

for jj=1:length(minpos_raw)
    int=max([1, minpos_raw(jj)-win]):min([length(datapoint), minpos_raw(jj)+win]);
     
    if datapoint(minpos_raw(jj)) == min(datapoint(int))
       minpos(jj) =  minpos_raw(jj);
    end
end

minpos = minpos(~isnan(minpos));

maxpos = find((( dB(2:end) .* dB(1:length(dB)-1))< 0) &  ( dB(2:end) < 0))+1;
minpos(minpos<10)=[];
minpos(minpos>(length(datapoint)-5))=[];

maxpos_new = zeros(1,length(minpos)-1);
for ii =1:length(minpos)-1
    maxpos_temp = maxpos;
    maxpos_temp(maxpos_temp<minpos(ii)) = length(datapoint);
    [~,ind] = min(abs(minpos(ii)-maxpos_temp));
    maxpos_new(ii) = maxpos(ind);
end
maxpos_new(maxpos_new>length(datapoint))=[];
maxpos = maxpos_new;

