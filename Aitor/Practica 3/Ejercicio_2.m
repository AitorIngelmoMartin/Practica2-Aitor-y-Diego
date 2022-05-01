clc;clear;

%datos

M    = 8;
Rb   = 16e6;
FEC  = 7/4;

%EJERCICIO 2

IBO_tpdr = [-8.5 -9 -9.5 -10 -10.5 -11];
OBO_tpdr = [-3.877 -4.212  -4.561 -4.924 5.299 -5.686];

C_I = [17.918 18.424 18.907 19.374 19.828 20.279]; %C_N_IM

BN = Rb*FEC/log2(M); %ancho de banda de ruido de la portadora

C_I0 = C_I * BN; % C_NO_IM (de intermodulacion)
