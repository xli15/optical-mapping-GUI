function heatmap3 = ps_heat_map_gui(n_rotation_thresh,phasesmoothed,ps_info, bg, blue_bg, c_lim, h_str)

% addpath(YourCodePath)
% 
% abs_olddir = olddir;
% centers0 = para2.sample_centers;
% blue_bg = para2.blue_bg;

% blue_bg = 1;

%%



 
%% plot heat map with ps filtering/black and white bg


 
%     n_rotation_thresh = n_rotation_thresh_heat;
    heatmap3=figure('name',h_str,...
        'Position',[800 400 560*2 420*2]);
    
    
%     for ilist = 1:length(ResultsFolder_List)
%         ResultsFolder = ResultsFolder_List{ilist};
%         abs_ResultsFolder = ResultsFolder;
%         filenames=dir([abs_ResultsFolder]);
%         
%         for i = 1:length(filenames)
%             if  ~isempty(strfind(filenames(i).name,'phasePS')) ...
%                     ||  ~isempty(strfind(filenames(i).name,'DFval')) ...
%                     ||  ~isempty(strfind(filenames(i).name,'Rotation_info'))
%                 filename = filenames(i).name;
%                 load([abs_ResultsFolder,'/',filename])
%                 
%             end
%         end
%         load( [abs_ResultsFolder,'/','Variables.mat'])
%         ResultsFolder = abs_ResultsFolder;
        Vtotal=phasesmoothed;
        V_heat_all=zeros(size(Vtotal,1),size(Vtotal,2));
%         V_heat_all(isnan(Vtotal(:,:,1)))= nan;
%         if ilist < 2
%           
%             bg_data = imread([abs_olddir,'/',nameoftif]);
%             bg_data = double(bg_data);
%             bg_data = bg_data (:,81:160); %1:80
%             bg=bg_data;
%             BG = mat2gray(bg);
%         end
        
        if size(find(ps_info{1}(:,6)>=n_rotation_thresh),1)>0 || ...
                size(find(ps_info{2}(:,6)>=n_rotation_thresh),1)>0
            
            
            V_heat=zeros(size(Vtotal,1),size(Vtotal,2));
            
            for ps_tyindex =  1:2
                major_locs = ...
                    ps_info{ps_tyindex}(ps_info{ps_tyindex}(:,6)>=n_rotation_thresh,1:2);
                for i_loc = 1:size(major_locs,1)
                    V_heat(major_locs(i_loc,2),major_locs(i_loc,1)) = ...
                        V_heat(major_locs(i_loc,2),major_locs(i_loc,1))+1;
                end
                
            end
            
            %             V_heat(~(V_heat))= nan;
            V_heat = V_heat./size(Vtotal,3);
            V_heat_all = V_heat_all+V_heat;
        end
%     end
%     if sum(V_heat_all(:)) > 0
        V_heat_all(~(V_heat_all))= nan;
    %     if ~isnan(max(V_heat_all(:),[],'omitnan'))
    %         c_lim(2) =max(V_heat_all(:),[],'omitnan');
    %     end
        ax1=axes('position',[0.05,0.05,0.8,0.85],'Parent',heatmap3);
        imagesc(V_heat_all,'Parent',ax1);
        C = colorbar( 'position',[0.70,0.05,0.05,0.85],'Limits',c_lim,...,
            'FontSize',40 ,'FontName','Times');

        hold on
%     end
    daspect([1 1 1]),axis off
    BG = mat2gray(bg);
    
    if blue_bg
        
        BG(isnan(Vtotal(:,:,1))) = nan;
        ax2=axes('position',[0.05,0.05,0.8,0.85],'Parent',heatmap3); axis off
        H1=imshow(BG,'Parent',ax2);
        set(H1,'AlphaData',double(isnan(V_heat_all)));
        
        
%         cheat = colordata(heat_color:end,:);
        cheat = zeros(187,3);
        cheat(1:31,3) = 1;
        cheat(1:31,2) = 0.8:(1-0.8)/30:1;
        cheat(31:93,1) = 0: 1/62:1;
        cheat(31:93,2) = 1;
        cheat(31:93,3) = 1:-1/62:0;
        cheat(93:155,1) = 1;
        cheat(93:155,2) = 1:-1/62:0;
        cheat(155:end,1) = 1:-(1-0.5)/32:0.5;
        colormap(ax1,cheat)
        
        if length( unique(BG(~isnan(BG))))==1
            cbg = zeros(3,3);
            cbg(1,:)=[1 1 1]; 
            cbg(2,:)=[0 0 0.8]; 
            cbg(3,:)=[0 0 0.6]; 
        else
            cbg = zeros(62,3);
            cbg(1:31,3) = 0.5:(0.9-0.5)/30:0.9;
            cbg(32:end,3) = 0.9;
            cbg(32:end,2) = 0.01:(0.75-0.01)/30:0.75;
            cbg(1,:)=[1 1 1];           
        end
        colormap(ax2,cbg)
        caxis(ax1,[c_lim(1)  c_lim(2)]);
        %             caxis(ax2,[min(min(BG)) max(max(BG)) ]);
        
    else
        ax2=axes('position',[0.05,0.05,0.8,0.85],'Parent',heatmap3); axis off
        H1=imshow(BG,'Parent',ax2);
        set(H1,'AlphaData',double(isnan(V_heat_all)));
        cdata = colormap(ax1,jet);
%         cdata = cdata(1:100,:);
        colormap(ax1,cdata);
        if ~isnan(max(V_heat_all(:),[],'omitnan'))
            if max(max(V_heat_all)) > min(min(V_heat_all))
%                 caxis(ax1,[min(min(V_heat_all)) max(max(V_heat_all))]);
                  caxis(ax1,[c_lim(1)  c_lim(2)]);
            else
%                 caxis(ax1,[min(min(V_heat_all)) max(max(V_heat_all))+0.01]);
                caxis(ax1,[c_lim(1)  c_lim(2)]);
            end
        else
             caxis(ax1,[-0.0 0]);
        end
    end
    title(['Heat map of ps over ',num2str(n_rotation_thresh),' times'],'FontName','Times','FontSize',40)
    
    hold off
 
  
end
 
