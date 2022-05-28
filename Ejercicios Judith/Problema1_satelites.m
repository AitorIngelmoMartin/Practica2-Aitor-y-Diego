
clc; clear;

%datos

BW_tpdr = 36e6;

"Banda C"
"FDMA"
"QPSK"

M = 4;

f_up = 6e9;
f_down = 4e9;

n_tpdor = 76;
Rb =  8e6;

BW_g = 3.5e6;

FEC = 5/6;

PIRE_sat_dBW = 39;
G_T_sat = -2.8;
SFD_dBW = -90.5; %saturatioon flux density (FLUJO) en dBW/m^2



PIREmax_est_dBW = 68;
G_T_est = 28;

d = 36e6;
Lt_dB = 1;

%--------------------------------------------------------------------------

%1)	La posición de las portadoras en el transpondedor, y el ancho de banda ocupado por 
% cada una de ellas si la modulación utilizada es QAM y el factor de roll-off del 
% filtro de coseno alzado es 0,4
roll_off = 0.4;

N = 5;
BW = (6016-5980)*1e6;
BW_portadoras = BW_tpdr-2*BW_g;

distancia_portadoras = BW_portadoras/(N-1);
f_p1 = 5980e6 + BW_g;
f_p2 = f_p1 + distancia_portadoras;
f_p3 = f_p2 + distancia_portadoras;
f_p4 = f_p3 + distancia_portadoras;
f_p5 = f_p4 + distancia_portadoras;

Rbcod=Rb*(6/5);
Bportadora=(1+roll_off)*Rbcod/log2(M);


%2)	¿Cuál es la C/N0TOTAL mínima necesaria en el enlace si el objetivo de calidad
% es mantener una BER=10-12 se cumple para una Eb/N0 de 14dB?
Eb_N0_dB = 14;

C_N0_dB = Eb_N0_dB + 10*log10(Rb);


%3)	El punto óptimo de trabajo del transpondedor. ¿Cuál es el valor de C/N0 para el
% punto de trabajo óptimo? ¿Cumple el C/N0TOTAL con el objetivo de calidad?

IBO_tpdr = [-3 -4 -5];
OBO_tpdr = IBO_tpdr + 6-6*exp(IBO_tpdr/6);

%4) Identifica en el EJERCICIO 1 los parámetros del enlace ascendente y del descendente

"Ascendente: G/T del satelite, PIRE de la estación terrena, la IBO de portadora y las pérdidas"
"Descendente: G/T de la estación terrena, PIRE del satélite, la OBO de portadora y las pérdidas"

%5) Calcula la C/No del enlace ascendente y descendente y a partir de ellas la C/No total del 
% sistema para cada punto de trabajo.

%perdidas
c = 3e8;

lambda_up = c/f_up;
lambda_down = c/f_down;

% Margen = 0.5 + 0.5 + 1;

% Lgases_up_dB = 0.009;
% Lgases_down_dB = 0.008;

% Lnubes_up_dB = 0.19;
% Lnubes_down_dB = 0.16;

Lad_up_dB =  1;
Lad_down_dB =  1;

Margen = 1.5;

Lbf_up_dB = 20*log10(4*pi*d/lambda_up);
Lb_up_dB =Lbf_up_dB + Lad_up_dB;

Lbf_down_dB = 20*log10(4*pi*d/lambda_down);
Lb_down_dB =Lbf_down_dB + Lad_down_dB;

%-----

% IBO_tpdr = [-3 -4 -5];
% OBO_tpdr = IBO_tpdr + 6-6.^IBO_tpdr/6;

C_I0 = [86.3 87.7 88.5]; %C_N_IM

K = 1.381e-23;
BW_total_portadoras = 3*BW_portadoras;


IBO_ptdr = IBO_tpdr + 10*log10(BW_portadoras/BW_total_portadoras);
OBO_ptdr = IBO_tpdr + 10*log10(BW_portadoras/BW_total_portadoras);

PIRE_et_dBW = SFD_dBW + 10*log10(4*pi*d^2) + Lad_up_dB;

PIRE_txmax_et_dBW = PIRE_et_dBW + IBO_ptdr;
PIRE_satmax_dBW = PIRE_sat_dBW + OBO_ptdr;

C_N0_up = PIRE_et_dBW + IBO_ptdr - Lbf_up_dB - Lad_up_dB - Margen + G_T_sat - 10*log10(K);
C_N0_down = PIRE_sat_dBW + OBO_ptdr - Lbf_down_dB - Lad_down_dB - Margen+ G_T_est - 10*log10(K);

c_n0_total  = 1./(1./(10.^(C_N0_up./10))+ 1./(10.^(C_N0_down./10)) + 1./(10.^(C_I0./10)));
C_N0_total = 10*log10(c_n0_total);

G_T = C_N0_total - PIRE_satmax_dBW + Lbf_down_dB + Margen + Lad_down_dB + 10*log10(K);