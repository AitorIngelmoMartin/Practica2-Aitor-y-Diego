clc;clear;

% Un servicio de radioenlace fijo en la banda de los 13 GHz.
f = 13e9;
lambda = 3e8/f;
% El radioenlace está compuesto por dos vanos de 27 km y 19 km. 
dvano1 = 27e3;
dvano2 = 19e3;
Distancia_total = dvano1 + dvano2;

% Teniendo en cuenta el plan de disposición de frecuencias correspondiente de la UIT (UIT-R F.497),
% en el rango de frecuencias de trabajo, 12.75 - 13.25 GHz, se 
% transmiten 8 canales con alternancia de polarizaciones. 
% Las bandas de guarda a extremos son 15 y 23 MHz, y entre direcciones de 70 MHz.
N =8;
roll_off =0.4;
% Separacion_canal = (1+roll_off)*()

% Las estaciones terminales transmiten 20 dBm de potencia. 
Ptx_dBm = 20;
% Las antenas de todas las estaciones presentan una ganancia de 39dB en polarización horizontal, 
G_dB = 39;
% y se encuentran conectadas a través de un cable coaxial que presenta 4 dB de pérdidas. 
Lt_dB = 4;
Lt = 10^(Lt_dB/10);

MTTR = 5;
MTBF = 10^5;
%La figura de ruido de los receptores es 4,5 dB. La indisponibilidad total máxima es de 0,025%,
% asumiendo que en cualquier estación se necesita al menos una C/N = 18 dB 
figura_ruido_rx = 4.5;
figura_ruido_rx = 10^(figura_ruido_rx/10);
Utotal=0.025;
C_N_umbral = 18;

% 1) Calcular la velocidad binaria máxima que se puede ofrecer con el plan de frecuencias, 
% si la modulación es QPSK y el factor del filtro es 1,4. 
M =4;
Boltzman    = 1.381e-23;

% BW_total = ZS1 +(N-1)*SC +YS + (N-1)*SC + ZS2;
BW_total = (13.25 - 12.75)*1e9;
ZS1 = 15e6; %guarda1
YS = 70e6; %separacion entre direcciones
ZS2 = 23e6; %guarda2
SC = (BW_total - ZS1 - YS - ZS2)/(2*(N-1));
% SC = (1+roll_off)*Rb/log2(M);
Rb = (SC*log2(M))/(1+roll_off);
%--------------

% 2) Calcular el campo eléctrico que se recibe en cada vano en condiciones normales de propagación. 
% Datos: Considerar como velocidad binaria la máxima posible y atenuador variable frente a desvanecimientos;
% R0.01=35mm/h

%VANO1

K = 1.381e-23;
Bn = Rb/log2(M);

T0 = 290;
T1 = T0*(Lt - 1);
T2 = T0*(figura_ruido_rx - 1);
T_total = T0/Lt + T1/Lt + T2;

Umbral_dBm = C_N_umbral + 10*log10(K*T_total*Bn) + 30;

gamma_gases =0.022;
Lgases_vano1_dB = gamma_gases*dvano1/1000;
Lbf_vano1_dB =20*log10(4*pi*dvano1/lambda);
Lb_vano1_dB=Lbf_vano1_dB+Lgases_vano1_dB;
% Prxcn_vano1_dBm = Ptx_dBm + G_dB - Lt_dB - Lb_vano1_dB + G_dB - Lt_dB;
% MD_vano1=Prxcn_vano1_dBm-Umbral_dBm;
% 
%q DEBIDO A LA LLUVIA

qtotal = Utotal - (1.5 + 1.5)*MTTR*100/MTBF;
q1 = qtotal*dvano1/(dvano1 + dvano2);
q2 = qtotal*dvano2/(dvano1 + dvano2);

%Paso 2

R_001= 35;
alpha = 1.1586;
k = 0.03041;
R_001_alpha = R_001^alpha;
gamma_R = k*R_001_alpha; % Atenuación específica (dB/Km)

%Paso 3 en radioenlace terrenal

d_eff=(0.477*(dvano1*1e-3)^0.633*R_001^(0.073*alpha)*(f*1e-9)^0.123)-(10.579*(1-exp(-0.024*(dvano1*1e-3))));

%Paso 4

if d_eff<0.4
 Lef=(dvano1*1e-3)*2.5;
else
 Lef=(dvano1*1e-3)/d_eff;
end
F_001=gamma_R*Lef;
if (f*1e-9)>=10
 C0=0.12+0.4*log10(((f*1e-9)/10)^0.8);
else
 C0=0.12;
end
C1=(0.07^C0)*(0.12^(1-C0));
C2=0.855*C0+0.546*(1-C0);
C3=0.139*C0+0.043*(1-C0);
%  % MD mínimo cuando q=1%
% MDmin=F_001*C1*1^(-C2-C3*log10(1));
%  % MD máximo cuando q=0.001%
% MDmax=F_001*C1*0.001^(-C2-C3*log10(0.001));
% if MD_vano1>MDmin
%  if MD_vano1<MDmax
%  solucion=roots([C3 C2 log10(MD_vano1/(F_001*C1))]);
%  q=10^(max(solucion));
%  else
%  q=0.001;
%  end
% else
%  q=Inf;
% end
Fq_vano1= F_001*C1*q1^(-C2-C3*log10(q1)); %minimo de atenuacion de la luvia en el q% del año
% Ueq=1.5*100*(MTTR/MTBF);
% Utotalvano1=Ueq+q;
% 
% %VANO 2
% 
gamma_gases =0.022;
Lgases_vano2_dB = gamma_gases*dvano2/1000;
Lbf_vano2_dB =20*log10(4*pi*dvano2/lambda);
Lb_vano2_dB=Lbf_vano2_dB+Lgases_vano2_dB;
% Prxcn_vano2_dBm = Ptx_dBm + G_dB - Lt_dB - Lb_vano2_dB + G_dB - Lt_dB;
% MD_vano2=Prxcn_vano2_dBm-Umbral_dBm;
% 
%q DEBIDO A LA LLUVIA

%Paso 2

R_001_alpha = R_001^alpha;
gamma_R = k*R_001_alpha; % Atenuación específica (dB/Km)

%Paso 3 en radioenlace terrenal

d_eff=(0.477*(dvano2*1e-3)^0.633*R_001^(0.073*alpha)*(f*1e-9)^0.123)-(10.579*(1-exp(-0.024*(dvano2*1e-3))));

%Paso 4

if d_eff<0.4
 Lef=(d*1e-3)*2.5;
else
 Lef=(dvano2*1e-3)/d_eff;
end
F_001=gamma_R*Lef;
if (f*1e-9)>=10
 C0=0.12+0.4*log10(((f*1e-9)/10)^0.8);
else
 C0=0.12;
end
C1=(0.07^C0)*(0.12^(1-C0));
C2=0.855*C0+0.546*(1-C0);
C3=0.139*C0+0.043*(1-C0);
%  % MD mínimo cuando q=1%
% MDmin=F_001*C1*1^(-C2-C3*log10(1));
%  % MD máximo cuando q=0.001%
% MDmax=F_001*C1*0.001^(-C2-C3*log10(0.001));
% if MD_vano2>MDmin
%  if MD_vano2<MDmax
%  solucion=roots([C3 C2 log10(MD_vano2/(F_001*C1))]);
%  q=10^(max(solucion));
%  else
%  q=0.001;
%  end
% else
%  q=Inf;
% end
Fq_vano2= F_001*C1*q2^(-C2-C3*log10(q2)); %minimo de atenuacion de la luvia en el q% del año
% Ueq=1.5*100*(MTTR/MTBF);
% Utotalvano2=Ueq+q;



MD_vano1 = Fq_vano1 ;
MD_vano2 = Fq_vano2;

PIRE_vano1_dBm = Umbral_dBm + MD_vano1 + Lb_vano1_dB - G_dB + Lt_dB;
PIRE_vano1_W = 1e-3*10^(PIRE_vano1_dBm/10);
e_vano1 = sqrt(30*PIRE_vano1_W/dvano1^2);
E_vano1 = 20*log10(e_vano1/1e-6);

% Flujo_vano1_dBm     = (PIRE_vano1_dBm)- 10*log10((4*pi*dvano1^2)) - Lgases_vano1_dB;
% Flujo_vano1 =10^(Flujo_vano1_dBm/10);
% e_vano1 = sqrt(Flujo_vano1*120*pi);
% E_vano1 = 20*log10(e_vano1/(10^-3))

PIRE_vano2_dBm      = Umbral_dBm + MD_vano2 - (-Lb_vano2_dB + G_dB - Lt_dB);
PIRE_vano2_W = 1e-3*10^(PIRE_vano2_dBm/10);
e_vano2 = sqrt(30*PIRE_vano2_W/dvano2^2);
E_vano2 = 20*log10(e_vano2/1e-6);

% Flujo_vano2_dBm     = (PIRE_vano2_dBm) -  10*log10((4*pi*dvano2^2)) - Lgases_vano2_dB;
% Flujo_vano2 =10^(Flujo_vano2_dBm/10);
% e_vano2 = sqrt(Flujo_vano2*120*pi);