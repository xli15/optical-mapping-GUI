function get_wavefront_video(phasesmoothed, IsoP, file_name)


wf = figure('Name','wavefront');
%             set(wf, 'nextplot','replacechildren', 'Visible','off');

%# create AVI objectN
vidObj = VideoWriter(file_name);
vidObj.Quality = 100;
vidObj.FrameRate = 10;
open(vidObj);


for t_index = 1:2:size(phasesmoothed,3)
    Vphase = phasesmoothed(:,:,t_index);
    [A,B] = get_wavefront_gui(Vphase,IsoP);
    %                 a = subplot(1,1,1,wf)
     
    imagesc(Vphase);
    
    %                 imagesc( Vphase  )
    hold on
    spy(A, 10, 'w'  )
    spy(B, 10, 'k'  )
    %scatter(colW, rowW, 190, 'm', 'filled')
    caxis([-pi pi])
    
    %                 str=sprintf('Time = %d ms', t_index);
    %                 title(str)
    
    writeVideo(vidObj, getframe(wf));
end