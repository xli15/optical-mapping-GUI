function creat_gui_phase_video(Vtotal, t_start, t_end,file_name,vd_quality,vd_frate)

 
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
    str=sprintf('PS rotate over %d times (t = %d ms) ', timet);
    
    Vshape(isnan(Vshape))=pi+0.1;
    imagesc(Vshape);
    hold on
    
    
    
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



