function  [wf_density,raw_wf_info]  = get_wf_density_gui(phasesmoothed,IsoP)

[L1,L2,n_t] = size(phasesmoothed);
Blast=zeros(L1,L2);
wf_density = zeros(L1,L2);

PhaseMean=mean(phasesmoothed, 3);
CC=conv2(PhaseMean, ones(9,9), 'same');
DD=isnan(CC).*isfinite(PhaseMean);
DD=isfinite(PhaseMean)-DD;
DD(:, 1:3)=0;
DD(1:3,:)=0;
DD(L1-3:L1,:)=0;
DD(:, L2-3:L2)=0;
 
raw_row_wf = [];
raw_col_wf  = [];
t_wf = [];
g = waitbar(0,'Calculating wavefront density...');


for t = 1:n_t
    %set up matrices
    Vshape=phasesmoothed(:, :, t);
    [A,B] = get_wavefront_gui(Vshape,IsoP);
    B2=B.*DD;
    
    BW=bwconncomp(B2);
    numpix=cellfun(@numel, BW.PixelIdxList);
    todel=find(numpix<3);
    for iii=1:length(todel)
        B2(BW.PixelIdxList{todel(iii)})=0;
    end
    
    %         figure
    %         spy(B2)
    
    PossibleElements=find(B2);
    NBSize=25; B2size=size(B2);
    
    for ijk = 1:length(PossibleElements)
        TE=PossibleElements(ijk);
        Mat=zeros(B2size); Mat(TE)=1;
        NeighMat=conv2(Mat, ones(NBSize, NBSize), 'same');
        PreviousFrame=Blast.*NeighMat;

        if isempty(find(PreviousFrame,1)) 
            [rowW, colW]=ind2sub(B2size, TE);
            wf_density(rowW,colW) =  wf_density(rowW,colW) + 1;
            raw_row_wf=[raw_row_wf; rowW];
            raw_col_wf=[raw_col_wf; colW ];
            t_wf=[t_wf; t.*ones(size(colW))];
        end
        
    end
    
    Blast=B;
    waitbar(t/n_t,g);
end
raw_wf_info = [t_wf,raw_row_wf,raw_col_wf];
wf_density(isnan(PhaseMean)) = -1;
wf_density = wf_density./n_t;
delete(g)