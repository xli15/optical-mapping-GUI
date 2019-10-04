function [call,rall,callb,rallb] =  ps_detection(phasesmoothed)

 g = waitbar(0,'Raw PS detection...');
for indextime =1:size(phasesmoothed,3)-2
 
    temphase=phasesmoothed(:, :, indextime);
    
    temphaseup=[temphase(2:end, :); zeros(1,size(temphase,2))];
    temphasedown=[zeros(1, size(temphase,2)); temphase(1:end-1, :)];
    phi1=temphaseup-temphase;
    A=find(abs(phi1)>pi); %find phase jumps > pi
    phi1(A)=wrapTo2Pi(temphaseup(A))-wrapTo2Pi(temphase(A)); %convert these elements to their 2pi complements
    
    %step 2: calculate phi(m, n+1) - phi(m, n) & correct any phase jumps>pi
    temphaseleft=[temphase(:, 2:end) zeros(size(temphase,1),1)];
    phi2=temphaseleft-temphase;
    A=find(abs(phi2)>pi);
    phi2(A)=wrapTo2Pi(temphaseleft(A))-wrapTo2Pi(temphase(A));
    
    
    sizeconv=3;
    step=1; %6
    Sy=zeros(sizeconv, sizeconv);
    Sy(1,1)=1/2;
    Sy(1,2:step:sizeconv-1)=+1.*ones(1, length(2:step:sizeconv-1));
    Sy(1,sizeconv)=+1/2;
    Sy(sizeconv,1)=-1/2;
    Sy(sizeconv, 2:step:sizeconv-1)=-1.*ones(1, length(2:step:sizeconv-1));
    Sy(sizeconv,sizeconv)=-1/2;
    CvSyphi1=conv2(phi2(1:end-1, 1:end-1), Sy, 'same');
    
    Sx=zeros(sizeconv, sizeconv);
    Sx(2:step:sizeconv-1,1)=-1.*ones(length(2:step:sizeconv-1),1);
    Sx(1,1)=-1/2;
    Sx(sizeconv,1)=-1/2;
    Sx(2:step:sizeconv-1,sizeconv)=1.*ones(length(2:step:sizeconv-1),1);
    Sx(1, sizeconv)=1/2;
    Sx(sizeconv, sizeconv)=1/2;
    CvSxphi2=conv2(phi1(1:end-1, 1:end-1), Sx, 'same');
    
    thresh3=3;  %3
    Total7=CvSyphi1+CvSxphi2;
    Total2Pi7a=((-2*pi-thresh3)<Total7).*(Total7<(-2*pi+thresh3));
    Total2Pi7b=((2*pi-thresh3)<Total7).*(Total7<(2*pi+thresh3));% + ((-4*pi-thresh3)<Total7).*(Total7<(-4*pi+thresh3)) + ((4*pi-thresh3)<Total7).*(Total7<(4*pi+thresh3)) ; %0.5
    
    
    %find number greater than threshold.
    
    sizehere=3;
    convop=ones(sizehere,sizehere);
    Total2Pi7cona=conv2(Total2Pi7a, convop, 'same');
    Total2Pi7conthresha=Total2Pi7cona>3;
    
    Total2Pi7conb=conv2(Total2Pi7b, convop, 'same');
    Total2Pi7conthreshb=Total2Pi7conb>3;
    
    [r7, c7]=find(Total2Pi7conthresha);
    for JJ=1:length(r7)
        row7a(indextime, JJ)=r7(JJ);
        col7a(indextime, JJ)=c7(JJ);
        val7a(indextime, JJ)=Total7(r7(JJ), c7(JJ));
    end
    
    %find lost PSs, i.e. not enough neighbours
    Lost=(Total2Pi7cona>1).*(Total7<-6).*(Total2Pi7cona<4);
    
    [r7lost, c7lost]=find(Lost);
    for JJ=1:length(r7lost)
        row7alost(indextime, JJ)=r7lost(JJ);
        col7alost(indextime, JJ)=c7lost(JJ);
        val7alost(indextime,JJ)=Total7(r7lost(JJ), c7lost(JJ));
        noneighalost(indextime, JJ)=Total2Pi7cona(r7lost(JJ), c7lost(JJ));
    end
    
    
    
    %only keep the neighbour closest to +/2pi
    rstore=[]; cstore=[];psvalstore=[];
    for findne=1:length(r7)
        %for each one, check 9 neighbours, if closest to +-2pi, then store
        points=[];
        value=Total7(r7(findne), c7(findne));
        premup=zeros(128,80);
        premup(r7(findne), c7(findne))=1;
        premup=conv2(premup, convop, 'same');
        [row, col, v]=find(premup);
        %points=[phases(ii-1, jj-1) phases(ii-1, jj) phases(ii-1, jj+1) phases(ii, jj-1) phases(ii, jj) phases(ii, jj+1) phases(ii+1, jj-1) phases(ii+1, jj) phases(ii+1, jj+1)];
        row(row==128)=127; col(col==80)=79;
        for kk=1:length(row)
            points(kk)=Total7(row(kk), col(kk));
        end
        distminus2Pi=abs((points--2*pi));
        [C, I]=min(distminus2Pi);
        if C==abs((value--2*pi))
            rstore=[rstore r7(findne)];
            cstore=[cstore c7(findne)];
            psvalstore=[psvalstore value];
        end
        
    end
    
    if length(rstore)>1
        
        fprintf('%d : %d \n', indextime,length(rstore));
    end
    
    rall(1:length(rstore), indextime)=rstore;
    call(1:length(cstore), indextime)=cstore;
    psvalall(1:length(psvalstore), indextime)=psvalstore;
    
    
    [r7, c7]=find(Total2Pi7conthreshb);
    for JJ=1:length(r7)
        row7b(indextime, JJ)=r7(JJ);
        col7b(indextime, JJ)=c7(JJ);
        val7b(indextime, JJ)=Total7(r7(JJ), c7(JJ));
    end
    
    %find lost PSs, i.e. not enough neighbours
    Lost=(Total2Pi7conb>1).*(Total7>6).*(Total2Pi7conb<4);
    
    [r7lostb, c7lostb]=find(Lost);
    for JJ=1:length(r7lostb)
        row7blost(indextime, JJ)=r7lostb(JJ);
        col7blost(indextime, JJ)=c7lostb(JJ);
        val7blost(indextime,JJ)=Total7(r7lostb(JJ), c7lostb(JJ));
        noneighblost(indextime, JJ)=Total2Pi7conb(r7lostb(JJ), c7lostb(JJ));
    end
    
    
    rstoreb=[]; cstoreb=[]; psvalstoreb=[];
    for findne=1:length(r7)
        %for each one, check 9 neighbours, if closest to +-2pi, then store
        points=[];
        value=Total7(r7(findne), c7(findne));
        premup=zeros(128,80);
        premup(r7(findne), c7(findne))=1;
        premup=conv2(premup, convop, 'same');
        [row, col, v]=find(premup);
        %points=[phases(ii-1, jj-1) phases(ii-1, jj) phases(ii-1, jj+1) phases(ii, jj-1) phases(ii, jj) phases(ii, jj+1) phases(ii+1, jj-1) phases(ii+1, jj) phases(ii+1, jj+1)];
        row(row==128)=127; col(col==80)=79;
        for kk=1:length(row)
            points(kk)=Total7(row(kk), col(kk));
        end
        distminus2Pi=abs((points-2*pi));
        [C, I]=min(distminus2Pi);
        if C==abs((value-2*pi))
            rstoreb=[rstoreb r7(findne)];
            cstoreb=[cstoreb c7(findne)];
            psvalstoreb=[psvalstoreb value];
        end
        
    end
    
    rallb(1:length(rstoreb), indextime)=rstoreb;
    callb(1:length(cstoreb), indextime)=cstoreb;
    psvalallb(1:length(psvalstoreb), indextime)=psvalstoreb;
    
    
    waitbar(indextime/size(phasesmoothed,3),g);
end

delete(g)
