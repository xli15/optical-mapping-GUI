function [phase2, meanlineall,maxposall, countmaxima, medCL, meanCL, STDCL, amp1all, amp2all, ampminall] = get_phase(filtered_data,win,ampthres)

phase2=zeros(size(filtered_data,1), size(filtered_data,2), size(filtered_data,3));
meanlineall=zeros(size(filtered_data,1), size(filtered_data,2), size(filtered_data,3));
maxposall=zeros(size(filtered_data,1), size(filtered_data,2), 200);
amp1all=zeros(size(filtered_data,1), size(filtered_data,2),200);
amp2all=zeros(size(filtered_data,1), size(filtered_data,2),200);
ampminall=zeros(size(filtered_data,1), size(filtered_data,2),200);
medCL=zeros(size(filtered_data,1), size(filtered_data,2));
meanCL=zeros(size(filtered_data,1), size(filtered_data,2));
STDCL=zeros(size(filtered_data,1), size(filtered_data,2));
countmaxima=zeros(size(filtered_data,1), size(filtered_data,2));

g = waitbar(0,'Calculating phase...');
for ind1=1:size(filtered_data,1)
    
%     if rem(ind1,10)==0
%         fprintf('%d \n', ind1);
%         
%     else
%     end
%     
    for ind2=1:size(filtered_data,2)
        
        %         clearvars -except YourPath bin_size hbpercent oldfilename MiddlePixCL ampmed InDeX medCL meanCL STDCL countmaxima filtered_data phase2 meanlineall maxposall amp1all amp2all ampminall ind1 ind2 bin_size InDeX WLcombocol ampcombocol ampcombo WLcombo
        clear minpos maxpos minpos2 maxpos2 minpos3 maxpos3
        tic
        datapoint=squeeze(filtered_data(ind1, ind2, :));
        
        if ~isempty(find(datapoint>0, 1))
            
            tic
            datapoint=smooth(datapoint);
            B=datapoint';
            
             
%             [minpos , maxpos ] = find_minmax_pos_b(datapoint, win);
            [minpos , maxpos ] = find_minmax_pos_c(datapoint, win);
            %             toc
            maxpos3=maxpos;
            minpos3=minpos;
             
           
            if 0
                        figure()
                        plot(datapoint)
                        hold on
                        scatter(maxpos3, datapoint(maxpos3), 50, 'r')
                        scatter(minpos3, datapoint(minpos3), 50, 'g')
                 
            end
             
            
            ampstored2 = zeros(1,length(maxpos));
            ampstoredm = zeros(1,length(maxpos));
            
            for kj=1:length(maxpos)
                %find closest nonnan min before the max
                mindbe=abs(maxpos(kj)-minpos3);
                mindbe(mindbe<0)=1000;
                [~, ind]=min(mindbe);
                minbefore=minpos(ind);
                amp=datapoint(maxpos(kj))-datapoint(minbefore);
                amp2=datapoint(maxpos3(kj))-datapoint(minpos3(kj+1));
                [val, ~]=min([amp amp2]);
                ampstored1(kj)=amp;
                ampstored2(kj)=amp2;
                ampstoredm(kj)=val;
                if val<ampthres
                    maxpos3(kj)=nan;
                    minpos3(ind)=nan;
                else
                end
            end
            
            minpos3(isnan(minpos3))=[];
            %             maxpos3(isnan(maxpos3))=[];
            
            %redefine maxima based on minima
            
            for II=1:length(minpos3)-1
                ind=[];
                dataran=datapoint(minpos3(II):minpos3(II+1));
                [~,ind]=max(dataran);
                maxpos2(II)=minpos3(II)-1+ind;
            end
            
           
            minpos2=minpos3;
           
            
            %
            %%pEMD phase
            %
            maxpos3=[1 maxpos2 length(datapoint)];
            minpos3=[1 minpos2 length(datapoint)];
            
            ymaxvals=[datapoint(maxpos3(2)); datapoint(maxpos3(2:end-1)); datapoint(maxpos3(end-1))];
            yminvals=[datapoint(minpos3(2)); datapoint(minpos3(2:end-1)); datapoint(minpos3(end-1))];
            
            %                         figure
            %                         plot(datapoint)
            %                         hold on
            %                         scatter(maxpos3, ymaxvals, 50, 'r')
            %                         scatter(minpos3, yminvals, 50, 'g')
            %
            
            
            yimax=pchip(maxpos3, ymaxvals, 1:1:length(datapoint));
            yimin=pchip(minpos3, yminvals, 1:1:length(datapoint));
            meanline=(yimax+yimin)./2;
            %             toc
            maxposall(ind1, ind2, 1:length(maxpos3))=maxpos3;
            amp1all(ind1, ind2, 1:length(ampstored1))=ampstored1;
            amp2all(ind1, ind2, 1:length(ampstored2))=ampstored2;
            ampminall(ind1, ind2, 1:length(ampstoredm))=ampstoredm;
            meanlineall(ind1, ind2, :)=meanline;
            medCL(ind1, ind2)=median(diff(maxpos3));
            meanCL(ind1, ind2)=mean(diff(maxpos3));
            STDCL(ind1, ind2)=std(diff(maxpos3));
            countmaxima(ind1, ind2)=length(maxpos3);
            
            
            %                     figure
            %                     plot(datapoint)
            %                     hold on
            %                     plot(yimax, 'r')
            %                     plot(yimin, 'g')
            %                     plot(meanline, 'k')
            
            
            Vmeanremoved=datapoint'-meanline;
            
            hil2=hilbert(Vmeanremoved);
            x2=real(hil2);
            y2=imag(hil2);
            phase2(ind1,ind2,:)=atan2(y2,x2);
            
            %             toc
            %             toc
            %         figure
            %         plot(x2, y2)
            %
            %         figure
            %         plot(squeeze(phase2(ind1, ind2, :)))
            %
        else
            
            phase2(ind1, ind2, :)=NaN;
            
        end
    end
      waitbar(ind1/size(filtered_data,1),g);
end

delete(g)
end

