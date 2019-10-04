function filtered_data = filt_op_data(data,mask,Fs ,lb, hb, f_order, a0,a)

f0 = [lb hb hb*1.25 Fs/2]./(Fs/2);
b = firpm(f_order,f0,a0);


temp = reshape(data,[],size(data,3));
% filt_temp = zeros(size(temp));
% for i = 1:size(temp,1)
%     if sum(temp(i,:)) ~= 0
%         filt_temp(i,:) = filtfilt(b,a,temp(i,:)); % needed to create 0 phase offset
%     end
% end

filt_temp = filtfilt(b,a,temp'); 
filt_temp =filt_temp';
filt_data = reshape(filt_temp,size(data,1),size(data,2),[]);


%remove drift
 
tempx = 1:size(filt_data,3);
tempy = reshape(filt_data,size(filt_data,1)*size(filt_data,2),[]);
 
for i = 1:size(filt_data,1)*size(filt_data,2)
    if sum(tempy(i,:)) ~= 0
        [p,s,mu] = polyfit(tempx,tempy(i,:),4); %4, had changed to 10, but rhythm_v2 has 4, change back
        y_poly = polyval(p,tempx,s,mu);
        tempy(i,:) = tempy(i,:) - y_poly;
    end
end
data_driftremoved0= reshape(tempy,size(filt_data,1),size(filt_data,2),size(filt_data,3));
 
data_driftremoved=data_driftremoved0;
data_driftremoved=data_driftremoved(:, :, 10:end-10);
% Normalize Data
min_data = repmat(min(data_driftremoved,[],3),[1 1 size(data_driftremoved,3)]);
diff_data = repmat(max(data_driftremoved,[],3)-min(data_driftremoved,[],3),[1 1 size(data_driftremoved,3)]);
normData = (data_driftremoved-min_data)./(diff_data);

filtered_data=normData.*mask(:, :, 1:size(normData,3));