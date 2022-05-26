%problema1tema5
D = 36e6;
BW_tpdr = 36e6;
f_up=6e9;
lamda_up=3e8/f_up;
f_down=4e9;
lamda_down=3e8/f_down;
N=5;
acceso=0;% si es 1 TDMA si es 0 FDMA
f_inicial=5980e6;
Rb=8e6;
B_g=3.5e6;
PIREsat_dBW=39;
Flujosat_dBW=-90.5;
GTsat=-2.8;
IBO=[-3 -4 -5];
CI0=[86.3 87.7 88.5];
OBO=[0 0 0];
CN0total=[0 0 0 0 0];
CN0as=[0 0 0 0 0];
CN0des=[0 0 0 0 0];
cn0total=[0 0 0];
M_up=1.5;
M_down=1.5;
for i=1:3
    OBO(i)=IBO(i)+6-6*exp(IBO(i)/6);
end
PIREmax=68;
GTterrena=29;
K=1.38e-23;
d=36000e3;
Lad=1;
rolloff=0.4;
lbfas=20*log10((4*pi*d)/lamda_up);
lbfdes=20*log10((4*pi*d)/lamda_down);
%a
Bportadoras=BW_tpdr-2*B_g;
f1=f_inicial+B_g;
Sportadoras=Bportadoras/(N-1);
f2=f1+Sportadoras;
f3=f2+Sportadoras;
f4=f3+Sportadoras;
f5=f4+Sportadoras;
Rbcod=Rb*(6/5);
Bportadora=(1+rolloff)*Rbcod/2;
%b calculo de la CN0total minima
EbN0=14;
ebn0=10^(EbN0/10);
cn0=ebn0*Rb;
CN0=10*log10(cn0);
%c
g=120*pi*((D/lamda_up)*pi)^2;%cambiar la lamda a descendente o ascendente
G=10*log10(g);
Tantena=Ta+(T0*(lt1-1))+(T0*(fr-1)*lt1);%puede variar depende de la cadena;
GT=G-10*log10(Tantena);
flujosat=piretotal/(4*pi*(d^2)*l);% l=perdidas por apuntamiento de las antena y polarizacion y perdidas del encale ascendente
PIREtotal=Flujosat_dBW+10*log10((4*pi*d^2))+Ma+Lad;
if(acceso==0)
PIREas=PIREtotal-10*log10(N);
PIREas=PIREtotal-10*log10(Bport/Btotal);
PIREdes=PIREsat_dBW-10*log10(N);
PIREdes=PIREsat_dBW-10*log10(Bport/Btotal);
for j=1:3
 CN0as(j)=PIREas+IBO(j)-lbfas-Lad-Ma+GTsat-10*log10(K);
 CN0des(j)=PIREdes+OBO(j)-lbfdes-Lad-Md+GTterrena-10*log10(K);
 cn0total(j)=1/((10^(-CN0as(j)/10))+(10^(-CN0des(j)/10))+(10^(-CI0(j)/10)));
 CN0total(j)=10*log10(cn0total(j));

end
end
if(acceso==1)
    CN0as=PIREterrena-lbfas-Lad-Ma+GTsat-10*log10(K);
    CN0des=PIREsatelite-lbfdes-Lad-Md+GTterrena-10*log10(K);
    cn0total=1/((10^(-CN0as/10))+(10^(-CN0des/10)));
    CN0total=10*log10(cn0total);
end
L=10*log10(cn0total/cn0des);%degradacion debida al enlace ascendente
