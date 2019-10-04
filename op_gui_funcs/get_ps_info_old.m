function [ps_info,ps_duration ]= get_ps_info_old(c_all,r_all,mov_thresh)

n_ps_raw = 0;

for t_k = 1:size(c_all,2)
    n_ps_raw = n_ps_raw + length(find(c_all(:,t_k)>0));
end

ps_info = zeros(n_ps_raw,5);

k0 = find(c_all(1,:),1,'first') ;

loc_k0 = [c_all(c_all(:,k0)>0,k0), r_all(r_all(:,k0)>0,k0)];
if   (size(loc_k0,2)) ==1  && ...
        (size(loc_k0,1) == 2)
    loc_k0 = loc_k0';
end

n_ps_k0  = size(loc_k0,1);

raw_ps_id = 1;
totall_ps_id = 1;
t_ps_id = 1;
for j0 = 1:n_ps_k0
    %     ps_info = [loc_k0(j0,:), k0 , t_ps_id, totall_ps_id];
    ps_info(raw_ps_id,:) = [loc_k0(j0,:), k0 , t_ps_id, totall_ps_id];
    fprintf('loc0-%d %d %d  %d %d %d  \n',...
        j0,loc_k0(j0,1),loc_k0(j0,2),k0, t_ps_id, totall_ps_id);
    totall_ps_id = totall_ps_id + 1;
    t_ps_id = t_ps_id +1;
    raw_ps_id = raw_ps_id + 1;
end


loc_k = loc_k0;
n_ps_k = n_ps_k0;

for k1 = k0+1:size(c_all,2)

    k = k1 - 1;
    loc_k1 = [c_all(c_all(:,k1)>0,k1), r_all(r_all(:,k1)>0,k1)];
    
   
    if size(loc_k1,1) > 0
        
        if (size(loc_k1,2) ==1) && ...
                (size(loc_k1,1) == 2)
            loc_k1 = loc_k1';
        end
        
        n_ps_k1  = size(loc_k1,1);
        
        for j1 = 1:n_ps_k1
            
            ps_id_k1 = nan;
            d_temp1 = nan;
            
%             if k1 ==43 & j1 == 6
%                 j1
%                 loc_k1(j1,:)
%             end
            
            if n_ps_k>0
                for loc_j = 1:n_ps_k
                    d_temp = abs(loc_k(loc_j,:)-loc_k1(j1,:));
                    if isnan(d_temp1)
                        if d_temp(1)< mov_thresh && d_temp(2)< mov_thresh
                            ps_id_k1 = ps_info(ps_info(:,3)==k & ps_info(:,4) ==loc_j,5);
                            d_temp1 = d_temp;
                        end
                        
                    else
%                         if d_temp(1) < d_temp1(1)  &&   d_temp(2) < d_temp1(2)
                        if norm(d_temp) < norm(d_temp1)
                            ps_id_k1 = ps_info(ps_info(:,3)==k & ps_info(:,4) ==loc_j,5);
                            d_temp1 = d_temp;
                        end
                        
                    end
                end
                if isnan(ps_id_k1)
                    fprintf('Far from all existing ps. New ps No. %d. \n',totall_ps_id )
                    ps_id_k1 =   totall_ps_id;
                    totall_ps_id = totall_ps_id +1;
                end
            else
                fprintf('No existing ps. New ps No. %d. \n',totall_ps_id )
                ps_id_k1 =   totall_ps_id;
                totall_ps_id = totall_ps_id +1;
            end
            %             ps_info = [ps_info ; [loc_k1(j1,:), k1 , j1, ps_id_k1]];
            ps_info(raw_ps_id,:) = [loc_k1(j1,:), k1 , j1, ps_id_k1];
            raw_ps_id = raw_ps_id + 1;
            
             
%             fprintf('loc1-%d %d %d  %d %d %d  \n',...
%                 j1,loc_k1(j1,1),loc_k1(j1,2),k1, j1, ps_id_k1);
%             
            
        end
    else
        n_ps_k1 = 0;
        
    end
    
    loc_k = loc_k1;
    n_ps_k = n_ps_k1;
end


%%
%count duration
totall_ps_id = max(ps_info(:,5));
ps_duration = zeros(totall_ps_id,1);

for k_ps = 1:totall_ps_id
    k_ps_index = find(ps_info(:,5)==k_ps);
    ps_duration(k_ps) = ps_info(k_ps_index(end),3)-ps_info(k_ps_index(1),3);
end