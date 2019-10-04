function n_data = normalize_data(data,mask)

data=data(:, :, 10:end-10);
% Normalize Data
min_data = repmat(min(data,[],3),[1 1 size(data,3)]);
diff_data = repmat(max(data,[],3)-min(data,[],3),[1 1 size(data,3)]);
normData = (data-min_data)./(diff_data);

n_data=normData.*mask(:, :, 1:size(normData,3));