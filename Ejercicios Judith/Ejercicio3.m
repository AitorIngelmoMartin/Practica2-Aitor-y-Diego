clc;clear;close all;


% Datos satelite transmisor
 Ku    = (14- 12)*1e9;
 Ptx_w = 98;
 Lt_dB = 0.9;
 G_dB  = 30.7;
 
 F_001_up = 5;
 f_up     = 14e9;
 f_down   = 12e9;
 
G_T_satelite_dB = 3;
T_antena        = 93;

C_N0_total_dB   = 76;
Distancia_up    = 38500e3;
Lgas_down_dB = 1;
Lt_up_dB        = 0.6;
F_001_down   = 7;
Lad_down_dB  = 0.8;
Lad_up_dB    = 1;
F_receptor_dB  = 5;
T_ruido_antena = 93;

Distancia_down = 39000e3;
Boltzmann = 1.38e-23;
Ptx_dBw   = 10*log10(Ptx_w);

%1) ¿Cuál es la G/T de las estaciones receptoras domésticas?

lambda_down = 3e8/f_down;
lambda_up   = 3e8/f_up;
Dish = 60/100;
G_estacion_receptora    = Dish*((Dish/lambda_down)*pi)^2;
G_estacion_receptora_dB = 10*log10(G_estacion_receptora);

Lcable_dB = 0.6;
Lcable    = 10^(Lcable_dB/10);

Freceptor_dB = 5;
Freceptor    = 10^(Freceptor_dB/10);

T0 = 290;
T_total_receptor = T_antena + T0*(Lcable - 1) + T0*(Freceptor-1)*(Lcable);

G_T_receptor_dB  = G_estacion_receptora_dB - 10*log10(T_total_receptor)

% 2)¿Cuál es la degradación debida al enlace ascendente del sistema 
% suponiendo que la estación receptora dispone de un CAG?
Ptx_dBw = 10*log10(Ptx_w);
PIRE_sat_dBW = Ptx_dBw + G_dB - Lt_dB;

Lbf_down_dB = 20*log10((4*pi*Distancia_down)/lambda_down);
Lbf_up_dB = 20*log10((4*pi*Distancia_up)/lambda_up);

Margen = 1.5;
C_N0_down_dB = PIRE_sat_dBW - Lbf_down_dB - Lad_down_dB - Margen + G_T_receptor_dB - 10*log10(Boltzmann);

L = C_N0_total_dB - C_N0_down_dB % Degradacion

    %     Como no es mayor de 3 db, no es un enlace asimétrico

% 3)Si la estación terrena de la cabecera está equipada con un UPC (uplink power control),
% ¿Cuál es la PIRE en condiciones de cielo claro y en condiciones de máximo
% desvanecimiento para cumplir con la normativa de calidad?

Incremento_C_N = -10*log10(10^(-L/10)-1)
C_N0_up        = 1/((10^(-C_N0_total_dB/10))-(10^(-C_N0_down_dB/10)));
C_N0_up_dB     = 10*log10(C_N0_up)

PIRE_cielo_claro = C_N0_up_dB + Lbf_up_dB + Margen + Lad_up_dB - G_T_satelite_dB + 10*log10(Boltzmann);
PIRE_max         = PIRE_cielo_claro + F_001_up; %sumando las perdidas maximas por lluvia