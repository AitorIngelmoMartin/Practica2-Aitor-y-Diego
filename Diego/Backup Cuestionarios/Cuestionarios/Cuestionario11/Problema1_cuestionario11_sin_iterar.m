
clc;clear;

c = 3e8;
f = 18e9;
lambda = c/f;

Rb = 16e6;
M = 16;
"16 QAM"

G_dB = 41.2;
G = 10^(G_dB/10);

Lt_dB = 1.3;
Lt = 10^(Lt_dB/10);
figura_ruido_rx_dB = 9;
figura_ruido_rx = 10^(figura_ruido_rx_dB/10);

Eb_N0 = 12.5;

MTTR = 6;
MTBF = 7.5e5;

R_001 = 34;
alpha = 1.0818;
k = 0.0708;

"Atenuador Variable"

Utotal = 0.015;

%VANOS RADIOENLACE A-C
Ptx_vanoAB_dBm  = 10.9;
Ptx_vanoBC_dBm  = 27.1;



%distancias
dvano1 = 10e3;
dvano2 = 16e3 + 5e3;
dvano3 = 14e3;

%INDISPONIBILIDAD DE EQUIPOS EN CADA VANO
Ueq_vano1 = (1+1)*MTTR*100/MTBF;
Ueq_vano2 = (1+1)*MTTR*100/MTBF;

%INDISPONIBILIDAD DE LLUVIA EN CADA VANO
qtotal = Utotal - (1+1+1+1)*MTTR*100/MTBF;
q1 = qtotal*dvano1/(dvano1+dvano2);
q2 = qtotal*dvano2/(dvano1+dvano2);

%MD en el vano BC

R_001_alpha = R_001^alpha;
gamma_R = k*R_001_alpha; % Atenuación específica (dB/Km)

d_eff=(0.477*(dvano2*1e-3)^0.633*R_001^(0.073*alpha)*(f*1e-9)^0.123)-(10.579*(1-exp(-0.024*(dvano2*1e-3))));

%Paso 4

if d_eff<0.4
 Lef=(dvano2*1e-3)*2.5;
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
Fq_vano2= F_001*C1*q2^(-C2-C3*log10(q2)); %minimo de atenuacion de la luvia en el q% del año
% Ueq=1.5*100*(MTTR/MTBF);
% Utotalvano1=Ueq+q;

MD_vano2 = Fq_vano2;

K = 1.381e-23;
Bn = Rb/log2(M);

T0 = 290;
T1 = T0*(Lt - 1);
T2 = T0*(figura_ruido_rx - 1);
T_total = T0/Lt + T1/Lt + T2;

% deltaEb_N0 = (0.47*(CIR-3)); %degradacion
Umbral_ideal_dBm = Eb_N0 + 10*log10(K*T_total*Rb) + 30; % + deltaEb_N0;

%VANO B-C
gamma_gases =0.06;
Lgases_vano2_dB = gamma_gases*dvano2/1000;
Lbf_vano2_dB =20*log10(4*pi*dvano2/lambda);
Lb_vano2_dB=Lbf_vano2_dB+Lgases_vano2_dB;
Prxcn_vano2_dBm = Ptx_vanoBC_dBm + G_dB - Lt_dB - Lb_vano2_dB + G_dB - Lt_dB;
Umbral_real_dBm = Prxcn_vano2_dBm - MD_vano2;
% MD_vano2=Prxcn_vano2_dBm-Umbral_dBm;

deltaEb_N0 = Umbral_real_dBm - Umbral_ideal_dBm;
CIR_dB = (deltaEb_N0 + 3)/0.47;

%VANO D-C
distancia_EC = sqrt(7e3^2+5e3^2);
Lbf_vanoEC_dB =20*log10(4*pi*distancia_EC/lambda);
Lb_vanoEC_dB=Lbf_vanoEC_dB+Lgases_vano2_dB;
Prxcn_vanoEC_dBm = Ptx_vanoBC_dBm + G_dB - Lt_dB - Lb_vanoEC_dB + G_dB - Lt_dB;

% CIR
D1salida = 20;
D2salida = 15;
alfa_DC = asind(5e3/distancia_EC);
alfa_CD = 180 - (90 + alfa_DC);
I1 = Ptx_vanoBC_dBm - Lt_dB + G_dB - D1salida - Lb_vano2_dB + G_dB - Lt_dB;
% I2 = Ptx_vanoBC_dBm - Lt_dB + G_dB - Lb_vano2_dB + G_dB - D1salida - Lt_dB;
Itotal = 10^(-(CIR_dB - Prxcn_vano2_dBm)/10);
Itotal = 10*log10(Itotal);
I2 = 10^((Itotal-I1)/10);
I2 = 10*log10(I2);
Ptx_vanoBC_dBm = I2 + Lt_dB - G_dB - D2salida + Lb_vanoEC_dB - G_dB + Lt_dB;
% CIR_W = (1e-3*10^(Prxcn_vano2_dBm/10))/(10^(I1/10));
% CIR_dB = 10*log10(CIR_W);
