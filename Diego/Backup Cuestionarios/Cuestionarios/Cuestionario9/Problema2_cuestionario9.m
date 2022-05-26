% En un estudio de planificación previa se pretende evaluar la efectividad de plantear un radioenlace con tres vanos y dos secciones de conmutación.
% Las características de las estaciones terminales e intermedias son:
% - Antenas Parabólicas de 48 dB de ganancia con polarización vertical
% - Frecuencia de trabajo 52 GHz
% - Pérdidas en los terminales de 1,4 dB
% - Modulación QPSK y filtro de coseno alzado con α=0,4 (se asume una degradación debida al filtro de 2 dB)
% - Figura de ruido del receptor de 5 dB
% - MTTR 40 horas
% - MTBF 2*10^6 horas
% - PIRE=75 dBW
% - Atenuador variable
% - R0,01=40 mm/h
% La distancia que existe entre las estaciones terminales es 31 km y el régimen binario ofrecido de 15Mbps.
% Determinar la calidad de disponibilidad para asegurar una BER máxima de 10^-6 (Eb/N0=12 dB para QPSK y filtro ideal) si las longitudes de los tres vanos son 11, 6 y 14 km y las longitudes de las dos secciones de conmutación son 17 y 14km.


clc;clear;

c = 3e8;
f = 52e9;
lambda = c/f;

M = 4;
"QPSK"
roll_off = 0.4;
degradacion = 2;

G_dB = 48;
"Polarización Vertical"

Lt_dB = 1.4;
Lt = 10^(Lt_dB/10);
figura_ruido_rx_dB = 5;
figura_ruido_rx = 10^(figura_ruido_rx_dB/10);

MTTR = 40;
MTBF = 2e6;

PIRE_dBW = 75;

"ATENUADOR VARIABLE"
R_001 = 40;

Rb = 15e6;
Eb_N0 = 12;

dtotal = 31e3;
dvano1 = 11e3;
dvano2 = 6e3;
dvano3 = 14e3;

K = 1.381e-23;

%VANO1

T0 = 290;
T1 = T0*(Lt - 1);
T2 = T0*(figura_ruido_rx - 1);
T_total = T0/Lt + T1/Lt + T2;

gamma_gases =0.4;
Lgases_vano1_dB = gamma_gases*dvano1/1000;
Lbf_vano1_dB =20*log10(4*pi*dvano1/lambda);
Lb_vano1_dB=Lbf_vano1_dB+Lgases_vano1_dB;
Prxcn_vano1_dBm = PIRE_dBW - Lb_vano1_dB + G_dB - Lt_dB + 30;
Umbral=Eb_N0+10*log10(K*T_total*Rb)+degradacion+30;
MD_vano1=Prxcn_vano1_dBm-Umbral;

%q DEBIDO A LA LLUVIA

%Paso 2
alpha = 0.7783;
k = 0.6901;
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
 % MD mínimo cuando q=1%
MDmin=F_001*C1*1^(-C2-C3*log10(1));
 % MD máximo cuando q=0.001%
MDmax=F_001*C1*0.001^(-C2-C3*log10(0.001));
if MD_vano1>MDmin
 if MD_vano1<MDmax
 solucion=roots([C3 C2 log10(MD_vano1/(F_001*C1))]);
 q=10^(max(solucion));
 else
 q=0.001;
 end
else
 q=Inf;
end

Ueq=1.5*100*(MTTR/MTBF);
Utotalvano1=Ueq+q;

%VANO 2

gamma_gases =1;
Lgases_vano2_dB = gamma_gases*dvano2/1000;
Lbf_vano2_dB =20*log10(4*pi*dvano2/lambda);
Lb_vano2_dB=Lbf_vano2_dB+Lgases_vano2_dB;
Prxcn_vano2_dBm = PIRE_dBW - Lb_vano2_dB + G_dB - Lt_dB + 30;
Umbral=Eb_N0+10*log10(K*T_total*Rb)+degradacion+30;
MD_vano2=Prxcn_vano2_dBm-Umbral;

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
 % MD mínimo cuando q=1%
MDmin=F_001*C1*1^(-C2-C3*log10(1));
 % MD máximo cuando q=0.001%
MDmax=F_001*C1*0.001^(-C2-C3*log10(0.001));
if MD_vano2>MDmin
 if MD_vano2<MDmax
 solucion=roots([C3 C2 log10(MD_vano2/(F_001*C1))]);
 q=10^(max(solucion));
 else
 q=0.001;
 end
else
 q=Inf;
end

Ueq=1.5*100*(MTTR/MTBF);
Utotalvano2=Ueq+q;

%VANO 3

gamma_gases =1;
Lgases_vano3_dB = gamma_gases*dvano3/1000;
Lbf_vano3_dB =20*log10(4*pi*dvano3/lambda);
Lb_vano3_dB=Lbf_vano3_dB+Lgases_vano3_dB;
Prxcn_vano3_dBm = PIRE_dBW - Lb_vano3_dB + G_dB - Lt_dB + 30;
Umbral=Eb_N0+10*log10(K*T_total*Rb)+degradacion+30;
MD_vano3=Prxcn_vano3_dBm-Umbral;

%q DEBIDO A LA LLUVIA

%Paso 2

R_001_alpha = R_001^alpha;
gamma_R = k*R_001_alpha; % Atenuación específica (dB/Km)

%Paso 3 en radioenlace terrenal

d_eff=(0.477*(dvano3*1e-3)^0.633*R_001^(0.073*alpha)*(f*1e-9)^0.123)-(10.579*(1-exp(-0.024*(dvano3*1e-3))));

%Paso 4

if d_eff<0.4
 Lef=(dvano3*1e-3)*2.5;
else
 Lef=(dvano3*1e-3)/d_eff;
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
 % MD mínimo cuando q=1%
MDmin=F_001*C1*1^(-C2-C3*log10(1));
 % MD máximo cuando q=0.001%
MDmax=F_001*C1*0.001^(-C2-C3*log10(0.001));
if MD_vano3>MDmin
 if MD_vano3<MDmax
 solucion=roots([C3 C2 log10(MD_vano3/(F_001*C1))]);
 q=10^(max(solucion));
 else
 q=0.001;
 end
else
 q=Inf;
end

Ueq=2*100*(MTTR/MTBF);
Utotalvano3=Ueq+q;

%--------------------------------

Utotal=Utotalvano1+Utotalvano2+Utotalvano3;