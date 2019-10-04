function hh = harmonic_oi_map_ui(filtered_data, Fs, band_width)

w_m = tukeywin(size(filtered_data,3),.05);
win = repmat(permute(w_m,[3 2 1]),[size(filtered_data,1),size(filtered_data,2)]);
data = filtered_data.*win;
% Find single-sided power spectrum of data
m = size(data,3);               % Window length
n = pow2(nextpow2(m));          % Transform Length
y = fft(data,n,3);              % DFT of signal
f = Fs/2*linspace(0,1,n/2+1);   % Frequency range
p = y.*conj(y)/n;               % Power of the DFT
p_s = 2*abs(p(:,:,1:n/2+1));    % Single-sided power

low_pass = 4;
p_s(:,:,f<low_pass) = 0;
f (f<low_pass) = 0;
% Find Dominant Frequency
[val, ind] = max(p_s,[],3);
freq_max0 = f(ind).*isfinite(val);

%%
freq_max1 = reshape(freq_max0,[size(freq_max0,1)*size(freq_max0,2),1]);
p_s1 = reshape(p_s,[size(freq_max0,1)*size(freq_max0,2),size(p_s,3)]);
f1 = repmat(f,size(freq_max1,1),1);
% band_width = 0.75;
band_low = freq_max1 - band_width/2;
idx_df =  (f1 > repmat(freq_max1 - band_width/2,1,size(f1,2)))...
    &(f1 < repmat(freq_max1 + band_width/2,1,size(f1,2)));
idx_h1 =  (f1 > repmat(freq_max1*2 - band_width/2,1,size(f1,2)))...
    &(f1 < repmat(freq_max1*2 + band_width/2,1,size(f1,2)));
peak_area = (sum(p_s1.*idx_df,2)+sum(p_s1.*idx_h1,2))./sum(p_s1,2);
df_oi = reshape(peak_area,size(freq_max0));

%%
hh = figure('Name','Harmonic_OI');
imagesc(df_oi)
% contour(df_oi)
colordata = colormap('jet');
colordata(1,:)=[1 1 1];
colormap(colordata)
caxis( [0  1]);
axis image
% axis square
axis off
 
C=colorbar; 
set(C, 'fontsize',14);
% xlabel(C,'(Hz)','FontSize',14,'FontName','Times');
set(gca,'FontName','Times','FontSize',14)