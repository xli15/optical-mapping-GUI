function  [edge_distance] = get_edge_distance(edge_vec)

edge_distance = nan(size(edge_vec,3),1);


k_start = 1;

while(all(isnan(edge_vec(:, 1, k_start))))
    k_start = k_start + 1;
end

edge_0 = edge_vec(~isnan(edge_vec(:, 1, k_start)), :, k_start);
edge_distance(k_start) = 0;
for k_t = k_start+1:1:size(edge_vec,3)
    
    % figure(k_t)
    % imagesc(su_phase(:,:,k_t));
    % hold on
    % plot(edge_vec(:, 2, k_t),edge_vec(:, 1, k_t),...
    %     '.-','LineWidth',4,...
    %     'Color',[1-k_t/size(su_phase,3) 0 k_t/size(su_phase,3)])
    % axis([1 su_n 1 su_n])
    % axis square
    %
    if ~(all(isnan(edge_vec(:, 1, k_t))))
        
        edge_k = edge_vec(~isnan(edge_vec(:, 1, k_t)), :, k_t);
        % alight the first element only when edge lens are different
        if size(edge_k,1) ~= size(edge_0,1)
            if size(edge_k,1) < size(edge_0,1)
                [~,temp_sort] = sort(sum((edge_0 -...
                    repmat(edge_k(1,:),size(edge_0,1),1)).^2,2));
                if temp_sort(1)+size(edge_k,1) <=  size(edge_0,1)
                    edge_0 = edge_0(temp_sort(1):temp_sort(1)+size(edge_k,1)-1,:);
                else
                    edge_0 = edge_0(temp_sort(1):end,:);
                    edge_k = edge_k(1:size(edge_0,1),:);
                end
            else
                [~,temp_sort] = sort(sum((edge_k -...
                    repmat(edge_0(1,:),size(edge_k,1),1)).^2,2));
                if temp_sort(1)+size(edge_0,1) <=  size(edge_k,1)
                    edge_k = edge_k(temp_sort(1):temp_sort(1)+size(edge_0,1)-1,:);
                else
                    edge_k = edge_k(temp_sort(1):end,:);
                    edge_0 = edge_0(1:size(edge_k,1),:);
                end
            end
        end
        
        edge_distance(k_t) = norm(edge_k-edge_0);
    end
end
%% calculate rotation freq

% n = pow2(nextpow2(length(edge_distance)));          % Transform Length
% y = fft(edge_distance,n);              % DFT of signal
% f = Fs/2*linspace(0,1,n/2+1);   % Frequency range
% p = y.*conj(y)/n;               % Power of the DFT
% p_s = 2*abs(p(1:n/2+1));    % Single-sided power
% 
% % Find Dominant Frequency
% f(1) = [];                      % Remove DC
% p_s(1) = [];                % Remove DC component
% [val, ind] = max(p_s);
% r_f = f(ind)'.*isfinite(val);
% r_T = length(edge_distance)*r_f/1000;

%% using edge angle is not very accurate
% edge_angle = nan(size(edge_vec,3),1);
% edge_angle(1) = 0;
%
% % figure()
% vec1 = edge_vec(~isnan(edge_vec(:,1,1)),:,1);
% vec1 = vec1 - repmat([floor(n_su_points/2),floor(n_su_points/2)],size(vec1,1),1);
% b1 = [ones(length(vec1),1), vec1(:,2)]\vec1(:,1);
% % scatter(vec1(:,2),vec1(:,1))
% % hold on
% % plot(vec1(:,2),[ones(length(vec1),1), vec1(:,2)]*b1)
% angle1 = atan(b1(1));
%
% for k_t = 2:size(edge_vec,3)
%
% vec2 = edge_vec(~isnan(edge_vec(:,1,k_t)),:,k_t);
% vec2 = vec2 - repmat([floor(n_su_points/2),floor(n_su_points/2)],size(vec2,1),1);
%
% if rank([ones(length(vec2),1), vec2(:,2)])>1
% b2 = [ones(length(vec2),1), vec2(:,2)]\vec2(:,1);
% agle2 = atan(b2(1));
% else
%     agle2 = pi*0.5;
% end
% % scatter(vec2(:,2),vec2(:,1))
% % hold on
% % plot(vec2(:,2),[ones(length(vec1),1), vec2(:,2)]*b2)
% % atan(b2(1))
% edge_angle(k_t) = agle2 - angle1;
% end
%
% figure()
% plot(edge_angle,'.-')
% hold on
