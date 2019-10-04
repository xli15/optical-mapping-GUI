function [cmosData,frequency] = DAconvert_gui(dafilename,start_time,end_time,format)
%% Function to convert from *.da format to cmosData format
%
%   INPUTS
%
%   olddir          =   source directory
%   oldfilename     =   source file
%   start_time      =   time to start file
%   end_time        =   time to end file
%   format          =   is data no_of_frames*pixels_per_frame or opposite?
%
%   OUTPUTS
%
%   newfilename     =   *.mat file consisting of
%   .cmosData       =   data
%   .bgimage        =   background image file
%   .frequency      =   sampling frequency
%
%% CODE
% Set Variables

% newfilename     =   [oldfilename(1:length(oldfilename)-3),'.mat'];
% dirname         =   [olddir,'/'];
% start_frame     =   start_time;       % in msec
% end_frame       =   end_time;         % in msec

% Open file read header (HDR)
%  see www.redshirtimaging.com/support/dfo.html

fid             =   fopen(dafilename,'r','n'); 
hdr_size        =   2560;                               % DO NOT CHANGE. 
hdr             =   fread(fid,hdr_size,'int16');        % Read hdr
no_of_frames    =   hdr(5);
columns         =   hdr(385)                           % CHK. Should be 160
rows            =   hdr(386)                           % CHK. Should be 128
frame_pixels    =   rows*columns                       % CHK. Should be 20480
frequency       =   hdr(388)
acq_ratio       =   hdr(92)

% Open Data File
frame=fread(fid,no_of_frames*frame_pixels,'int16');
fclose('all');

% Reshape Data
if format == 1
    fdata = reshape(frame, no_of_frames, frame_pixels);
    fdata = fdata(start_time:end_time, :);
elseif format == 2
    fdata = reshape(frame, frame_pixels, no_of_frames);
    fdata = fdata(:, start_time:end_time);
    fdata = flip(fdata,2);
    fdata = rot90(fdata);
end

for j = 1:size(fdata, 1)
    oneframe = squeeze(fdata(j,:));
    oneframe = reshape(oneframe,columns,rows)';
    cmosData_raw(:,:,j) = oneframe(:,:);
end

% Extract Data
% cmosData=cmosData_raw(:, 1:80, :);    % Voltage
cmosData=cmosData_raw(:, 81:160, :);  % Calcium

% Flipping action potentials
maxdata = squeeze(max(cmosData,[],3));
mindata = squeeze(min(cmosData,[],3));
cmosData = gsubtract(maxdata,cmosData);
cmosData = gadd(mindata,cmosData);

% newfilename = [olddir,'/',newfilename];             
% save(newfilename,'cmosData', 'frequency');     % Output file to load into Rhythm.m    
    

end
