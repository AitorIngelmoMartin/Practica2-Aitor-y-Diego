clc;clear;

%datos
d_tx = 36.01e6;
d_rx = 40.5e6;

disponibilidad = 99.99;
q = 100 - disponibilidad;

f_tpdor = 54e6;

"Banda C"
"FDMA"
"8-PSK"

M = 8;

f_up   = 14e9;
f_down = 12e9;

n_tpdor = 76;
Rb      =  16e6;

BW_g = 7.5e6;

FEC      = 7/4;
roll_off = 0.286;

%satelite
PIRE_sat_dBW = 50;
G_T_sat      = 7.5;
SFD_dBW      = -85.5; %saturatioon flux density (FLUJO) en dBW/m^2

%estacion terrena rx
G_T_etrx = 31;

%perdidas
c = 3e8;

lambda_up   = c/f_up;
lambda_down = c/f_down;

Margen = 0.5 + 0.2;

Lgases_up_dB   = 0.12;
Lgases_down_dB = 0.10;

Lnubes_up_dB   = 0.19;
Lnubes_down_dB = 0.16;

Lad_up_dB   =  Margen + Lgases_up_dB + Lnubes_up_dB;
Lad_down_dB =  Margen + Lgases_down_dB + Lnubes_down_dB;

Lbf_up_dB  = 20*log10(4*pi*d_tx/lambda_up);
Lb_up_dB   = Lbf_up_dB + Lad_up_dB;

Lbf_down_dB = 20*log10(4*pi*d_rx/lambda_down);
Lb_down_dB  = Lbf_down_dB + Lad_down_dB;

"UPC para enlace ascendente"
"CAG para enlace descendente"

%------------------------------------------------------------

%EJERCICIO 1

Eb_N0 = 13.15; % de la tabla

C_N0 = Eb_N0 + 10*log10(Rb);

%-------------------------------------------------

%EJERCICIO 2

IBO_tpdr = [-8.5 -9 -9.5 -10 -10.5 -11];
OBO_tpdr = [-3.877 -4.212  -4.561 -4.924 5.299 -5.686];

C_I = [17.918 18.424 18.907 19.374 19.828 20.279]; %C_N_IM

BN = Rb*FEC/log2(M); %ancho de banda de ruido de la portadora

C_I0 = C_I * BN; % C_NO_IM (de intermodulacion)

%------------------------------------

%EJERCICIO 3 y EJERCICIO 4

K = 1.381e-23;
BW_total = (1 + roll_off)*(Rb*FEC/log2(M));
BW_ptdr = 13;

IBO_ptdr = IBO_tpdr + 10*log10(BW_ptdr/BW_total);
OBO_ptdr = IBO_tpdr + 10*log10(BW_ptdr/BW_total);

PIRE_et_dBW = SFD_dBW + 10*log10(4*pi*d_tx^2) + Lad_up_dB;

PIRE_txmax_et_dBW = PIRE_et_dBW + IBO_ptdr;
PIRE_satmax_dBW = PIRE_sat_dBW + OBO_ptdr;

C_N0_up = PIRE_et_dBW + IBO_ptdr - Lbf_up_dB - Lad_up_dB - Margen + G_T_sat - 10*log10(K);
C_N0_down = PIRE_sat_dBW + OBO_ptdr - Lbf_down_dB - Lad_down_dB - Margen + G_T_etrx - 10*log10(K);

%EJERCICIO 5

c_n0_total  = 1./(1./(10.^(C_N0_up./10))+ 1./(10.^(C_N0_down./10)) + 1./(10.^(C_I0./10)));
C_N0_total = 10*log10(c_n0_total);
