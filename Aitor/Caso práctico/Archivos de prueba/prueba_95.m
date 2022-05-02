clc;clear;close all;

R_punto_medio_total =40.141518816862316;
MTBF = 175320; %En horas
MTTR = 24;
G_dB = 43.6;
R_punto_medio =40.141518816862316;

f         = 23e9;
lambda    = 3e8/(f);
Distancia_total = 55.1e3;

Distancia = 9.7*1e3;
% Umbral_dataSheet = [-85 -81.5 -75 -72 -68.5 -64.5];
Umbral_dataSheet = -68.5+2;
 
Lgas_dB = 0.16*((Distancia)/1000);
Lt_dB   = 1.5;
Lbf_dB  = 20*log10((4*pi*Distancia)/lambda);

 Prx_dBm          = -36.77 -2
 Umbral_dataSheet = -68.5 +2;
 Margen_dBm       = Prx_dBm - Umbral_dataSheet


 f        = f/(1e9);Distancia = Distancia/1000
 K_lluvia = 0.1286;

 Alpha    = 1.0214;     %Tabulando casi a 20 en PV

Gamma_r   = K_lluvia* R_punto_medio_total^Alpha %dB/Km
Deff      = (Distancia)/(0.477*(Distancia^0.633)*(R_punto_medio_total^(0.073*Alpha))*(f^(0.123))-10.579*(1-exp(-0.024*Distancia))) %Km

F_001     = Gamma_r * Deff % dB

 if(f>=10)
  C0 = 0.12+0.4*log10((f/10)^0.8);
 else
  C0 = 0.12;    
 end

 C1 = (0.07^C0)  * (0.12^(1-C0));
 C2 = (0.855*C0) + 0.5446*(1-C0);
 C3 = (0.139*C0) + 0.043* (1-C0);

 MD_dB = Margen_dBm
 logaritmo = log10(MD_dB/(F_001*C1));

 soluciones_x =  [( -C2 + sqrt( C2*C2 -4*logaritmo*C3 ) )/(2*C3),( -C2 - sqrt( C2*C2 -4*logaritmo*C3 ) )/(2*C3)];
 x =max(soluciones_x);
 q_calculado = 10^x
 

 Fq_calculado_dB = F_001*C1*(q_calculado^(-(C2+C3*log10(q_calculado))));