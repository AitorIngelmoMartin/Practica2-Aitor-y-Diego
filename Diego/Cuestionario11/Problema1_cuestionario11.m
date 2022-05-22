
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

alpha = 1.0818;
k = 0.0708;

"Atenuador Variable"

Utotal = 0.015;

%VANOS RADIOENLACE A-C
Ptx_AB_dBm  = 10.9;
Ptx_BC_dBm  = 27.1;

% Datos:
R_001 = 34;
% ΔEb/N0(dB) = (0,47·(CIR(dB)-3)) %degradación del umbral

% 1)INDISPONIBILIDAD DE EQUIPOS EN CADA VANO
Distancia = [10 21]*1000;
U_equipos = 2*(MTTR/MTBF)*100;

% 2)INDISPONIBILIDAD DE LLUVIA EN CADA VANO
q_total = Utotal -((2+2)*(MTTR/MTBF)*100);

numero_vanos = size(Distancia);
iteraciones  = numero_vanos(1,2);

for i = 1:iteraciones
 q(i) = q_total.*Distancia(i)/(sum(Distancia));
end

% 3)MD en el vano BC

gamma_R  = k* R_001^alpha; %dB/Km
% Deff     = (Distancia)./(0.477*(Distancia.^0.633)*(R_001^(0.073*alpha))*(f^(0.123))-10.579*(1-exp(-0.024*Distancia))); %Km

d_eff=(0.477*(Distancia*1e-3).^0.633*R_001^(0.073*alpha)*(f*1e-9)^0.123)-(10.579*(1-exp(-0.024*(Distancia*1e-3))));

%Paso 4

if d_eff<0.4
 Lef=(Distancia*1e-3).*2.5;
else
 Lef=(Distancia*1e-3)./d_eff;
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

Fq_dB =  F_001.*C1.*(q.^(-(C2+C3.*log10(q))));

MD = Fq_dB;

%4)UMBRAL REAL

K = 1.381e-23;
Bn = Rb/log2(M);

T0 = 290;
T1 = T0*(Lt - 1);
T2 = T0*(figura_ruido_rx - 1);
T_total = T0/Lt + T1/Lt + T2;


% deltaEb_N0 = (0.47*(CIR-3)); %degradacion
Umbral_ideal_dBm = Eb_N0 + 10*log10(K*T_total*Rb) + 30; % + deltaEb_N0;

%5)6) CIR y UMBRAL REAL
%VANO B-C
gamma_gases =0.06;
Lgases_dB = gamma_gases*Distancia/1000;
Lbf_dB =20*log10(4*pi*Distancia/lambda);
Lb_dB=Lbf_dB+Lgases_dB;
Ptx_dBm  = [Ptx_AB_dBm Ptx_BC_dBm];
PIRE_dBm = Ptx_dBm +G_dB -Lt_dB;
Prxcn_dBm = Ptx_BC_dBm + G_dB - Lt_dB - Lb_dB + G_dB - Lt_dB;
Umbral_real_dBm = Prxcn_dBm - MD;

deltaEb_N0 = Umbral_real_dBm - Umbral_ideal_dBm;
CIR_dB = (deltaEb_N0 + 3)/0.47;

%7) Potencia interferente total que cumple el criterio de CIR
Itotal = Prxcn_dBm(2) - CIR_dB(2);

%8) Potencia interferente debida al vano BA
D1salida = 20;
I1 = Ptx_AB_dBm - Lt_dB + G_dB - D1salida - Lb_dB(2) + G_dB - Lt_dB;
% Como todo es comolar, la XPD no se tiene en cuenta. Como concide con la
% direccion de máxima radiacion de C, no hay discriminación de entrada.

%9) Potencia interferente debida al vano EC

I2 = 10^(Itotal/10) - 10^(I1/10);
I2 = 10*log10(I2);

%10) Potencia máxima transmitida por la estación D en el vano DE
%VANO D-C
distancia_DC = sqrt(7e3^2+5e3^2);
% alfa_DC = asind(5e3/distancia_DC);
alfa_DC = atand(5/7);
% alfa_CD = 180 - (90 + alfa_DC);
alfa_CD = atand(7/5);
D2salida = 14;
D2llegada =20;

Lbf_DC_dB =20*log10(4*pi*distancia_DC/lambda);
gamma_gases =0.06;
Lgases_DC_dB = gamma_gases*distancia_DC/1000;
Lb_DC_dB=Lbf_DC_dB+Lgases_DC_dB;

% Prxcn_DC_dBm = Ptx_DC_dBm + G_dB - Lt_dB - Lb_DC_dB + G_dB - Lt_dB;
% Ptx_DC_dBm = I2 - G_dB + D2salida + Lt_dB + Lb_DC_dB + G_dB + D2llegada +Lt_dB;
Prx_D_dBm = I2 - (+ G_dB - Lt_dB - D2salida - Lb_DC_dB + G_dB - Lt_dB - D2llegada);



