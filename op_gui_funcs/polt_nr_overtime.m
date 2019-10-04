function [fhtt, fhtr] = polt_nr_overtime(ps_info, start_time,end_time,ps_thresh_low,ps_thresh_high,time_resoluation, Fs)


T_end = max([end_time-start_time,max(ps_info{1}(:,3)),max(ps_info{1}(:,3))]);

T = round((T_end)/Fs*1000);

lps_over_t = zeros(floor(T_end/time_resoluation)+1,length(ps_thresh_low));
nps_over_t = zeros(floor(T_end/time_resoluation)+1,length(ps_thresh_low));

for tt =1:length(lps_over_t)
    tstart = (tt-1)*time_resoluation;
    tend = min(tstart+time_resoluation,T_end);
    
    
        tt_index1 = find((ps_info{1}(:,3) >= tstart) & ... 
           (ps_info{1}(:,3)< tend) );
        tt_index2 = find((ps_info{2}(:,3) >= tstart)& ... 
           (ps_info{2}(:,3)< tend) );
        
        td_1 = ps_info{1}(tt_index1,6);
        td_2 = ps_info{2}(tt_index2,6);
        
        psid_1 = ps_info{1}(tt_index1,5);
        psid_2 = ps_info{2}(tt_index2,5);
        
        for iithr = 1:length(ps_thresh_low)
            lps_over_t(tt,iithr) = length(find((td_1 >=ps_thresh_low(iithr))& ...
            (td_1 < ps_thresh_high(iithr)))) + ...
            length(find((td_2 >=ps_thresh_low(iithr))& ...
            (td_2 < ps_thresh_high(iithr))));
        
            psid_11  = unique(psid_1((td_1 >=ps_thresh_low(iithr))& ...
            (td_1 < ps_thresh_high(iithr))));
            psid_22  = unique(psid_2((td_2 >=ps_thresh_low(iithr))& ...
                (td_2 < ps_thresh_high(iithr))));
            
            nps_over_t(tt,iithr) = length(psid_11)+length(psid_22);
        end
            
    
end
 
fhtt = figure('Name','number of locations with ps');
 
 
TT = 0:time_resoluation/Fs:(time_resoluation*length(lps_over_t)-1)/Fs;
TT = TT * 1000;
line_w = [1  1.8];
for iithr = 1:length(ps_thresh_low)
    ff = plot(TT, lps_over_t(:,iithr),'.-','LineWidth',line_w(iithr));
%     histogram(  nps_over_t(:,iithr)')
%     ll(end+1) = num2str(iithr)
 
    hold on 
end
grid on
legend( 'Threshold setting 1','Threshold setting 2')

xlabel('Time (ms)')
ylabel('Number of locations with ps')
set(gca,'FontSize',20 ,'FontName','Times')
% savefig(fhtt,[ResultsFolder,'/nps_overtime.fig'])

fhtr = figure('Name','number of ps');
  
TT = 0:time_resoluation/Fs:(time_resoluation*length(nps_over_t)-1)/Fs;
TT = TT * 1000;

for iithr = 1:length(ps_thresh_low)
    ff = plot(TT, nps_over_t(:,iithr),'.-','LineWidth',line_w(iithr));
%     histogram(  nps_over_t(:,iithr)')
%     ll(end+1) = num2str(iithr)
 
    hold on 
end
grid on
legend( 'Threshold setting 1','Threshold setting 2')
xlabel('Time (ms)')
ylabel('Number of ps')
set(gca,'FontSize',20 ,'FontName','Times')
% savefig(fhtr,[ResultsFolder,'/nps_overtime.fig'])
