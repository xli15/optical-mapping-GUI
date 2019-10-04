function [edge_vec, su_phase]= get_edgevector(phasesmoothed,ps_time_index,ps_center, ...
    n_su_points,gap_thresh )

su_phase = zeros(n_su_points,n_su_points,length(ps_time_index));
half_su_n = floor(n_su_points/2);
center_n = floor(n_su_points/2) + 1;

for t_id = 1: length(ps_time_index)
    
    k_ps_r  = ps_center(t_id,2);
    k_ps_c  = ps_center(t_id,1);
    t_k = ps_time_index(t_id);
    %     [ k_ps_c ,k_ps_r, t_k]
    for loc_r =k_ps_r-half_su_n:k_ps_r+half_su_n
        for loc_c = k_ps_c-half_su_n:k_ps_c+half_su_n
            
            if (0< loc_r) && (loc_r < size(phasesmoothed,1)) && ...
                    (0< loc_c )&& (loc_c < size(phasesmoothed,2))
                
                su_phase(loc_r-k_ps_r+half_su_n+1,loc_c-k_ps_c+half_su_n+1,t_id) = ...
                    phasesmoothed(loc_r, loc_c, t_k);
            else
                su_phase(loc_r-k_ps_r+half_su_n+1,loc_c-k_ps_c+half_su_n+1,t_id) = nan;
            end
            %             [loc_x-k_ps_loc(1)+2,loc_y-k_ps_loc(2)+2,t_id]
            %             [loc_x, loc_y, t_k]
        end
    end
end

%%
edge_vec  = nan(n_su_points*n_su_points,2,size(su_phase,3));
edge_len = zeros(size(su_phase,3),1);

for k_t = 1:1:size(su_phase,3)
    
    [edge_r, edge_c] = find(edge(su_phase(:,:,k_t)));
    
    if size(edge_r,1) > 2
        [~,edge_sort] = sort(sum(([edge_r, edge_c] - center_n).^2,2));
        
        % some noisy edges should be filtered
        % currently use diff gap
        edge_k = [edge_r(edge_sort), edge_c(edge_sort)] ;
        edge_start = edge_k(1,:); %the first point is the one closet to the center
        temp_edge_k = edge_k;
        temp_edge_k(1,:) = nan;
        
        edge_order = nan(size(edge_k,1),1);
        edge_order(1) = 1;
        temp_start = edge_start;
        
        for ii = 2:size(edge_k,1)
            % find the point closest to edge_start
            [~,temp_sort] = sort(sum((temp_edge_k -...
                repmat(temp_start,size(edge_k,1),1)).^2,2));
            edge_order(ii) = temp_sort(1);
            temp_start = temp_edge_k(temp_sort(1),:);
            temp_edge_k(temp_sort(1),:) = nan;
        end
        
        edge_k = edge_k(edge_order,:);
        diff_edge_k = edge_k(2:end,:) - edge_k(1:end-1,:);
        [gap_id, ~] = find(abs(diff_edge_k)>gap_thresh);
        
        if size(gap_id,1)>0
            edge_k = edge_k(1:gap_id(1),:);
        end
        
        edge_vec(1:size(edge_k,1),:,k_t) = edge_k ;
        edge_len(k_t) = max(edge_len(k_t),size(edge_k,1));
    end
end
edge_vec = edge_vec(1:max(edge_len), :, :);