function [A,B] = get_wavefront_gui(Vphase,IsoP)

[L1,L2] = size(Vphase);

VshapeR=[zeros(L1, 1) Vphase(:, 1:L2-1)];
VshapeL=[Vphase(:, 2:L2), zeros(L1,1)];
VshapeU=[Vphase(2:L1, :); zeros(1, L2)];
VshapeD=[zeros(1, L2); Vphase(1:L1-1,:)];

VshapeRLD=[zeros(1, L2-1); Vphase(1:L1-1, 2:L2)];
VshapeRLD=[VshapeRLD zeros(L1, 1)];
VshapeRUD=[Vphase(2:L1, 2:L2) zeros(L1-1,1)];
VshapeRUD=[VshapeRUD; zeros(1, L2)];
VshapeLLD=[zeros(L1-1, 1) Vphase(1:L1-1, 1:L2-1)];
VshapeLLD=[zeros(1, L2); VshapeLLD];
VshapeLUD=[zeros(L1-1, 1) Vphase(2:L1, 1:L2-1)];
VshapeLUD=[VshapeLUD; zeros(1, L2)];

%Select Nodes @ IsoPmV
NoNeighGTIsoP=((VshapeR>IsoP).*(VshapeR~=0)+(VshapeL>IsoP).*(VshapeL~=0)+(VshapeU>IsoP).*(VshapeU~=0)+(VshapeD>IsoP).*(VshapeD~=0));
NoNeighGTIsoP13=(0<NoNeighGTIsoP).*(NoNeighGTIsoP<4);
FindIsoP=(Vphase<IsoP).*NoNeighGTIsoP13;

NoNeighGTIsoPv2=((VshapeR>IsoP).*(VshapeR~=0)+(VshapeL>IsoP).*(VshapeL~=0)+(VshapeU>IsoP).*(VshapeU~=0)+(VshapeD>IsoP).*(VshapeD~=0));
NoNeighGTIsoP13v2=(0<NoNeighGTIsoPv2).*(NoNeighGTIsoPv2<4); %4
FindIsoPv2=(Vphase<IsoP).*NoNeighGTIsoP13v2.*(Vphase>IsoP-0.5);

B=FindIsoPv2;
A=FindIsoP; A=A.*(B==0);