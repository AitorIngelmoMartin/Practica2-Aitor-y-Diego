%problema3test5
fas=15e9;
fdes=12e9;
PIREsat=80-30;
Greceptora=40;
lamdades=3e8/fdes;
d=40620e3;
Ta=65;
terminales=1;
lt1=10^(terminales/10);
Tterminales=295;
Fgasfet=4;
fr1=10^(Fgasfet/10);
GananciaFgasfet=25;
ganancia=10^(GananciaFgasfet/10);
Fr=12;
fr2=10^(Fr/10);
T0=290;
K=1.38e-23;
Lgasesdes=0.02;
lbfdes=20*log10((4*pi*d)/lamdades);
Md=1.5;
%b Necesitamos usar un CAG de 16 db ya que F001=14.57 por lo que es mayor
%que es mayor que 14 db por lo que si usamos uno de 14 db la
%indisponibilidad nos va a aumentar.
%Calculo GT
Tantena=Ta+(Tterminales*(lt1-1))+(T0*(fr1-1)*lt1)+(T0*(fr2-1)*lt1/ganancia);
GTterrena=Greceptora-10*log10(Tantena);
%Calculo CN0 descendente
CN0des=PIREsat-lbfdes-Lgasesdes-Md+GTterrena-10*log10(K);
%Calculo CN0total
CN0as=85;
cn0total=1/((10^(-CN0as/10))+(10^(-CN0des/10)));
CN0total=10*log10(cn0total);
L=CN0total-CN0des;
