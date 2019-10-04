function [minpos, maxpos] = find_minmax_pos(datapoint, win)

%step one: find minima
% moving min windows
act=[];
for jj=1:length(datapoint)
    int=max([1, jj-win]):min([length(datapoint), jj+win]);
    [val, pos]=min(datapoint(int));
    if jj==(pos+max([1, jj-win])-1)
        act=[act jj];
    end
end
minpos=act;
minpos(minpos<10)=[];
minpos(minpos>(length(datapoint)-5))=[];
%%
% dB = B(2:end) - B(1:length(B)-1);
%  
% 
% maxpos2 = find((( dB(2:end) .* dB(1:length(dB)-1))< 0) &  ( dB(2:end) < dB(1:length(dB)-1)));
% minpos2 = find((( dB(2:end) .* dB(1:length(dB)-1))< 0) &  ( dB(2:end) > dB(1:length(dB)-1))) ;
 
%window of 10 is small enough to simply take maxima between

for II = 1: length(minpos)-1
    ind=[];
    dataran=datapoint(minpos(II):minpos(II+1));
    [C,ind]=max(dataran);
    maxpos(II)=minpos(II)-1+ind;
end

maxpos(maxpos>length(datapoint))=[];



