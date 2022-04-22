clc;clear;close all;

c = 3e8;
% Datos satelite transmisor
 Ku    = (14- 12)*1e9;
 Ptx_w = 98;
 Lt_dB = 0.9;
 G_dB  = 30.7;
 
 F_001_up = 5;
 f_up     = 14e9;
 f_down   = 12e9;
 
G_T_satelite = 3;
T_antena     = 93;

C_N0_total    = 76;
Distancia    = 38500e3;
Lgas_down_dB = 1;
Lt_dB        = 0.6;
F_001_down   = 7;
Lad_down_dB     = 0.8;

F_receptor_dB  = 5;
T_ruido_antena = 93;

Distancia = 39000e3;
Boltzmann = 1.38e-23;
Ptx_dBw   = 10*log10(Ptx_w);

%1) ¿Cuál es la G/T de las estaciones receptoras domésticas?

lambda_down = c/f_down;
lambda_up = c/f_up;
Dish = 60/100;
G_estacion_receptora = 0.6*(pi*((Dish/lambda_down)^2));
G_estacion_receptora_dB = 10*log10(G_estacion_receptora)

Lcable_dB = 0.6;
Lcable    = 10^(Lcable_dB/10);

Freceptor_dB = 5;
Freceptor    = 10^(Freceptor_dB/10);

T0 = 290;
T_total_receptor = T_antena + T0*(Lcable - 1) + T0*(Freceptor-1)*(Lcable)

G_T_receptor_dB  = G_estacion_receptora_dB - 10*log10(T_total_receptor)


% 2)¿Cuál es la degradación debida al enlace ascendente del sistema 
% suponiendo que la estación receptora dispone de un CAG?
Ptx_dBw = 10*log10(Ptx_w);
PIRE_sat_dBW = Ptx_dBw + G_dB - Lt_dB;

Lbf_down_dB = 20*log10((4*pi*Distancia)/lambda_down);
Lbf_up_dB = 20*log10((4*pi*Distancia)/lambda_down);

Margen = 1.5;
C_N0_down = PIRE_sat_dBW - Lbf_down_dB - Lad_down_dB - Margen + G_T_satelite - 10*log10(Boltzmann);

Degradacion = C_N0_total - C_N0_down;
    %     Como no es mayor de 3 db, no es un enlace asimétrico

% 3)Si la estación terrena de la cabecera está equipada con un UPC (uplink power control),
% ¿Cuál es la PIRE en condiciones de cielo claro y en condiciones de máximo
% desvanecimiento para cumplir con la normativa de calidad?

M = 1.5;
PIRE_cielo_claro     = C_N0_total + Lbf_up_dB + M - G_T_receptor_dB + 10*log10(Boltzmann);
PIRE_desvanecimiento = C_N0_total + Lbf_up_dB + M - G_T_receptor_dB + 10*log10(Boltzmann) - F_001_up;
    % No he añadido Lad.
