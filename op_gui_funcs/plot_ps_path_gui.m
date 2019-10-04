function pathmap = plot_ps_path_gui(bg,Vtotal,ps_locs,ps_color,bg_flag)


 pathmap=figure('name',['path of the ps with the logest duratoin'],...
    'Position',[800 400 560*2 420*2]);

BG = mat2gray(bg);
BG(isnan(Vtotal(:,:,1))) = nan;
ax2=axes('position',[0.05,0.05,0.8,0.85],'Parent',pathmap); 
hold on
daspect([1 1 1]),axis off
H1=imshow(BG,'Parent',ax2);

if bg_flag
    
    if length( unique(BG(~isnan(BG))))==1
        cbg = zeros(3,3);
        cbg(1,:)=[1 1 1];
        cbg(2,:)=[0 0 0.8];
        cbg(3,:)=[0 0 0.6];
    else
        cbg = zeros(62,3);
        cbg(1:31,3) = 0.5:(0.98-0.5)/30:0.98;
        cbg(32:end,3) = 0.98;
        cbg(32:end,2) = 0.01:(0.75-0.01)/30:0.75;
        cbg(1,:)=[1 1 1];
    end
    colormap(ax2,cbg)
    
    
    
end
hold on
%
plot(ps_locs(:,1), ps_locs(:,2),['.-',ps_color],'LineWidth',3)
plot(ps_locs(1,1), ps_locs(1,2),['^','y'], 'MarkerSize',8,'MarkerFaceColor',ps_color,'LineWidth',3)
plot(ps_locs(end,1), ps_locs(end,2),['o','y'], 'MarkerSize',8,'MarkerFaceColor',ps_color,'LineWidth',3)

%     end
hold off
axis image
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca, 'nextplot','replacechildren', 'Visible','off');


