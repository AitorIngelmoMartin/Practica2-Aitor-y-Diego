%problema6test5
fas=14e9;
fdes=12.75e9;
lamdades=3e8/fdes;
lamdaas=3e8/fas;
Rbum=2e6;
Rbhos=2e6;
Rbportadora=34e6;
EbN0min=5.9;
PIREsat=40.8;
GTsat=8.5;
GTterrena=25;
Ladas=1.5;
Laddes=4;
d=38200e3;
K=1.38e-23;
%a
N=Rbportadora/Rbum;
%N=12;
%b
lbfdes=20*log10((4*pi*d)/lamdades);
ebn0=10^(EbN0min/10);
cn0total=ebn0*Rbportadora;
CN0total=10*log10(cn0total);
CN0des=PIREsat-lbfdes-Laddes+GTterrena-10*log10(K);
L=CN0total-CN0des;
%c
cnoas=1/((10^(-CN0total/10))-(10^(-CN0des/10)));
CN0as=10*log10(cnoas);
lbfas=20*log10((4*pi*d)/lamdaas);
PIREterrena=CN0as+lbfas+10*log10(K)+Ladas-GTsat;

L=CN0total-CN0as;