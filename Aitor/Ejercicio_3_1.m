clc;clear;

%datos
d_tx = 36.01e6;
d_rx = 40.5e6;
c    = 3e8;
K    = 1.381e-23;

f_tpdor = 54e6;
M       = 8;
f_up    = 14e9;
f_down  = 12e9;

n_tpdor = 76;
Rb      =  16e6;

BW_g = 7.5e6;

FEC      = 7/4;
roll_off = 0.286;

PIRE_sat_dBW = 50;
G_T_sat      = 7.5;
SFD_dBW      = -85.5; %saturatioon flux density (FLUJO) en dBW/m^2
G_T_etrx     = 31;


lambda_up   = c/f_up;
lambda_down = c/f_down;

Margen = 0.5 + 0.2;

Lgases_up_dB   = 0.12;
Lgases_down_dB = 0.10;

Lnubes_up_dB   = 0.19;
Lnubes_down_dB = 0.16;

Lad_up_dB   =  Margen + Lgases_up_dB + Lnubes_up_dB;
Lad_down_dB =  Margen + Lgases_down_dB + Lnubes_down_dB;
 
Lbf_up_dB   = 20*log10(4*pi*d_tx/lambda_up);

Lbf_down_dB = 20*log10(4*pi*d_rx/lambda_down);

IBO_tpdr = [-8.5 -9 -9.5 -10 -10.5 -11];

%EJERCICIO 3

BW_portadora        = (1 + roll_off)*(Rb*FEC/log2(M));
BW_total_portadoras = 4*BW_portadora;

IBO_ptdr = IBO_tpdr + 10*log10(BW_portadora/BW_total_portadoras);
OBO_ptdr = OBO_tpdr + 10*log10(BW_portadora/BW_total_portadoras);

PIRE_et_dBW = SFD_dBW + 10*log10(4*pi*d_tx^2) + Lad_up_dB;

PIRE_tx_et_dBW     = PIRE_et_dBW + IBO_ptdr;

PIRE_tx_et_Max_dBW = max(PIRE_tx_et_dBW);
