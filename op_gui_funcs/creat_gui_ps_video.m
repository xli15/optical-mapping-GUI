function creat_gui_ps_video(Vtotal,ps_info, rotation_info, n_rotation_thresh, t_start, t_end,file_name,vd_quality,vd_frate)

%% combine major_ps_info and ps_info to generate video
for ps_tyindex =  1:2
    
    ps_info{ps_tyindex} = [ps_info{ps_tyindex}(:,1:5), ...
        zeros(size( ps_info{ps_tyindex},1),1)];
    for ps_id =  1:length(unique(ps_info{ps_tyindex}(:,5)))
        
        ps_info{ps_tyindex}((ps_info{ps_tyindex}(:,5) == ps_id),6) = ...
            rotation_info{ps_tyindex}(rotation_info{ps_tyindex}(:,1)==ps_id,9);
        %         ps_id,major_ps_info{ps_tyindex}(major_ps_info{ps_tyindex}(:,1)==ps_id,9)
    end
end
%% ps video with filtering
 
video_quality = vd_quality;
video_framerate = vd_frate;

 
vidObj = VideoWriter(file_name);
vidObj.Quality = video_quality;
vidObj.FrameRate = video_framerate;
open(vidObj);
 
figure()


for timet=t_start:2:t_end  
    
    Vshape=squeeze(Vtotal(:,:,  timet));
    str=sprintf('PS rotate over %d times (t = %d ms) ', n_rotation_thresh, timet);
    
    Vshape(isnan(Vshape))=pi+0.1;
    imagesc(Vshape);
    hold on
    
    % anti-clockwise
    ps_locs = ps_info{1}((ps_info{1}(:,3)==timet) ...
        & (ps_info{1}(:,6) > n_rotation_thresh),1:2);
    scatter(ps_locs(:,1),...
        ps_locs(:,2), 75, 'w' , 'filled') 
    
    %  clockwise
    hold on
    ps_locs = ps_info{2}((ps_info{2}(:,3)==timet) ...
        & (ps_info{2}(:,6) > n_rotation_thresh),1:2);
    scatter(ps_locs(:,1),...
        ps_locs(:,2), 75, 'k' , 'filled') 
    
    hold off
    
    caxis([-pi pi+0.1]);
    colordata=colormap('HSV');
    colordata(end,:)=[1 1 1];
    colormap(colordata)
    axis image
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    title(str)
    colorbar('location', 'southoutside')
    writeVideo(vidObj, getframe(gcf));
end
close(gcf)

%# save as AVI file, and open it using system video player
close(vidObj);



