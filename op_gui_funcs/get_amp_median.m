function amp_median = get_amp_median(datapoint,maxpos, minpos)

ampstored1 = zeros(length(maxpos),1);
ampstored2 = zeros(length(maxpos),1);

% ampstoredm = zeros(length(maxpos),1);

for kj=1:length(maxpos)
    %find closest nonnan min before the max
    mindbe=abs(maxpos(kj)-minpos);
    mindbe(mindbe<0)=1000;
    [~, ind]=min(mindbe);
    minbefore=minpos(ind);
    amp=datapoint(maxpos(kj))-datapoint(minbefore);
    amp2=datapoint(maxpos(kj))-datapoint(minpos(kj+1));
    [val, ~]=min([amp amp2]);
    ampstored1(kj)=amp;
    ampstored2(kj)=amp2;
%     ampstoredm(kj)=val;
    
end

amp_median = median([ampstored1' ampstored2']);