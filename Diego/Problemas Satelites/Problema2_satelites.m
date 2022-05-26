
clc;clear;close all;

Boltzmann       = 1.381e-23;
d       = 38200e3;
Rb              = 34e6;
BW_total        = 36e6;

M               = 16;
% LLuvia estación A
F_001_A = 9;
%LLuvia estación B
F_001_B = 16;

Eb_No_total_min = 12;
 
%Si el sistema está por debajo de este Eb/No
f_up   = 14e9;
f_down  = 11e9;

Lad_up_dB      = 0.2;
Lad_down_dB    = 0.3;

Margen_up_dB   = 1.3;
Margen_down_dB = 1.4;

G_T_satelite      = -5;
G_T_et     = 19.1;
PIRE_sat_dBW = 48;

% 1)Si la modulación utilizada es 16-PSK. ¿Cuál será el valor del factor de roll-off del
% filtro de coseno alzado utilizado en la transmisión si se utiliza una codificación 
% contra errores FEC 1/3? Existe una banda de guarda en los extremos de la banda de 0,15 MHz.

FEC = 1/3;
N = 17;
B_g = 0.15e6;
Rbcod = Rb/FEC;
Rs = Rbcod/(log2(M));
BW_portadoras = (BW_total- 2*B_g);
Roll_off     = (BW_portadoras/Rs)-1;

% Bportadora=B-2*Bg;
% Rcod=Rb*(1/Cod);
% Rs=Rcod/(log2(16));
% rolloff=(Bportadora/Rs)-1;

% 2)Obtenga el  parámetro de transmisión de las estaciones terrenas de ambas zonas 
% climáticas para que el enlace funcione con la calidad requerida durante
% el 99,99% del tiempo. Las estaciones terrenas deben ser equipadas con los 
% dispositivos UPC y CAG adecuados a cada zona climática.

%       Parámetros de transmisiñon son PIREet y G/Tet, que dan la C/N0total_minima

K = 1.38e-23;
c = 3e8;

lambda_up   = c/f_up;
lambda_down = c/f_down;

C_N0_total = Eb_No_total_min + 10*log10(Rb);

Lbf_down_dB = 20*log10(4*pi*d/lambda_down);
Lb_down_dB  = Lbf_down_dB + Lad_down_dB;

C_N0_down = PIRE_sat_dBW - Lbf_down_dB - Lad_down_dB - Margen_down_dB + G_T_et - 10*log10(K);

c_n0_up  = 1./(1./(10.^(C_N0_total./10))- 1./(10.^(C_N0_down./10)));
C_N0_up = 10*log10(c_n0_up);

Lbf_up_dB = 20*log10(4*pi*d/lambda_up);
Lb_up_dB =Lbf_up_dB + Lad_up_dB;

PIRE_et_dBW = C_N0_up + Lbf_up_dB + Lad_up_dB + Margen_up_dB - G_T_satelite + 10*log10(K);


% Flujo_sat     = (10^(PIRE_sat_dBW/10))/(4*pi*Distancia*Distancia);
% Flujo_sat_dBw = 10*log10(Flujo_sat);
% PIRE_et_dBW   = Flujo_sat_dBw + 10*log10(4*pi*Distancia^2) + Lad_up_dB +Margen_up_dB;