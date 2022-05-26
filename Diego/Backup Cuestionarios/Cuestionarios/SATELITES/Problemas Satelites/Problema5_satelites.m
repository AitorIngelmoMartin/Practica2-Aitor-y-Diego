clc;clear;close all;

% Se desea planificar un sistema FDMA de comunicaciones por satélite en banda Ku (14GHz/12 GHz)
f_up   = 14e9;
f_down = 12e9;
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
    SFD_dBW              = -98;
    G_T_sat_dB               = 10;
    PIRE_saturacion_dBw  = 52; 

% Los parámetros de las estaciones terrenas son:
    G_antena_dB = 40;
    Tantena     = 22;
    Lt_dB       = 0.3;
    G_LNA_dB    = 40;
    FLNA_dB     = 0.5;
    
T0 = 290;
Ttotal_receptor = Tantena +T0*(10^(Lt_dB/10)-1) + T0*(10^(FLNA_dB/10)-1)*10^(Lt_dB/10);
    
% 1)Calcule la PIRE en cielo claro para cada estación terrena para el punto de saturación.
Eb_No = 11.7; % mirado en tabla
C_N_total = Eb_No + 10*log10(Rb);

Lbf_up_dB   = 20*log10((4*pi*Distancia)/f_up);
Lbf_down_dB = 20*log10((4*pi*Distancia)/f_down);

PIRE_cielo_claro = C_N_total + Lbf_up_dB + Lgas_up_dB + Margen_up_dB - G_T_sat_dB + 10*log10(Boltzmann)


% 2) Calcular la G/T de las estaciones terrenas.

G_T_terrena_dB  = C_N_total + Lbf_up_dB + Lgas_up_dB + Margen_up_dB - PIRE_saturacion_dBw  + 10*log10(Boltzmann)



% 3)Si el punto de trabajo óptimo es el definido por un IBO=-4 dB y 
% un OBO=-1,3 dB de salida, y la C/I0 para ese punto de trabajo es para todas
% las portadoras 83 dB, calcular la C/N0 total del sistema para cada portadora. 
% Compruebe que el sistema cumple con el objetivo de calidad para cada una 
% de las estaciones, y en caso de que para alguna de ellas no se 
% cumpla, proponga posibles soluciones para esa estación concreta


IBO_tpdr  = -4;
OBO_tpdr  = -1.3;
C_I0 = 83;

BW_portadora        = (1 + roll_off)*(Rb*FEC/log2(M));
BW_total_portadoras = BW_portadora
IBO_ptdr = IBO_tpdr + 10*log10(BW_portadora/BW_total_portadoras);
OBO_ptdr = OBO_tpdr + 10*log10(BW_portadora/BW_total_portadoras);


Lad_down_dB  = Lgas_down_dB + Margen_down_dB;
PIRE_sat_dBW = SFD_dBW + 10*log10(4*pi*Distancia^2) + Lad_down_dB;

Lad_up_dB   = Lgas_up_dB + Margen_up_dB;
PIRE_et_dBW   = SFD_dBW - 10*log10(4*pi*Distancia^2) - Lad_up_dB ;

C_N0_up_dB   = PIRE_et_dBW  + IBO_ptdr - Lbf_up_dB   - Lad_up_dB   - Margen_up_dB + G_T_sat_dB     - 10*log10(Boltzmann);
C_N0_down_dB = PIRE_sat_dBW + OBO_ptdr - Lbf_down_dB - Lad_down_dB - Margen_down_dB  + G_T_terrena_dB - 10*log10(Boltzmann);

c_n0_total  = 1./(1./(10.^(C_N0_up_dB./10))+ 1./(10.^(C_N0_down_dB./10)) + 1./(10.^(C_I0./10)));