

clear;clc;

f = 880e6;
c=3e8;
lambda= c/f;
d = 34e3;

G_dB = 23;
Lt_dB = 2; 
MD_atenuador_dB = 15;
Umbral_dBm = -86;

%otros datos

Lt = 10^(Lt_dB/10);


"Polarización Horizontal"
figura_ruido_dB = 8;
figura_ruido = 10^(figura_ruido_dB/10);
MD_CAG_dB = 15;
R_001 = 26; %mm/h


%--------------------------------------------------



Lad_dB = 12.4213;



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

gamma_gases = 0.003;
Lgases_dB = gamma_gases*d/1000;
Lbf_dB = 20*log10(4*pi*d/lambda);
Lb_dB =Lbf_dB + Lgases_dB + Lad_dB;

% Prec_atenuador = Umbral_dBm + MD_dB = Ptx_dBm + G_dBi - Lt_dB - Lb_dB + G_dBi - Lt_dB; Para atenuador variable
% MD_dB = Ptx_dBm - Umbral_dBm + Gtx_dB - Lt_tx_dB - Lb_dB + Grx_dB - Lt_rx_dB;


% MD_dB = Prec_CN_dBm - Umbral - 30;
Prec_dBm = MD_atenuador_dB + Umbral_dBm;
% Prec_CN_dBm = Ptx_dBm + Gtx_dB - Lt_tx_dB - Lb_dB + Grx_dB - Lt_rx_dB;
Ptx_dBm = Prec_dBm - G_dB + Lt_dB + Lb_dB - G_dB + Lt_dB;
PIRE_dBm = Ptx_dBm + G_dB - Lt_dB;
FLUJO = 10^(PIRE_dBm/10)/(4*pi*d^2*10^(Lad_dB/10));
FLUJO_dBm = 10*log10(FLUJO);
%--------------------------



%APARTADO B

f = 25;
K = 1.381e-23;
T0 = 290;
T1 = T0*(Lt - 1);
T2 = T0*(figura_ruido - 1);
T_total = T0/Lt + T1/Lt + T2;


gamma_gases = 0.15;
Lgases_dB = gamma_gases*d/1000;

Lbf_dB = 20*log10(4*pi*d/lambda);
Lb_dB =Lbf_dB + Lgases_dB + Lad_dB;

PIRE_W = 10^(Flujo_dBW/10)*(4*pi*d^2)*(10^(Lad_dB/10));

Prec_dBW = 10*log10(PIRE_W) + G_dB - Lb_dB - Lt_dB;

%otra forma
% S_eff = lambda^2/(4*pi);
% Prec_dBW = Flujo_dBW + 10*log10(S_eff) + G_dB - Lt_dB;
 
CN0R_total = Prec_dBW - 10*log10(K*T_total);


%APARTADO C campo parásito:causado por XPD lluvia

U = 15 + 30*log10(f);

if (f>8 && f<=20)
    V = 12.8*f^0.19;
elseif (f>20 && f<=35)
    V = 22.6;
end

Fll_dB = MD_CAG_dB;
XPD_ll = U - V*log10(MD_CAG_dB);

EespacioLibre = sqrt(10^(Flujo_dBW/10)*120*pi);

EespacioLibre_dBu = 20*log10(EespacioLibre/1e-6);

E_CMD_dBu = EespacioLibre_dBu - MD_CAG_dB;

Eparasito_total_dBu = E_CMD_dBu - XPD_ll;