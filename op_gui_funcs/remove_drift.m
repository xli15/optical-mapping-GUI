function data_driftremoved = remove_drift(data)

tempx = 1:size(data,3);
tempy = reshape(data,size(data,1)*size(data,2),[]);

for i = 1:size(data,1)*size(data,2)
    if sum(tempy(i,:)) ~= 0
        [p,s,mu] = polyfit(tempx,tempy(i,:),4); %4, had changed to 10, but rhythm_v2 has 4, change back
        y_poly = polyval(p,tempx,s,mu);
        tempy(i,:) = tempy(i,:) - y_poly;
    end
end
data_driftremoved= reshape(tempy,size(data,1),size(data,2),size(data,3));