clc;clear;close all;

% Se desea planificar un sistema FDMA de comunicaciones por satélite en banda Ku (14GHz/12 GHz)
f_up   = 14e9;
f_down = 12e9;
lambda_up = 3e8/f_up;
lambda_down = 3e8/f_down;
%8 estaciones terrenas, con 4 que transmiten a 3Mbps, 3 a 5Mbps y 1 a 10Mbps. 
Rb = [3 3 3 3 5 5 5 10]* 1e6;

roll_off = 0.4;
FEC      = 5/6;
M =4;

Lgas_up_dB = 0.5;
Margen_up_dB  = 1.5;
Boltzmann  = 1.38e-23;

Lgas_down_dB   = 0.5;
Margen_down_dB = 1.25;

Distancia = 39000e3;

% Los parámetros del satélite son:
    BW_transpondedor     = 36e6;
    BW_guarda            = 1.5e6;
    Flujo_satelite_dBw   = -98;
    G_T_sat_dB           = 10;
    PIRE_saturacion_dBw  = 52; 
% Los parámetros de las estaciones terrenas son:
    G_terrena_dB = 40;
    Tantena      = 22;
    Lt_dB        = 0.3;
    G_LNA_dB     = 40;
    FLNA_dB      = 0.5;
    
T0 = 290;
Ttotal_receptor = Tantena +T0*(10^(Lt_dB/10)-1) + T0*(10^(FLNA_dB/10)-1)*10^(Lt_dB/10)
    
% 1)Calcule la PIRE en cielo claro para cada estación terrena para el punto de saturación.
Eb_No        = 11.7; % mirado en tabla
C_N_total    = Eb_No + 10*log10(Rb);
BW_portadora = (1+roll_off)*(Rb*(1/FEC))/log2(M);
Lbf_up_dB    = 20*log10((4*pi*Distancia)/lambda_up);
Lbf_down_dB  = 20*log10((4*pi*Distancia)/lambda_down);


% + 0 + 10*log10(Rb/sum(Rb)) es el IBO portadora


% 2) Calcular la G/T de las estaciones terrenas.
G_T_terrena_dB  = G_terrena_dB - 10*log10(Ttotal_receptor)

% 3)Si el punto de trabajo óptimo es el definido por un IBO=-4 dB y 
% un OBO=-1,3 dB de salida, y la C/I0 para ese punto de trabajo es para todas
% las portadoras 83 dB, calcular la C/N0 total del sistema para cada portadora. 
% Compruebe que el sistema cumple con el objetivo de calidad para cada una 
% de las estaciones, y en caso de que para alguna de ellas no se 
% cumpla, proponga posibles soluciones para esa estación concreta

IBO_tpdr  = -4;
OBO_tpdr  = -1.3;
C_I0 = 83;

Eb_N0 = 11.5;
C_N0_objetivo = Eb_N0 + 10*log10(Rb);

PIRE_total = Flujo_satelite_dBw+10*log10(4*pi*(Distancia^2))+Lgas_up_dB+Margen_up_dB;
PIRE_up    = PIRE_total+10*log10(BW_portadora/sum(BW_portadora));
PIRE_down  = PIRE_saturacion_dBw +10*log10(BW_portadora/sum(BW_portadora));


C_N0_up   = PIRE_up   + IBO_tpdr - Lbf_up_dB - Lgas_up_dB   - Margen_up_dB   + G_T_sat_dB     - 10*log10(Boltzmann);
C_N0_down = PIRE_down + OBO_tpdr - Lbf_down_dB - Lgas_down_dB - Margen_down_dB + G_T_terrena_dB - 10*log10(Boltzmann);

BW_guarda = 2*(1.5e6);
BW_total_portadoras = 36e6 - BW_guarda;


c_n0_total  = 1./(1./(10.^(C_N0_up./10))+ 1./(10.^(C_N0_down./10)) + 1./(10.^(C_I0./10)));
C_N0_total  = 10*log10(c_n0_total);