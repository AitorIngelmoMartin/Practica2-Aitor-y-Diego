clc;clear;close all;

c=3e8;

f_up   = 14e9;
f_down = 12e9;

lambda_up   = c/f_up;
lambda_down = c/f_down;


Distancia_up   = 36010e3;
Distancia_down = 40500e3;

Boltzman = 1.381e-23;
Rb = 16e6;
M = 1.2;
G_T_up = 7.5; %dB/K
G_T_down = 31; %dB/K

Lad_up_dB   = 0.31;
Lad_down_dB = 0.26;
PIRE_down_dBw    = 50;

Lbf_dB_up     = 20*log10((4*pi*Distancia_up)/lambda_up)
Lbf_dB_down   = 20*log10((4*pi*Distancia_down)/lambda_down)

C_No_Tmin = PIRE_down_dBw - Lbf_dB_down -Lad_down_dB - M + G_T_down - 10*log10(Boltzman)


Eb_No = C_No_Tmin - 10*log10(Rb);

Eb_No_grafica_dB = 13.15;
C_No_TminGrafica =Eb_No_grafica_dB + 10*log10(Rb)

