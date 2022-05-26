clear;clc;

f = 28.5e9;
c=3e8;
lambda= c/f;
d = 21e3;

Lad_dB = 0;

G_dB = 42.8 - 19;

Lt_dB = 1;
Lt = 10^(Lt_dB/10);

figura_ruido_LNA_dB = 5;
figura_ruido_LNA = 10^(figura_ruido_LNA_dB/10);

G_LNA_dB = 15;
G_LNA = 10^(G_LNA_dB/10);

L_mezclador_dB = 8; %atenuacion
L_mezclador = 10^(L_mezclador_dB/10);

figura_ruido_CAG_dB = 10; % amplificador en frecuencia intermedia 
figura_ruido_CAG = 10^(figura_ruido_CAG_dB/10);

MD_CAG_dB = 18;

MTTR = 104; %en horas
MTBF = 880e3; %en horas
R_001 = 18; %mm/h
alpha_PH = 0.9679 ; %Para PH
k_PH = 0.2051;


T0 = 290; %temperatura normal en Kelvin
K = 1.381e-23; %constante de boltzman en J/K
Rb = 40e6; %capacidad del enlace en bps
roll_off = 0.4; %Factor filtro coseno alzado. Degradación del umbral: 1dBç
Ux = 1.5;
CNR_min_dB = 11;

"Modulación 16-QAM"
M=16;
"CAG"
%terreno seco



"Polarización Horizontal"


%---------------------------------------------------------------------------



%Paso 2
f = f/(1e9);
R_001_alpha = R_001^alpha_PH;
gamma_R = k_PH*R_001_alpha; % Atenuación específica (dB/Km)



%Paso 3 en radioenlace terrenal

d_eff = (d/1000)*1/(0.477*(d/1000)^0.633*R_001^(0.073*alpha_PH)*(f)^0.123 -(10.579*(1-exp(-0.024*(d/1000))))); % Correccion del rayo

%Paso 4

F_01 = gamma_R *d_eff; % En 1h/año la lluvia va a atenuar al menos F0.01
% Si F0.01 = MD, sistema indisponible 1h/año. %indisponibilidad = 0.01,
% %disponibilidad = 0.99

%Paso 5 


if (f>=10)
    C0 = 0.12 + 0.4*log10((f/10)^0.8);
else
    C0 = 0.12;
end

C1 = (0.07^C0)*(0.12^(1-C0));
C2 = (0.855*C0)+0.546*(1-C0);
C3 = (0.139*C0)+0.043*(1-C0);

% Fq = F_01*C1*q^(-C2-C3*log10(q)); %minimo de atenuacion de la luvia en el q% del año

Fq_dB = MD_CAG_dB;

%calcular la q teniendo Fq
ecuacion = [C3 C2 log10(Fq_dB/(F_01*C1))];
x = roots(ecuacion);
q1 = abs(10^x(1));
q2 = abs(10^x(2));

if(q1>q2)
    q = q1;
else
    q = q2;
end

UR_lluvia = q;
UR_total = q + (2*MTTR/MTBF) *100; %Indisponibilidad total, UR_lluvia + UR_equipos

%-----------------------------------------------

B = (1+roll_off)*Rb; %ancho de banda de la señal
Bn = Rb/log2(M); %ancho de banda de ruido

% Eb_No_dB = CNR_dB -10*log10(Rb/B);
% CNR_dB = Eb_No_dB + 10*log10(Rb/Bn);

T1 = T0*(Lt-1);
T2 = T0*(figura_ruido_LNA-1);
T3 = T0*(L_mezclador-1);
T4 = T0*(figura_ruido_CAG-1);

% T_tot = T0*G_LNA/(L_mezclador*Lt) + T1*G_LNA/(L_mezclador*Lt) + T2*G_LNA/L_mezclador + T3/L_mezclador + T4;
T_tot = T0/Lt + T1/Lt + T2 + T3/G_LNA + T4*L_mezclador/G_LNA;

% CNR_dB = Prec_total - 10*log10(K*T_tot*B);
Prec_total_dBm = CNR_min_dB + 10*log10(K*T_tot*Bn) + 30;

%perdidas
gamma_gases = 0.1;
Lgases_dB = gamma_gases*d/1000;

Lbf_dB = 20*log10(4*pi*d/lambda);
Lb_dB =Lbf_dB + Lgases_dB + Lad_dB;

%Prec_antena_dB = PIRE_dB - Lb_dB + G_dB - Lt_dB
% PIRE_dBm = Prec_total_dBm + Lb_dB - G_dB + Lt_dB;
% PIRE2_dBm = Prec_total_dBm + Lb_dB - G_dB + Lt_dB + L_mezclador_dB - G_LNA_dB;

%otro metodo
% Umbral = Eb_No_dB + 10*log10(K*T_tot*Rb);
% PIRE_dBm = Umbral - (-Lb_dB + G_dB - Lt_dB) + 30;

%NOTA: Para calcular la PIRE, la PREC debe encontrarse al principio del receptor.


%--------------------------------------------------







%-----------------------
%Apuntes
% degradacion = 1; %Ux degradacion
% T0 = 290;
% T1 = T0*(Lt-1);
% T2 = T0*(factor_ruido-1);
% T_total = T0/Lt + T1/Lt + T2;
% Umbral = CNR_min_dB+ 10*log10(K*T_total*Bn) + degradacion;

%Bn ancho d banda equivalente de ruido
%T_total = T
% Thx_dBW = CNR_dB + 10*log10(Boltzman*T_antes_dispositivo*Bn)+degradación

%Perdidas



% Prec_atenuador = Umbral_dBm + MD_dB = Ptx_dBm + G_dBi - Lt_dB - Lb_dB + G_dBi - Lt_dB; Para atenuador variable
% MD_dB = Ptx_dBm - Umbral_dBm + Gtx_dB - Lt_tx_dB - Lb_dB + Grx_dB - Lt_rx_dB;

Umbral = CNR_min_dB+ 10*log10(K*T_tot*Bn) + Ux;
% MD_dB = Prec_CN_dBm - Umbral - 30;
Prec_dBm = Umbral - MD_CAG_dB;
% Prec_CN_dBm = Ptx_dBm + Gtx_dB - Lt_tx_dB - Lb_dB + Grx_dB - Lt_rx_dB;
Ptx_dBm = Prec_dBm - G_dB + Lt_dB + Lb_dB - G_dB + Lt_dB;
PIRE_dBm = Ptx_dBm + G_dB - Lt_dB;
FLUJO = 10^(PIRE_dBm/10)/(4*pi*d^2*10^(Lad_dB/10));
FLUJO_dBW = 10*log10(FLUJO) - 30;
%--------------------------



%APARTADO B


% PIRE_W = 10^(Flujo_dBW/10)*(4*pi*d^2)*(10^(Lad_dB/10));
% 
% Prec_dBW = 10*log10(PIRE_W) + G_dB - Lb_dB - Lt_dB;
% 
% %otra forma
% % S_eff = lambda^2/(4*pi);
% % Prec_dBW = Flujo_dBW + 10*log10(S_eff) + G_dB - Lt_dB;
%  
% CN0R_total = Prec_dBW - 10*log10(K*T_total);

% Umbral = Eb_No_dB + 10*log10(K*T_tot*Rb) + Ux;
% %_-----------------------------
% % MD_dB = Prec_CN_dBm - Umbral - 30;
% Prec_dBm = MD_CAG_dB + Umbral_dBm;
% % Prec_CN_dBm = Ptx_dBm + Gtx_dB - Lt_tx_dB - Lb_dB + Grx_dB - Lt_rx_dB;
% Ptx_dBm = Prec_dBm - G_dB + Lt_dB + Lb_dB - G_dB + Lt_dB;
% PIRE_dBm = Ptx_dBm + G_dB - Lt_dB;
% FLUJO = 10^(PIRE_dBm/10)/(4*pi*d^2*10^(Lad_dB/10));
% FLUJO_dBm = 10*log10(FLUJO);




%--------------------------

%APARTADO C campo parásito:causado por XPD lluvia

U = 15 + 30*log10(f);

if (f>8 && f<=20)
    V = 12.8*f^0.19;
elseif (f>20 && f<=35)
    V = 22.6;
end

Fll_dB = MD_CAG_dB;
XPD_ll = U - V*log10(MD_CAG_dB);

% FLUJO_dBW = 

EespacioLibre = sqrt(10^(FLUJO_dBW/10)*120*pi);

EespacioLibre_dBu = 20*log10(EespacioLibre/1e-6);

E_CMD_dBu = EespacioLibre_dBu - MD_CAG_dB;

Eparasito_total_dBu = E_CMD_dBu - XPD_ll;

flujo1 = Eparasito_total_dBu - 10*log10(120*pi);

Seff = lambda^2*10^(G_dB/10)/4*pi;

PRX_PARA = flujo1 + 10*log10(Seff)
