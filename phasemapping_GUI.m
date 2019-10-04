function phasemapping_GUI5
% This software was developed by Xinyang LI (xinyang.li@imperial.ac.uk) and 
% Caroline H Roney (caroline.roney@kcl.ac.uk)
% ElectroCardioMaths Programme, National Heart and Lung Institute, 
% Imperial College London
 

close all; clc; clear all;
% make sure to op_gui_funcs were added to the path
% addpath(genpath(pwd))

group_font_size = 14;
button_font_size = 14;
text_font_size = 14;
edit_font_size = 14;

button_len = 145;
button_w = 25;
edit_w = 30;

font1 = 'Chalkboard';
font1 = 'lantinghei tc';
font3 = 'CamBria';
% font1 = 'lantinghei tc';
% font3 = 'corbel';
% font3 = 'Chalkboard';
% font3 = 'lantinghei tc';
% font3 = 'Markerfelt';
% font3 = 'Chalkduster';
% font3 = 'Segoe Script';
% font3 = 'lantinghei tc';
%%
f = figure('Name','phasemapping v0.1.0','Visible','off','Position',[180,250,1080,750],'NumberTitle','Off');
% UIControl_FontSize_bak = get(0, 'DefaultUIControlFontSize');
set(f, 'DefaultUIControlFontSize', 12,'DefaultUIControlFontName',font3);
% Load raw Data

% Raw data loading group
p1 = uibuttongroup('Title','Raw data loading','FontName',font1,...
    'FontSize',group_font_size,'Position',[.02 0.575 0.31 .415]);

selectdir = uicontrol('Parent',p1,'Style','pushbutton','FontSize',button_font_size,...
    'String','Set Directory for Results Folder','Position',[10 250 310 30],...
    'Callback',{@selectdir_callback});
refreshdir = uicontrol('Parent',p1,'Style','pushbutton','FontSize',button_font_size,...
    'String','Refresh Directory','Position',[10 210 button_len button_w],'Callback',{@refreshdir_callback});

file_keyword = uicontrol('Parent',p1,'Style','text','FontSize',text_font_size,...
    'String','Keyword: ','Position',[10 160 80 edit_w]);
file_keyword_edit = uicontrol('Parent',p1,'Style','edit',...
    'FontSize',edit_font_size,'String','4s','Position',[105 165 40 edit_w]);

filelist = uicontrol('Parent',p1,'Style','listbox','String','Files',...
    'Position',[170 130 140 105],'FontSize',edit_font_size,'Callback',{@filelist_callback});
% volt_button  = uicontrol('Parent',p1,'Style','checkbox','FontSize',9,'String','Vm','Position',[20 450 60 20]);

Fs_text = uicontrol('Parent',p1,'Style','text','FontSize',text_font_size,...
    'String','Fs: ','Position',[15 125 80 edit_w]);
Fs_edit = uicontrol('Parent',p1,'Style','edit','FontSize',edit_font_size,...
    'String','1000','Position',[105 130 40 edit_w]);

% calc_button = uicontrol('Parent', p1, 'Style','checkbox','FontSize',9,'String','Ca','Position', [90 450 60 20]);
start_time_label = uicontrol('Parent',p1,'Style','text','FontSize',text_font_size,...
    'String','From','Position',[15 80 65 edit_w]);
end_time_label = uicontrol('Parent',p1,'Style','text','FontSize',text_font_size,...
    'String','to','Position',[125 80 25 edit_w]);
start_time_edit = uicontrol('Parent',p1,'Style','edit','FontSize',edit_font_size,...
    'String','19','Position',[80 85 40 edit_w]);
end_time_edit = uicontrol('Parent',p1,'Style','edit','FontSize',edit_font_size,...
    'String','3990','Position',[155 85 40 edit_w]);
ms_label = uicontrol('Parent',p1,'Style','text','FontSize',text_font_size,...
    'String','(ms)','Position',[195 80 50 edit_w]);

or_label = uicontrol('Parent',p1,'Style','text','FontSize',...
    text_font_size,'String','or','Position',[155 35 25 30]);
load_da_button = uicontrol('Parent',p1,'Style','pushbutton',...
    'FontSize',button_font_size,'String','Load Data (.da)','Position',...
    [10 40 button_len button_w],'Callback',{@load_da_data});
load_mat_button = uicontrol('Parent',p1,'Style','pushbutton',...
    'FontSize',button_font_size,'String','Load Data (.mat)',...
    'Position',[180 40 button_len button_w],'Callback',{@load_mat_data});
or_label2 = uicontrol('Parent',p1,'Style','text','FontSize',...
    text_font_size,'String','or','Position',[155 5 25 30]);
load_bg_button = uicontrol('Parent',p1,'Style','pushbutton',...
    'FontSize',button_font_size,'String','Load BG (.tif)','Position',...
    [10 10 button_len button_w],'Callback',{@load_bg_data});
load_bgmat_button = uicontrol('Parent',p1,'Style','pushbutton',...
    'FontSize',button_font_size,'String','Load BG (.mat)','Position',...
    [180 10 button_len button_w],'Callback',{@load_bgmat_data});

set([f,p1,filelist,selectdir,refreshdir,load_mat_button,...
    file_keyword,file_keyword_edit,Fs_text,Fs_edit,ms_label,...
    start_time_label,end_time_label,start_time_edit,end_time_edit,...
    load_da_button,or_label,load_mat_button,load_bg_button,...
    or_label2,load_bgmat_button],'Units','normalized');

%%
% Signal Conditioning Button Group and Buttons
cond_sig = uibuttongroup( 'Title','Pre-processing','FontName',font1,...
    'FontSize',group_font_size,'Position',[0.02 0.345 0.31 .225]);
% removeBG_text = uicontrol('Parent',cond_sig,'Style','text','FontSize',9,'String','BG removing: ','Position',[5 150 80 25]);
bg_thresh_label = uicontrol('Parent',cond_sig,'Style','text','HorizontalAlignment','center',...
    'FontSize',text_font_size,'String','BG Removing Threshold:','Position',[10 90 95 45]);
bg_thresh_edit = uicontrol('Parent',cond_sig,'Style','edit','FontSize',edit_font_size,'String','0.3','Position',[115 100 35 edit_w]);

perc_ex_label = uicontrol('Parent',cond_sig,'Style','text','FontSize',text_font_size,'String','BG EX Threshold:','Position',[165 90 70 45]);
perc_ex_edit = uicontrol('Parent',cond_sig,'Style','edit','FontSize',edit_font_size,'String','0.4','Position',[245 100 35 edit_w]);

% binfilt_text = uicontrol('Parent',cond_sig,'Style','text','FontSize',9,'String','Binning and filtering setting: ','Position',[5 70 135 25]);
filt_text = uicontrol('Parent',cond_sig,'Style','text','FontSize',text_font_size,'String','Filter band: ','Position',[10 50 60 50]);
to_text = uicontrol('Parent',cond_sig,'Style','text','FontSize',text_font_size,'String','~','Position',[117.5 55 10 edit_w]);
filt_low_edit = uicontrol('Parent',cond_sig,'Style','edit','FontSize',edit_font_size,'String','0','Position',[80 60 40 edit_w]);
filt_high_edit = uicontrol('Parent',cond_sig,'Style','edit','FontSize',edit_font_size,'String','100','Position',[130 60 40 edit_w]);
hz_text = uicontrol('Parent',cond_sig,'Style','text','FontSize',text_font_size,'String','Hz','Position',[180 55 20 edit_w]);


bin_text2  = uicontrol('Parent',cond_sig,'Style','text','FontSize',text_font_size,'String','Binsize:','Position',[10 10 60 edit_w]);
nbin_edit = uicontrol('Parent',cond_sig,'Style','edit','FontSize',edit_font_size,'String','1','Position',[80 15 35 edit_w]);
x_text2  = uicontrol('Parent',cond_sig,'Style','text','FontSize',text_font_size,'String','x','Position',[117.5 10 10 edit_w]);
bin_size_edit  = uicontrol('Parent',cond_sig,'Style','edit','FontSize',edit_font_size,'String','5','Position',[130 15 35 edit_w]);


condition_apply_button = uicontrol('Parent',cond_sig,'Style','pushbutton','FontSize',button_font_size,...
    'String','Apply','Position',[180 15 button_len button_w],'Callback',{@preprocess_data});

set([cond_sig,bg_thresh_label,perc_ex_label,bg_thresh_edit,...
    perc_ex_edit,bin_text2,bin_size_edit,x_text2,nbin_edit,filt_text,...
    filt_low_edit,to_text,filt_high_edit,hz_text,...
    condition_apply_button],'Units','normalized');

%% Load filtered data for phase analysis
p22 = uibuttongroup('Title','Load results','FontName',font1,...
    'FontSize',group_font_size,'Position',[0.02 0.01 0.31 .325]);

selectdir2 = uicontrol('Parent',p22,'Style','pushbutton','FontSize',button_font_size,...
    'String','Select Results Folder','Position',[10 190 310 25],'Callback',{@selectdir_callback2});
filelist2 = uicontrol('Parent',p22,'Style','listbox','String','Files','Position',...
    [160 45 150 135],'FontSize',edit_font_size,'Callback',{@filelist_callback2});
refreshdir2 = uicontrol('Parent',p22,'Style','pushbutton','FontSize',button_font_size,...
    'String','Refresh Directory','Position',[10 160 button_len 25],'Callback',{@refreshdir_callback2});

bin_text2  = uicontrol('Parent',p22,'Style','text','FontSize',...
    text_font_size,'String','Binsize:','Position',[10 120 80 edit_w]);
bin_size_edit2 = uicontrol('Parent',p22,'Style','edit','FontSize',....
    edit_font_size,'String','3','Position',[100 125 35 edit_w]);

move_thresh  = uicontrol('Parent',p22,'Style','text','FontSize',...
    text_font_size,'String','Spatial gap:','Position',[10 80 80 edit_w]);
move_thresh_edit = uicontrol('Parent',p22,'Style','edit','FontSize',...
    edit_font_size,'String','5','Position',[100 85 35 edit_w]);

t_thresh  = uicontrol('Parent',p22,'Style','text','FontSize',...
    text_font_size,'String','Temporal gap:','Position',[15 40 80 edit_w]);
t_thresh_edit = uicontrol('Parent',p22,'Style','edit','FontSize',...
    edit_font_size,'String','5','Position',[100 45 35 edit_w]);


do_phase_button = uicontrol('Parent',p22,'Style','pushbutton','FontSize',button_font_size,...
    'String','Calculate Phase and detect PS','Position',[10 10 310 button_w],'Callback',{@do_phase});


set([p22, selectdir2,refreshdir2,filelist2,do_phase_button,t_thresh,t_thresh_edit],'Units','normalized');

%%
p33 = uibuttongroup('Title','Background Plot','FontName',font1,...
    'FontSize',group_font_size,'Position',[0.34 0.325 0.32 .665]);
bg_text = uicontrol('Parent',p33,'Style','text','FontSize',text_font_size,...
    'String','the BG image should be consistent with the edge of the raw data',...
    'Position',[20 429 320 50]);


movie_scrn = axes('Parent',p33,'Units','Pixels','YTick',[],'XTick',[],'Position',[10, 10, 320, 415]);

%% screen
p44 = uibuttongroup('Title','Key Restuls','FontName',font1,...
    'FontSize',group_font_size,'Position',[0.34 0.01 0.32 .3]);

nps_text = uicontrol('Parent',p44,'Style','text','FontSize',text_font_size,...
    'String','No. of PS: ','Position',[10 165 80 edit_w]);
nps_edit = uicontrol('Parent',p44,'Style','edit',...
    'FontSize',edit_font_size,'String','','Position',[100 170 40 edit_w]);

nps_text2 = uicontrol('Parent',p44,'Style','text','FontSize',text_font_size,...
    'String','No. of PS (>= 2):','Position',[160 165 90 edit_w]);
nps_edit2 = uicontrol('Parent',p44,'Style','edit',...
    'FontSize',edit_font_size,'String','','Position',[265 170 40 edit_w]);

nl_text = uicontrol('Parent',p44,'Style','text','FontSize',text_font_size,...
    'String','No. of pixels with PS: ','Position',[10 125 90 edit_w]);
nl_edit = uicontrol('Parent',p44,'Style','edit',...
    'FontSize',edit_font_size,'String','','Position',[100 125 40 edit_w]);

nl_text2 = uicontrol('Parent',p44,'Style','text','FontSize',text_font_size,...
    'String','No. of pixels with PS (>= 2): ','Position',[160 110 100 40]);
nl_edit2 = uicontrol('Parent',p44,'Style','edit',...
    'FontSize',edit_font_size,'String','','Position',[265 115 40 edit_w]);


mdt_text = uicontrol('Parent',p44,'Style','text','FontSize',text_font_size,...
    'String','Max PS duration: ','Position',[10 60 120 edit_w]);
mdt_edit = uicontrol('Parent',p44,'Style','edit',...
    'FontSize',edit_font_size,'String','','Position',[145 65 60 edit_w]);
mdt_text2 = uicontrol('Parent',p44,'Style','text','FontSize',text_font_size,...
    'String','(ms)','Position',[210 60 120 edit_w]);

mrt_text = uicontrol('Parent',p44,'Style','text','FontSize',text_font_size,...
    'String','Max rotations: ','Position',[10 20 120 edit_w]);
mrt_edit = uicontrol('Parent',p44,'Style','edit',...
    'FontSize',edit_font_size,'String','','Position',[145 25 60 edit_w]);

set([p33, movie_scrn,...
    p44, nps_text,nps_edit,nps_text2,nps_edit2,...
    nl_edit,nl_text,nl_edit2,nl_text2,...
    mdt_text,mdt_edit,mdt_text,mdt_text2,...
    mrt_text,mrt_edit,bg_text],'Units','normalized');

%
%%
quantgroup = uipanel('Title','PS Quantification','FontName',font1,...
    'FontSize', group_font_size,'Position',[0.67 0.815 0.31 .175]);

n_neighbour  = uicontrol('Parent',quantgroup,'Style','text','FontSize',...
    text_font_size,'String','Boundary:','Position',[155 70 90 25]);
n_neighbour_edit = uicontrol('Parent',quantgroup,'Style','edit','FontSize',...
    edit_font_size,'String','11','Position',[250 75 35 25]);

gap_thresh0  = uicontrol('Parent',quantgroup,'Style','text','FontSize',...
    text_font_size,'String','Edge gap: ','Position',[10 70 90 25]);
gap_thresh_edit = uicontrol('Parent',quantgroup,'Style','edit','FontSize',...
    edit_font_size,'String','3','Position',[105 75 35 25]);

do_rotor_button = uicontrol('Parent',quantgroup,'Style','pushbutton','FontSize',button_font_size,'String',...
    'Calculate PS Statistics','Position',...
    [15 42.5 310 25],'Callback',{@do_rotor});
bg_blue1  = uicontrol('Parent',quantgroup,'Style','text','FontSize',text_font_size,'String',...
    'Blue BG','Position',[30 5 110 edit_w]);
cbx1 = uicontrol('Parent',quantgroup, 'Style','checkbox',  'Position',[25 20 15 15]);
ps_path_button = uicontrol('Parent',quantgroup,'Style','pushbutton','FontSize',button_font_size,'String',...
    'Plot path','Position',[180 10 button_len button_w],'Callback',{@plot_path});
set([quantgroup,bin_text2,bin_size_edit2,move_thresh,move_thresh_edit,...
    gap_thresh0,gap_thresh_edit,n_neighbour,n_neighbour_edit,bg_blue1,cbx1...
    do_rotor_button,ps_path_button],'Units','normalized');



% ps group
psgroup = uipanel('Title','PS video and heatmap','FontName',font1...
    ,'FontSize',group_font_size,'Position',[0.67 0.675 0.31 .125]);

video_thresh  = uicontrol('Parent',psgroup,'Style','text','FontSize',text_font_size,'String',...
    'n_rotation >=','Position',[10 30 110 edit_w]);
video_thresh_edit = uicontrol('Parent',psgroup,'Style','edit','FontSize',edit_font_size,'String','2',...
    'Position',[115 35 35 edit_w]);
do_video_button = uicontrol('Parent',psgroup,'Style','pushbutton','FontSize',button_font_size,...
    'String','PS Video','Position',[180 35 button_len button_w],'Callback',{@do_video_filt});
bg_blue  = uicontrol('Parent',psgroup,'Style','text','FontSize',text_font_size,'String',...
    'Blue BG','Position',[30 8 110 20]);
cbx = uicontrol('Parent',psgroup, 'Style','checkbox',  'Position',[25 2 15 edit_w]);

plot_heat_map_thresh = uicontrol('Parent',psgroup,'Style','pushbutton','FontSize',button_font_size,'String',...
    'Plot heatmap','Position',[180 5 button_len button_w],'Callback',{@plot_heat_map});


set([psgroup,video_thresh,video_thresh_edit,do_video_button,cbx,bg_blue...
    plot_heat_map_thresh],'Units','normalized');


% plot ps over time group
plot_over_time = uibuttongroup('Title','Plot ps over time','FontName',font1,...
    'FontSize',group_font_size,'Position',[0.67 0.465  0.31 .2]);

Rset1 = uicontrol('Parent',plot_over_time,'Style','text','FontSize',text_font_size,'String','Setting 1: ','Position',[5 90 80 edit_w]);
Rset1_mid_text = uicontrol('Parent',plot_over_time,'Style','text','FontSize',text_font_size,'String','< n_rotation <= ','Position',[130 90 110 edit_w]);
low1_edit = uicontrol('Parent',plot_over_time,'Style','edit','FontSize',edit_font_size,'String','0','Position',[85 95 40 edit_w]);
high1_edit = uicontrol('Parent',plot_over_time,'Style','edit','FontSize',edit_font_size,'String','1','Position',[240 95 40 edit_w]);

Rset2 = uicontrol('Parent',plot_over_time,'Style','text','FontSize',text_font_size,'String','Setting 2: ','Position',[5 55 80 edit_w]);
Rset2_mid_text = uicontrol('Parent',plot_over_time,'Style','text','FontSize',text_font_size,'String','< n_rotation <= ','Position',[130 55 110 edit_w]);
low2_edit = uicontrol('Parent',plot_over_time,'Style','edit','FontSize',edit_font_size,'String','1','Position',[85 60 40 edit_w]);
high2_edit = uicontrol('Parent',plot_over_time,'Style','edit','FontSize',edit_font_size,'String','1000','Position',[240 60 40 edit_w]);

plot_time_resoluation_text = uicontrol('Parent',plot_over_time,'Style','text',...
    'FontSize',text_font_size,'String','Window length:','Position',[5 10 90 edit_w]);
plot_time_resoluation_edit = uicontrol('Parent',plot_over_time,'Style','edit',...
    'FontSize',edit_font_size,'String','20','Position',[100 15 40 edit_w]);
ms_text = uicontrol('Parent',plot_over_time,'Style','text',...
    'FontSize',text_font_size,'String','ms','Position',[140 10 30 edit_w]);

plot_over_time_button = uicontrol('Parent',plot_over_time,'Style','pushbutton',...
    'FontSize',button_font_size,'String',...
    'Plot','Position',[180 15 button_len button_w],'Callback',{@plot_ps_over_time});


set([plot_over_time,Rset1,low1_edit,Rset1_mid_text,high1_edit,Rset2,...
    low2_edit,Rset2_mid_text,high2_edit,plot_time_resoluation_text,ms_text,...
    plot_time_resoluation_edit,plot_over_time_button,plot_over_time_button],'Units','normalized');


% wavefront group
wv_group = uipanel('Title','Wavefront','FontName',font1,...
    'FontSize' ,group_font_size,'Position',[.67 .33 0.31 .125]);
% wv_group = uibuttongroup('Parent',p2,'Title','Wavefront','FontName',font1,...
%     'FontSize',group_font_size,'Position',[0.05 0.5 .90 .125]);
IsoP_text = uicontrol('Parent',wv_group,'Style','text','FontSize',text_font_size,'String',....
    'IsoP:','Position',[10 30 55 edit_w],'Callback',{@do_wavefront});
IsoP_text2 = uicontrol('Parent',wv_group,'Style','text','FontSize',text_font_size,'String',....
    'pi/','Position',[90 30 75 edit_w],'Callback',{@do_wavefront});

IsoP_edit = uicontrol('Parent',wv_group,'Style','edit','FontSize',edit_font_size,'String',....
    '4','Position',[135 35 35 edit_w],'Callback',{@do_wavefront});
do_wavefront_button = uicontrol('Parent',wv_group,'Style','pushbutton','FontSize',button_font_size,'String',....
    'Wavefront Video','Position',[10 5 button_len button_w],'Callback',{@do_wavefront});
do_wfdensity_button = uicontrol('Parent',wv_group,'Style','pushbutton','FontSize',button_font_size,'String',....
    'Wavefront Density','Position',[180 5 button_len button_w],'Callback',{@do_wfdense});


% df group

df_group = uipanel('Title','Dominant frequency','FontName',font1,...
    'FontSize' ,group_font_size,'Position',[.67 .195 0.31 .12]);
% df_group = uibuttongroup('Parent',p2,'Title','Dominant frequency map','FontName',font1,...
%     'FontSize',group_font_size,'Position',[0.05 0.12 .90 .125]);
DF_freq = uicontrol('Parent',df_group,'Style','text','FontSize',text_font_size,...
    'String','Frequency range: ','Position',[10 25 120 edit_w]);
df_low_edit = uicontrol('Parent',df_group,'Style','edit','FontSize',edit_font_size,'String','20','Position',[125 30 40 edit_w]);
Rset1_mid_text = uicontrol('Parent',df_group,'Style','text','FontSize',text_font_size,'String','~ ','Position',[175 25 10 edit_w]);
df_hgih_edit = uicontrol('Parent',df_group,'Style','edit','FontSize',text_font_size,'String','50','Position',[190 30 40 edit_w]);
Rsethz_text = uicontrol('Parent',df_group,'Style','text','FontSize',text_font_size,'String','Hz ','Position',[235 25 30 edit_w]);
df_button = uicontrol('Parent',df_group,'Style','pushbutton','FontSize',button_font_size,'String',...
    'Plot DF','Position',[90 2.5 button_len 25],'Callback',{@plot_df});


se_group = uipanel('Title','Shannon Entropy','FontName',font1,...
    'FontSize' ,group_font_size,'Position',[.67 .110 0.31 .075]);
se_button = uicontrol('Parent',se_group,'Style','pushbutton','FontSize',button_font_size,'String',...
    'Plot shEn Map','Position',[90 2.5 button_len 22.5],'Callback',{@plot_shEn});

hm_group = uipanel('Title','Harmonic Map','FontName',font1,...
    'FontSize' ,group_font_size,'Position',[.67 .01  0.31 .085]);
f_wid  = uicontrol('Parent',hm_group,'Style','text','FontSize',...
    text_font_size,'String','band_width:','Position',[10 0.5  80 edit_w]);
f_wid_edit = uicontrol('Parent',hm_group,'Style','edit','FontSize',....
    edit_font_size,'String','0.75','Position',[90 2.5 35 edit_w]);
wid_hz_text  = uicontrol('Parent',hm_group,'Style','text','FontSize',...
    text_font_size,'String','Hz','Position',[130 0.5  20 edit_w]);

hm_button = uicontrol('Parent',hm_group,'Style','pushbutton','FontSize',button_font_size,'String',...
    'Plot Harmonic OI','Position',[170 2.5 button_len button_w],'Callback',{@plot_harmonic});


set([df_group,DF_freq,df_low_edit,se_group...
    do_wavefront_button,IsoP_text,IsoP_text2,IsoP_edit,do_wfdensity_button,...
    wv_group,Rset1_mid_text,Rsethz_text,...
    df_hgih_edit,df_button,hm_button,...
    hm_group,f_wid,f_wid_edit,se_button,wid_hz_text],'Units','normalized');




% movegui(f,'northwest')
set(f,'Visible','on')



%% Define Handles
handles.filename = [];
handles.samplingrate = [];
handles.bg = [];

handles.dispData = [];
handles.time = [];
handles.wave_window = 1;
handles.wave_window2 = 1;
handles.normflag = 0;
handles.starttime = [];
handles.endtime = [];

handles.raw_data0 = [];
handles.dir = [];

% -------------------------------
%% List that contains all files in directory
    function filelist_callback(source,eventdata)
        str = get(source, 'String');
        val = get(source,'Value');
        file = char(str(val));
        %         handles.filename = file;
    end
%% Select directory for optical files
% find .da and .tif filenames according to keywords

    function selectdir_callback(source,eventdata)
        dir_name = uigetdir;
        handles.dir = dir_name;
        
        data_filenames=dir(handles.dir);
        
        files = struct2cell(data_filenames);
        handles.file_list = files(1,:)';
        set(filelist,'String',handles.file_list)
        
        file_keyword = get(file_keyword_edit,'String');
        
        
        ResultsFolder = ['Result_',file_keyword,'_',datestr(now, 'HHMM_yymmdd') ];
        mkdir([handles.dir,'/',ResultsFolder])
        
        addpath(handles.dir)
        
        handles.ResultsFolder = [handles.dir,'/',ResultsFolder];
    end
%% Refresh file list
    function refreshdir_callback(source,eventdata)
        dir_name = handles.dir;
        search_name = [dir_name,''];
        files = struct2cell(dir(search_name));
        handles.file_list = files(1,:)';
        set(filelist,'String',handles.file_list)
        %         handles.filename = char(handles.file_list(1));
    end



%% Load selected da files
    function load_da_data(source,eventdata)
        
        if   ~isfield(handles,'ResultsFolder')
            errordlg('Select a path for ResultsFolder, please.')
        else
            
            da_file_name = uigetfile('*.da',[],handles.dir);
            
            if ~isempty(strfind(da_file_name,'10s'))
                data_format = 2;
            else
                data_format = 1;
            end
            
            start_time = str2num(get(start_time_edit,'String'));
            end_time = str2num(get(end_time_edit,'String'));
            
            Fs = str2num(get(Fs_edit,'String'));
            start_time = floor(start_time/1000*Fs);
            end_time = floor(end_time/1000*Fs);
            if start_time < 1
                start_time = 1;
            end
            [raw_data, samplingrate ]= DAconvert_gui(da_file_name,start_time,end_time,data_format);
            [n_row, n_col, n_t] = size(raw_data);
            handles.n_row = n_row;
            handles.n_col = n_col;
            
            if n_t>=end_time
                handles.raw_data0 = raw_data(:,:,start_time:end_time);
            else
                warndlg('The raw data is shorter than end_time. Load data from start_time to the end.')
                handles.raw_data0 = raw_data(:,:,start_time:end);
                end_time = n_t;
            end
            
            handles.samplingrate = samplingrate;
            handles.start_time = start_time;
            handles.end_time = end_time;
            handles.Fs = Fs;
            filename0='RawData.mat';
            handles.filename = da_file_name;
            %         save([handles.dir,'/final_filtered_data.mat'], 'final_filtered_data');
            
            msg_str = sprintf('Data size: %d rows, %d columns and %d timepoints. ',size(handles.raw_data0));
            msgbox(msg_str)
            save([ handles.ResultsFolder,'/',filename0], 'raw_data','Fs',...
                'start_time','end_time','da_file_name','-v7.3')
        end
    end
%% Load selected mat files
    function load_mat_data(source,eventdata)
        
        if   ~isfield(handles,'ResultsFolder')
            errordlg('Select a path for ResultsFolder, please.')
        else
            mat_file_name = uigetfile('*.mat',[],handles.dir);
            
            start_time = str2num(get(start_time_edit,'String'));
            end_time = str2num(get(end_time_edit,'String'));
            Fs = str2num(get(Fs_edit,'String'));
            start_time = floor(start_time/1000*Fs);
            end_time = floor(end_time/1000*Fs);
            if start_time < 1
                start_time = 1;
            end
            
            raw_data = importdata(mat_file_name);
            [n_row, n_col, n_t] = size(raw_data);
            handles.n_row = n_row;
            handles.n_col = n_col;
            
            if n_t>=end_time
                handles.raw_data0 = raw_data(:,:,start_time:end_time);
            else
                warndlg('The raw data is shorter than end_time. Load data from start_time to the end.')
                handles.raw_data0 = raw_data(:,:,start_time:end);
                end_time = n_t;
            end
            handles.start_time = start_time;
            handles.end_time = end_time;
            
            filename0='RawData.mat';
            
            handles.Fs = Fs;
            handles.filename = mat_file_name;
            %         save([handles.dir,'/final_filtered_data.mat'], 'final_filtered_data');
            
            msg_str = sprintf('Data size: %d rows, %d columns and %d timepoints. ',size(handles.raw_data0));
            msgbox(msg_str)
            save([ handles.ResultsFolder,'/',filename0], 'raw_data','Fs',...
                'start_time','end_time','mat_file_name','-v7.3')
        end
    end
%% Load selected background .tif files
    function load_bg_data(source,eventdata)
        
        if   ~isfield(handles,'ResultsFolder')
            errordlg('Select a path for ResultsFolder, please.')
        else
            if   isfield(handles,'n_row')
                
                nameoftif = uigetfile('*.tif',[],handles.dir);
                bg_data = imread(nameoftif);
                bg_data = double(bg_data);
                
                
                bg_data = bg_data (:,81:160);
                [n_row, n_col] = size(bg_data);
                
                if (n_row ==  handles.n_row) && (n_col ==  handles.n_col)
                    handles.bg=bg_data;
                    filename0='BG.mat';
                    
                    save([ handles.ResultsFolder,'/',filename0], 'bg_data','-v7.3')
                    
                    BG = mat2gray(bg_data);
                    hold on
                    daspect([1 1 1])
                    H1=imshow(BG,'Parent',movie_scrn);
                    axis image
                    hold on
                    [edge_r, edge_c] = find(edge(mean(handles.raw_data0,3)));
                    for iitemp = 1:length(edge_r)
                        plot(edge_c(iitemp),edge_r(iitemp),'b.')
                    end
                    
                    msg_str = sprintf('BG size: %d rows and %d columns.',size(handles.bg));
                    msgbox(msg_str)
                    
                else
                    errordlg('The size of the data is not the same as BG! Re-load data or BG!')
                end
                
            else
                errordlg('Please load the data first!')
                
            end
        end
    end
%% Load selected background .mat files
    function load_bgmat_data(source,eventdata)
        
        if   ~isfield(handles,'ResultsFolder')
            errordlg('Select a path for ResultsFolder, please.')
        else
            if   isfield(handles,'n_row')
                nameofbg = uigetfile('*.mat',[],handles.dir);;
                bg_data =  importdata(nameofbg);
                [n_row, n_col] = size(bg_data);
                
                if (n_row ==  handles.n_row) && (n_col ==  handles.n_col)
                    
                    BG = mat2gray(bg_data);
                    hold on
                    daspect([1 1 1])
                    H1=imshow(BG,'Parent',movie_scrn);
                    axis image
                    hold on
                    [edge_r, edge_c] = find(edge(mean(handles.raw_data0,3)));
                    for iitemp = 1:length(edge_r)
                        plot(edge_c(iitemp),edge_r(iitemp),'b.')
                    end
                    handles.bg=bg_data;
                    filename0='BG.mat';
                    msg_str = sprintf('BG size: %d rows and %d columns.',size(handles.bg));
                    msgbox(msg_str)
                    save([ handles.ResultsFolder,'/',filename0], 'bg_data','-v7.3')
                    
                else
                    errordlg('The size of the data is not the same as BG! Re-load data or BG!')
                end
            else
                errordlg('Please load the data first!')
                
            end
        end
    end

%% Load selected files in filelist
    function preprocess_data(source,eventdata)
        
        if   (~isempty(handles.raw_data0)) && (~isempty(handles.bg))
            %         thresholding the bg
            g = waitbar(0,'Binning and filtering...');
            Fs = handles.Fs;
            bg_thresh = str2num(get(bg_thresh_edit,'String'));
            perc_ex = str2num(get(perc_ex_edit,'String'));
            
            bin_size = str2num(get(bin_size_edit,'String'));
            n_bin_size = str2num(get(nbin_edit,'String'));
            [data_binned,mask] = bin_data2(handles.raw_data0, handles.bg, n_bin_size, bin_size, bg_thresh, perc_ex);
            
            waitbar(4/10,g)
            
            hb = str2num(get(filt_high_edit,'String'));
            lb = str2num(get(filt_low_edit,'String'));
            
            a0 = [1 1 0 0];
            a = 1;
            f_order = 100;
            filtered_data0 = filt_op_data(data_binned, mask, Fs ,lb, hb, f_order, a0, a);
            waitbar(5/10,g)
            %         figure
            %         plot(squeeze(filtered_data0(46,58,:)))
            maxf = find_freq_max(filtered_data0, Fs);
            % dominant frequency of the selected pixel
            
            %         do the 2nd low pass filtering using the dominant frequency of the selected pixel
            bin_size2 = 9;
            [data_binned,mask] = bin_data(handles.raw_data0, handles.bg, bin_size2, bg_thresh, perc_ex);
            waitbar(6/10,g)
            xpixel=floor(size(data_binned,2)/2);%around center pixel
            ypixel=floor(size(data_binned,1)/2);%around center pixel
            hbDF=maxf(ypixel, xpixel);
            %         hbDF = max(maxf(maxf>0));
            hbpercent = 1.25;
            lb2 = 2;
            hb2 = hbDF * hbpercent;
            if hb2 < Fs/2*0.9;
                filtered_data = filt_op_data(data_binned, mask, Fs ,lb2, hb2, f_order, a0, a);
            else
                filtered_data = data_binned;
            end
            waitbar(7/10,g)
            data_driftremoved = remove_drift(filtered_data);
            waitbar(8/10,g)
            final_filtered_data = normalize_data(data_driftremoved,mask);
            waitbar(9/10,g)
            maxf = find_freq_max(filtered_data, Fs);
            
            
            MiddlePixCL=Fs/maxf(ypixel, xpixel);
            %         save the second binned and filtered data
            filename1='FinalFilteredData.mat';
            filename0=handles.filename;
            
            %         save([handles.dir,'/final_filtered_data.mat'], 'final_filtered_data');
            
            start_time = handles.start_time;
            end_time = handles.end_time;
            handles.hbDF = hbDF;
            bg_data = handles.bg;
            
            save([ handles.ResultsFolder,'/',filename1], 'final_filtered_data','Fs','MiddlePixCL',...
                'start_time','end_time','filename0','hb2', 'lb2', 'hbDF', 'bg_data', 'bin_size2','-v7.3')
            waitbar(10/10,g)
            delete(g)
            
        else
            h = errordlg('You did not load any raw data and bachground!');
            %             set(gca, 'FontName','ChalkBoard','FontSize',20)
            set(h, 'position', [800  540 480 100]); %makes box bigger
            htext = findobj(h, 'Type', 'Text');  %find text control in dialog
            htext.FontSize = 20;     %set fontsize to whatever you want
        end
        
    end
%% Select directory for filtered optical mapping data
%  voltFinalFiltered.mat

    function selectdir_callback2(source,eventdata)
        
        if ~isempty(handles.dir)
            dir_name = uigetdir(handles.dir);
        else
            dir_name = uigetdir;
        end
        handles.dir2 = dir_name;
        
        data_filenames=dir(handles.dir2);
        
        files = struct2cell(data_filenames);
        handles.file_list2 = files(1,:)';
        set(filelist2,'String',handles.file_list2)
        
        
        for i = 1:length(data_filenames)
            
            if  ~isempty(strfind(data_filenames(i).name, 'FinalFilteredData'))
                filename = data_filenames(i).name;
                handles.filename2 = [handles.dir2,'/',filename];
            end
            if  ~isempty(strfind(data_filenames(i).name, 'rawphaseresults'))
                filename = data_filenames(i).name;
                handles.filename3 = [handles.dir2,'/',filename];
            end
            if  ~isempty(strfind(data_filenames(i).name, 'Rotation_info'))
                filename = data_filenames(i).name;
                handles.filename4 = [handles.dir2,'/',filename];
            end
        end
    end
%% List that contains all files in the RESULTS directory
    function filelist_callback2(source,eventdata)
        str = get(source, 'String');
        val = get(source,'Value');
        file = char(str(val));
        %         handles.filename = file;
    end

%% Refresh RESULTS file list
    function refreshdir_callback2(source,eventdata)
        dir_name = handles.dir2;
        search_name = [dir_name,''];
        files = struct2cell(dir(search_name));
        handles.file_list2 = files(1,:)';
        set(filelist2,'String',handles.file_list2)
        handles.filename = char(handles.file_list2(1));
    end
%%
    function do_phase(source,eventdata)
        if   isfield(handles,'filename2')
            filtered_results = load(handles.filename2);
            filtered_data = filtered_results.final_filtered_data;
            
            Fs = filtered_results.Fs;
            MiddlePixCL = filtered_results.MiddlePixCL;
            
            
            winCL=MiddlePixCL;
            win=ceil(winCL/2);
            Xpixamp=floor(size(filtered_data,2)/2); 
            Ypixamp=floor(size(filtered_data,1)/2); 
            datapoint=squeeze(filtered_data(Ypixamp, Xpixamp, :));
            B=datapoint';
            
            [minpos, maxpos] = find_minmax_pos(B,win);
            
            ampmed = get_amp_median(datapoint,maxpos, minpos);
            %       some built in parameters
            ampcombocol=15;
            WLcombocol=90;
            ampthres=ampmed*(ampcombocol/100);
            
            winCL=WLcombocol;
            winCL=MiddlePixCL*winCL/100;
            win=ceil(winCL/2);
            
            filtered_data = filtered_data(:,:,10:end);
            [phase2,meanlineall,...
                maxposall, countmaxima,...
                medCL, meanCL, STDCL,...
                amp1all, amp2all, ampminall] = get_phase(filtered_data,win,ampthres);
            
            
            
            %     process phase for ps detection
            phase_bin_size = str2num(get(bin_size_edit2,'String'));
            
            N=phase_bin_size;
            avePattern = ones(N,N);
            phase_data=phase2;
            data_binned=phase_data; data_binned(:)=0;
            g = waitbar(0,'Smoothing phase data...');
            
            for ind_t = 1:size(phase_data,3)
                waitbar(ind_t/size(phase_data,1),g);
                %             smoothing phase data
                temp1 = phase_data(:,:,ind_t);
                counts=double(isfinite(temp1));
                no_non0=conv2(counts, avePattern, 'same');
                temp=exp(1i*temp1); temp(isnan(temp))=0;
                temp =conv2(temp,avePattern,'same')./no_non0; temp(isnan(temp1))=nan;
                temp=angle(temp);
                data_binned(:,:,ind_t) = temp;
            end
            
            delete(g)
            
            phasesmoothed=data_binned;
            
            [call,rall,callb,rallb] =  ps_detection(phasesmoothed);
            
            % calculate duration and locations of all ps
            %  ps_info contains two cell: anti-clockwise and clockwise
            % each cell contains a n_ps-by-5 matrix
            % each row corresponds to one ps at one loc at one time
            % 1-2: x- y- of the ps loc
            % 3: t
            % 4: ps id at current time
            % 5: ps id
            % after counting the number of rotations the
            % the number of rotations will be added to the 6-th col
            
            rotor_gap_thresh = str2num(get(move_thresh_edit,'String'));
            temporal_gap_thresh = str2num(get(t_thresh_edit,'String'));
            
            if isempty(call)
                ps_info = {{},{}};
                ps_duration = {{},{}};
                warndlg('NO PS found in this data set.')
            else
                [ps_info{1}, ps_duration{1}] = get_ps_info(call, rall, rotor_gap_thresh,temporal_gap_thresh );
                [ps_info{2}, ps_duration{2}] = get_ps_info(callb, rallb,rotor_gap_thresh,temporal_gap_thresh );
                %             change time samples to ms
                ps_duration{1} = ps_duration{1}./Fs*1000;
                ps_duration{2} = ps_duration{2}./Fs*1000;
                
            end
            
            filename3='rawphaseresults.mat';
            save([handles.dir2,'/',filename3], 'phase_data','phasesmoothed','ps_info','ps_duration',...
                'call','rall','callb','rallb','-v7.3')
            handles.filename3 = [handles.dir2,'/',filename3];
        else
            errordlg('Select a valid result folder with final filtered data, please.')
        end
    end
%%
    function do_rotor(source,eventdata)
        %         quantification of rotors
        
        if   isfield(handles,'filename3')
            raw_results = load(handles.filename2);
            phase_results = load(handles.filename3);
            
            %  parameters for rotation count
            n_su_points = str2num(get(n_neighbour_edit,'String'));
            
            gap_thresh =  str2num(get(gap_thresh_edit,'String'));
            
            if isempty(phase_results.ps_duration{1}) && isempty(phase_results.ps_duration{1})
                warndlg('NO PS found in this data set.')
            else
                ps_duration = phase_results.ps_duration;
                ps_info = phase_results.ps_info;
                hbDF = raw_results.hbDF;
                Fs = raw_results.Fs;
                win = floor( Fs/raw_results.hbDF/2);
                
                %             n_rot_thresh =  str2num(get(rotor_thresh_edit,'String'));
                n_rot_thresh = 1;
                major_ps_index = cell(2,1);
                
                for ps_tyindex = 1:2
                    major_ps_index{ps_tyindex} = find(ps_duration{ps_tyindex}*hbDF/1000 > n_rot_thresh  );
                end
                
                g = waitbar(0,'Calculating PS statistics...');
                %  count number of rotations
                % major_ps_info contains two cell: anti-clockwise and clockwise
                % each cell contains a n_ps-by-10 matrix
                % each row corresponds to one ps
                % column 1: ps ID
                % 2-3: x- y- of the average ps loc
                % 4-5: x- y- of the std of ps loc
                % 6-7: x- y- of the shift of ps loc
                % 8, 9, 10:  duration, number and frequency of rotations
                % 8, 9, 10 would be NAN if no edge detected (usually happen for ps at the
                % edge of the image)
                major_ps_info = cell(2,1);
                for ps_tyindex =  1:2
                    
                    major_ps_info{ps_tyindex} = nan(length(ps_duration{ps_tyindex}),10);
                    
                    for ii =  1:length( ps_duration{ps_tyindex})
                        
                        k_ps_id = ii;
                        
                        k_ps_duration = ps_duration{ps_tyindex}(k_ps_id);
                        k_ps_index = find(ps_info{ps_tyindex}(:,5)==k_ps_id);
                        
                        ps_center = ps_info{ps_tyindex}(k_ps_index , 1:2);
                        ps_time_index =  ps_info{ps_tyindex}(k_ps_index , 3);
                        
                        major_ps_info{ps_tyindex}(ii,1) = k_ps_id;
                        major_ps_info{ps_tyindex}(ii,2:3) = mean(ps_center);
                        major_ps_info{ps_tyindex}(ii,4:5) = std(ps_center);
                        major_ps_info{ps_tyindex}(ii,6:7) = abs(ps_center(1,:)-ps_center(end,:));
                        major_ps_info{ps_tyindex}(ii,8) = k_ps_duration;
                        
                        % only count accurate rotation number if the ps last over
                        % 2 Domain Cycle; 1 Domain Cycle = hbDF/1000
                        
                        if k_ps_duration > Fs/(hbDF)*2
                            [edge_vec, ~] = get_edgevector(phase_results.phasesmoothed,ps_time_index,ps_center, ...
                                n_su_points,gap_thresh );
                            
                            if size(edge_vec ,1)>0
                                [edge_distance]  = get_edge_distance(edge_vec);
                                s_edge_distance = smooth(edge_distance(~isnan(edge_distance)),5);
                                [minpos,n_rotaion] = count_rotation(s_edge_distance, win);
                                r_f = Fs*n_rotaion/(k_ps_duration);
                                major_ps_info{ps_tyindex}(ii,9) = n_rotaion;
                                major_ps_info{ps_tyindex}(ii,10) = r_f;
                            end
                            
                        else
                            if k_ps_duration > Fs/(hbDF)
                                major_ps_info{ps_tyindex}(ii,9) = 1;
                            else
                                major_ps_info{ps_tyindex}(ii,9) = 0;
                            end
                            
                        end
                        waitbar(ii/length(ps_duration{ps_tyindex})*0.5+(ps_tyindex-1)*0.5,g)
                    end
                end
                delete(g)
                
                for ps_tyindex =  1:2
                    
                    ps_info{ps_tyindex} = [ps_info{ps_tyindex}(:,1:5), ...
                        zeros(size( ps_info{ps_tyindex},1),1)];
                    for ps_id =  1:length(unique(ps_info{ps_tyindex}(:,5)))
                        
                        ps_info{ps_tyindex}((ps_info{ps_tyindex}(:,5) == ps_id),6) = ...
                            major_ps_info{ps_tyindex}...
                            (major_ps_info{ps_tyindex}(:,1)==ps_id,9);
                        %         ps_id,major_ps_info{ps_tyindex}(major_ps_info{ps_tyindex}(:,1)==ps_id,9)
                    end
                end
                
                
                ResultsFolder = handles.dir2;
                filename4 = 'Rotation_info.mat';
                %% plot duration and n_rotation hist
                ht = figure('Name','Hist of duration');
                ddT = [major_ps_info{1}(:,8); major_ps_info{2}(:,8)];
                T = round((size(phase_results.phasesmoothed,3) )/Fs*1000);
                l_str = sprintf('Histogram of number of ps over %d ms',T);
                %             histogram(ddT,'Normalization','probability')
                histogram(ddT )
                xlabel('PS duration (ms)')
                title(l_str)
                max_duration = max( ddT(~isnan(ddT)));
                grid on
                xlim([0 max_duration+50])
                set(gca,'FontName','Times','FontSize',30)
                
                hn = figure('Name','Hist of number of rotations');
                ddn = [major_ps_info{1}(:,9); major_ps_info{2}(:,9)];
                histogram(ddn,0:1:max(ddn)+1)
                xlabel('Number of full rotations')
                title(l_str)
                xlim([0 max(ddn)+5])
                max_rotations =  max(ddn(~isnan(ddn)));
                grid on
                set(gca,'FontName','Times','FontSize',30);
                
                savefig(ht,[ResultsFolder,'/Duration_hist.fig'])
                savefig(hn,[ResultsFolder,'/n_rotation_hist.fig'])
                
                %%
                
                fileID = fopen([ResultsFolder,'/rotation_info.txt'],'w');
                fprintf(fileID,'Type,   ID,     col-center,   row-center,    col-std,    row-std,     col-shift,    row-shift,    duration(in sample),     n-rotation,    rotation-freq  \n');
                for type =1:2
                    temp_data = [type*ones(size( major_ps_info{type},1),1), major_ps_info{type}];
                    formatSpec = '%d,   %d,  %4.2f,  %4.2f,  %4.2f,   %4.2f,   %d,   %d,   %d,   %d,   %4.2f  \n';
                    fprintf(fileID,formatSpec,temp_data');
                end
                
                all_major_ps_info = [major_ps_info{1};major_ps_info{2}];
                n_ps = size(all_major_ps_info,1);
                all_major_ps_info = all_major_ps_info(~isnan(all_major_ps_info(:,10)),:);
                all_major_ps_info = all_major_ps_info(:,2:end);
                n_ps2 = size(all_major_ps_info,1);
                formatSpec = 'Max (of ps with over 2 rotations),  %4.2f,  %4.2f,  %4.2f,   %4.2f,   %d,   %d,   %d,   %d,   %4.2f  \n';
                max_values = max(all_major_ps_info);
                fprintf(fileID,formatSpec,max_values');
                formatSpec = 'Mean (of ps with over 2 rotations),  %4.2f,  %4.2f,  %4.2f,   %4.2f,   %d,   %d,   %d,   %d,   %4.2f  \n';
                ave_values = mean(all_major_ps_info);
                fprintf(fileID,formatSpec,ave_values');
                
                
                %%
               
               
                
                all_locs = [ps_info{1}(:,1:2);ps_info{2}(:,1:2)];
                temp_loc_index = sub2ind(size(raw_results.bg_data),all_locs(:,2),all_locs(:,1));
                n_l = length(unique(temp_loc_index));
                all_locs2 = [ps_info{1}(ps_info{1}(:,6)>1,1:2);ps_info{2}(ps_info{2}(:,6)>1,1:2)];
                temp_loc_index2 = sub2ind(size(raw_results.bg_data),all_locs2(:,2),all_locs2(:,1));
                n_l2 = length(unique(temp_loc_index2));
                
                textLabel = sprintf('%d', n_ps);
                set(nps_edit, 'String', textLabel);
                
                textLabel = sprintf('%d', n_ps2);
                set(nps_edit2, 'String', textLabel);
                
                textLabel = sprintf('%d', n_l);
                set(nl_edit, 'String', textLabel);
                
                textLabel = sprintf('%d', n_l2);
                set(nl_edit2, 'String', textLabel);
                
                textLabel = sprintf('%d', max_duration);
                set(mdt_edit, 'String', textLabel);
                
                textLabel = sprintf('%d', max_rotations);
                set(mrt_edit, 'String', textLabel);
                
                formatSpec = 'n_ps = %d, n_ps2 = %d, n_l = %d, n_l2 = %d  \n';
                fprintf(fileID,formatSpec,[n_ps,n_ps2, n_l, n_l2]);
                fclose(fileID);
                %%
                save([ResultsFolder,'/',filename4], 'major_ps_info', 'ps_info', 'n_su_points', 'hbDF', 'gap_thresh')
                handles.filename4 = [handles.dir2,'/',filename4];
                msgbox('Rotational activity quantification done.')
            end
        else
            errordlg('Calculate the phase first, please.')
        end
    end
%%
    function plot_ps_over_time(source,eventdata)
        
        if   isfield(handles,'filename4')
            
            raw_results = load(handles.filename2);
            Fs = raw_results.Fs;
            ps_results = load(handles.filename4);
            ps_info = ps_results.ps_info;
            
            
            ps_thresh_low = [str2num(get(low1_edit,'String')),str2num(get(low2_edit,'String'))];
            ps_thresh_high = [str2num(get(high1_edit,'String')),str2num(get(high2_edit,'String'))];
            
            start_time= raw_results.start_time;
            end_time = raw_results.end_time;
            time_resoluation =  str2num(get(plot_time_resoluation_edit,'String')) ; %in ms
            time_resoluation = time_resoluation/1000*Fs;
            %         T_end = max([end_time-start_time,max(ps_info{1}(:,3)),max(ps_info{1}(:,3))]);
            ResultsFolder = handles.dir2;
            [fhtt, fhtr] = polt_nr_overtime_gui(ps_info, start_time,end_time,ps_thresh_low,ps_thresh_high,...
                time_resoluation, Fs, raw_results.bg_data);
            savefig(fhtt,[ResultsFolder,'/lps_overtime.fig'])
            savefig(fhtr,[ResultsFolder,'/nps_overtime.fig'])
            
        else
            errordlg('Do the quantification first, please.')
        end
    end

%%
    function plot_df(source,eventdata)
        
        if   isfield(handles,'filename2')
            raw_results = load(handles.filename2);
            data = raw_results.final_filtered_data;
            fmin = str2num(get(df_low_edit,'String'));
            fmax = str2num(get(df_hgih_edit,'String'));
            Fs = raw_results.Fs;
            
            % %  Produce mean-zero data
            data = data - repmat(mean(data,3),1,1,size(data,3));
            % % Fourier Transform
            m = size(data,3);  % window length
            nfft = pow2(nextpow2(m));  % transform length
            y = fft(data,nfft,3);  % Fast Fourier Transform (FFT)
            P2 = abs(y.^2);
            P1 = P2(:,:,1:1+(nfft/2)); %remove half of the array (FFT is always duplicated)
            f_scale=(0:nfft/2)* Fs/nfft; %Get the Hz scale of the data produced by the FFT
            for i=1:size(P1,1) %Apply the filter determined in the input and remove the freqs from the spectra
                for j=1:size(P1,2)
                    P1(i,j,f_scale <fmin) = NaN;
                    P1(i,j,f_scale >fmax) = NaN;
                end
            end
            %Remove those values also in the f_scale
            f_scale(f_scale<fmin)=NaN;
            f_scale(f_scale>fmax)=NaN;
            [v,k] = max(P1,[],3);  % find maximum FFT values
            q=k(:); q(q==1)=NaN; %Remove freq 0 values
            b=mode(q);
            Freq = f_scale(b);  % dominant frequency (convert FFT values into frequencies)
            domfreq = f_scale(k).*isfinite(v);  % dominant frequency (convert FFT values into frequencies)
            domfreq0  = domfreq;
            domfreq(domfreq==0) = nan; %Transform pixels outside the heart into NaN
            
            
            % % Dominant Frequency Map
            %Just regular plotting stuff
            hdf = figure('Name','DF');
            domfreq(isnan(domfreq))= min(domfreq(~isnan(domfreq)))-1;
            imagesc(domfreq)
            colordata = colormap('jet');
            colordata(1,:)=[1 1 1];
            colormap(colordata)
            
            axis image
            axis off
            C=colorbar;
            set(C, 'fontsize',14);
            xlabel(C,'(Hz)','FontSize',14,'FontName','Times');
            set(gca,'FontName','Times','FontSize',20)
            
            hoi = figure('Name','Dominant Frequency-His');
            
            domfreq1 = domfreq0(domfreq0>0);
            [c,fc] = hist(domfreq1(:),Fs/2,'Normalization','Probability');
            histogram(domfreq1(:),Fs/2,'Normalization','Probability');
            axis([fmin fmax 0 1]) %Set the axis to the freq limits
            xlabel('Hz')
            %             box off
            grid on
            set(gca,'FontName','Times','FontSize',30)
            oi =  max(c)/numel(domfreq1);
            title(['OI = ',num2str(oi)]);
            ResultsFolder = handles.dir2;
            savefig(hdf,[ResultsFolder,'/DF.fig'])
            savefig(hoi,[ResultsFolder,'/DF_hist.fig'])
        else
            errordlg('Select a valid result folder with final filtered data, please.')
        end
    end
%%
    function plot_harmonic(source,eventdata)
        
        if   isfield(handles,'filename2')
            raw_results = load(handles.filename2);
            data = raw_results.final_filtered_data;
            
            band_width = str2num(get(f_wid_edit,'String'));
            Fs = raw_results.Fs;
            
            % %  Produce mean-zero data
            data = data - repmat(mean(data,3),1,1,size(data,3));
            % % Fourier Transform
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
            
            band_low = freq_max1 - band_width/2;
            idx_df =  (f1 > repmat(freq_max1 - band_width/2,1,size(f1,2)))...
                &(f1 < repmat(freq_max1 + band_width/2,1,size(f1,2)));
            idx_h1 =  (f1 > repmat(freq_max1*2 - band_width/2,1,size(f1,2)))...
                &(f1 < repmat(freq_max1*2 + band_width/2,1,size(f1,2)));
            peak_area = (sum(p_s1.*idx_df,2)+sum(p_s1.*idx_h1,2))./sum(p_s1,2);
            df_oi = reshape(peak_area,size(freq_max0));
            
            
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
            set(C, 'fontsize',30);
            % xlabel(C,'(Hz)','FontSize',14,'FontName','Times');
            set(gca,'FontName','Times','FontSize',30)
            
            ResultsFolder = handles.dir2;
            savefig(hh,[ResultsFolder,'/Harmonic_OI.fig'])
            
        else
            errordlg('Select a valid result folder with final filtered data, please.')
        end
    end

%%
    function plot_shEn(source,eventdata)
        
        if   isfield(handles,'filename2')
            raw_results = load(handles.filename2);
            data = raw_results.final_filtered_data;
            fmin = str2num(get(df_low_edit,'String'));
            fmax = str2num(get(df_hgih_edit,'String'));
            Fs = raw_results.Fs;
            
            % %  Produce mean-zero data
            data = data - repmat(mean(data,3),1,1,size(data,3));
            
            ShanEnLocal = nan(size(data,1),size(data,2));
            
            %
            for ii = 1:size(data,1)
                for jj = 1:size(data,2)
                    temp_data = squeeze(data(ii,jj,:));
                    if ~isnan(sum(temp_data))
                        ShanEnLocal(ii,jj) = wentropy(temp_data,'shannon');
                    end
                end
            end
            
            % % Dominant Frequency Map
            %Just regular plotting stuff
            shEn = figure('Name','ShEn');
            
            imagesc(ShanEnLocal)
            colordata = colormap('jet');
            colordata(1,:)=[1 1 1];
            colormap(colordata)
            
            axis image
            axis off
            C=colorbar;
            set(C, 'fontsize',30);
            set(gca,'FontName','Times','FontSize',30)
            
            ResultsFolder = handles.dir2;
            savefig(shEn,[ResultsFolder,'/ShEn.fig'])
        else
            errordlg('Select a valid result folder with final filtered data, please.')
        end
    end

%%
    function do_video_filt(source,eventdata)
        if   isfield(handles,'filename4')
            hh = warndlg('Please do NOT click other matlab figures while the video is being genereated!');
            uiwait(hh);
            n_rot_thresh = str2num(get(video_thresh_edit,'String'));
            %         raw_results = load(handles.filename2);
            phase_results = load(handles.filename3);
            rotor_results = load(handles.filename4);
            
            phasesmoothed = phase_results.phasesmoothed;
            major_ps_info = rotor_results.major_ps_info;
            ps_info = rotor_results.ps_info;
            t_start = 1;
            t_end =  size(phasesmoothed,3);
            video_quality = 100;
            video_framerate = 10;
            
            file_name = [ handles.dir2,'/ps_video_filt'];
            
            creat_gui_ps_video(phasesmoothed, ...
                ps_info, major_ps_info, ...
                n_rot_thresh, t_start, t_end,...
                file_name,video_quality,video_framerate)
        else
            warndlg('NO PS Found or No Quantiication performed. Generate only phase video')
            phase_results = load(handles.filename3);
            phasesmoothed = phase_results.phasesmoothed;
            
            file_name = [ handles.dir2,'/phase_video']; 
            t_start = 1;
            t_end =  size(phasesmoothed,3);
            video_quality = 100;
            video_framerate = 10;
            creat_gui_phase_video(phasesmoothed,t_start, t_end,...
                file_name,video_quality,video_framerate)
        end
    end

%%

    function plot_heat_map(source,eventdata)
        if   isfield(handles,'filename4')
            n_rotation_thresh = str2num(get(video_thresh_edit,'String'));
            raw_results = load(handles.filename2,'final_filtered_data','Fs','bg_data');
            phase_results = load(handles.filename3,'phasesmoothed');
            rotor_results = load(handles.filename4,'ps_info');
            c_lim = [-0.001 0.05];
            
            bg_flag = get(cbx,'value');
            heat_handels = ps_heat_map_gui(n_rotation_thresh,...
                phase_results.phasesmoothed,rotor_results.ps_info,raw_results.bg_data,bg_flag,c_lim);
            ResultsFolder = handles.dir2;
            savefig(heat_handels,[ResultsFolder,'/heatmap_',num2str(n_rotation_thresh),'.fig'])
        else
            errordlg('Do the Quantification first, please.')
        end
    end
%%
    function plot_path(source,eventdata)
        
        if   isfield(handles,'filename4')
            phase_results = load(handles.filename3,'ps_duration');
            rotor_results = load(handles.filename4,'ps_info');
            raw_results = load(handles.filename2,'final_filtered_data','bg_data');
            ps_duration = phase_results.ps_duration;
            bg_flag = get(cbx1,'value');
            if max(ps_duration{1})> max(ps_duration{2})
                k_ps_id  = find(ps_duration{1}==max(ps_duration{1}));
                k_ps_duration = ps_duration{1}(k_ps_id);
                k_ps_id = k_ps_id(1);
                k_ps_index = find(rotor_results.ps_info{1}(:,5)==k_ps_id);
                ps_time_index =  rotor_results.ps_info{1}(k_ps_index , 3);
                ps_info_temp = rotor_results.ps_info{1}(k_ps_index,:);
                
                
            else
                k_ps_id = find(ps_duration{2}==max(ps_duration{2}));
                k_ps_duration = ps_duration{2}(k_ps_id);
                k_ps_id = k_ps_id(1);
                k_ps_index = find(rotor_results.ps_info{2}(:,5)==k_ps_id);
                ps_time_index =  rotor_results.ps_info{2}(k_ps_index , 3);
                ps_info_temp = rotor_results.ps_info{2}(k_ps_index,:);
                
                
            end
            ps_locs = ps_info_temp(:,1:2);
            pathmap = plot_ps_path_gui(raw_results.bg_data,raw_results.final_filtered_data,...
                ps_locs,'r',bg_flag);
            ResultsFolder = handles.dir2;
            savefig(pathmap,[ResultsFolder,'/path.fig'])
        else
            errordlg('Do the Quantification first, please.')
        end
    end
%%
    function do_wavefront(source,eventdata)
        if   isfield(handles,'filename3')
            hh = warndlg('Please do NOT click other matlab figures while the video is being genereated!');
            uiwait(hh);
            phase_results = load(handles.filename3,'phasesmoothed');
            phasesmoothed = phase_results.phasesmoothed;
            %
            file_name = [handles.dir2,'/wavefront.avi'];
            IsoP_n = str2num(get(IsoP_edit,'String'));
            IsoP = -pi/IsoP_n;
            get_wavefront_video_gui(phasesmoothed, IsoP, file_name)
            
        else
            errordlg('Do the phase calculation first, please.')
        end
    end
%%
    function do_wfdense(source,eventdata)
        if   isfield(handles,'filename3')
            
            phase_results = load(handles.filename3,'phasesmoothed');
            phasesmoothed = phase_results.phasesmoothed;
            %
            file_name = [handles.dir2,'/wavefront.avi'];
            IsoP_n = str2num(get(IsoP_edit,'String'));
            IsoP = -pi/IsoP_n;
            
            [wf_density,~]  = get_wf_density_gui(phasesmoothed,IsoP);
            hwf = figure('Name','Wavefront_density');
            imagesc(wf_density)
            axis image
            axis off
            colordata = colormap('jet');
            colordata(1,:)=[1 1 1];
            colormap(colordata)
            colorbar('FontSize',30 ,'FontName','Times')
            ResultsFolder = handles.dir2;
            set(gca,'FontSize',30 ,'FontName','Times')
            savefig(hwf,[ResultsFolder,'/wavefront_density.fig'])
        else
            errordlg('Do the phase calculation first, please.')
        end
    end
end




