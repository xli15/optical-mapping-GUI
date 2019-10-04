function freq_max = find_freq_max(raw_data, Fs)

if length(size(raw_data)) == 3
    data = raw_data;
    w_m = tukeywin(size(data,3),.05);
    win = repmat(permute(w_m,[3 2 1]),[size(data,1),size(data,2)]);
    data = data.*win;
    % Find single-sided power spectrum of data
    m = size(data,3);               % Window length
    n = pow2(nextpow2(m));          % Transform Length
    y = fft(data,n,3);              % DFT of signal
    f = Fs/2*linspace(0,1,n/2+1);   % Frequency range
    p = y.*conj(y)/n;               % Power of the DFT
    p_s = 2*abs(p(:,:,1:n/2+1));    % Single-sided power
    f(1:50) = [];                      % Remove DC
    p_s(:,:,1:50) = [];                % Remove DC component
    %Find Dominant Frequency
    [val, ind] = max(p_s,[],3);
    freq_max = f(ind).*isfinite(val);
else
    if size(raw_data,1) > size(raw_data,2) 
        data = raw_data';
    else
         data = raw_data;
    end
    w_m = tukeywin(size(data,2),.05)';
    win = repmat(w_m,[size(data,1) 1]);
    data = data.*win;
    % Find single-sided power spectrum of data
    m = size(data,2);               % Window length
    n = pow2(nextpow2(m));          % Transform Length
    y = fft(data,n,2);              % DFT of signal
    f = Fs/2*linspace(0,1,n/2+1);   % Frequency range
    p = y.*conj(y)/n;               % Power of the DFT
    p_s = 2*abs(p(:, 1:n/2+1));    % Single-sided power
    f(1:50) = [];                      % Remove DC
    p_s(:, 1:50) = [];                % Remove DC component
    %Find Dominant Frequency
    [val, ind] = max(p_s,[],2);
    freq_max = f(ind).*isfinite(val)';
end