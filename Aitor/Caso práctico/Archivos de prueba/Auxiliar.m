clc;clear;
% Santiago de Compostela [42º 52' 35,3447=42.8763888889
% , -8º 32' 41,3360"] = -7.45527777778

% A Coruña [43º 21' 41,4892",  = 43.3613888889
% -8º 24' 41,4514"] = -7.58861111111

% Punto medio total          43.105521, -8.487165
% Punto medio mitad inferior 43.002501, -8.503177
% Pinto medio mitad superior 43.211341, -8.458397

% R_santiago = itur_p0837_7_annex1(0.01,42.8763888889,-7.45527777778,0)

% R_coruna   = itur_p0837_7_annex1(0.01,43.3613888889,-7.58861111111,0)

% R_punto_medio_total    = itur_p0837_7_annex1(0.01,43.105521,-8.487165,0)
  R_punto_medio_total =40.141518816862316;
% R_punto_medio_inferior =  itur_p0837_7_annex1(0.01,43.002501, -8.503177,0)
  R_punto_medio_inferior = 40.754813773852334;
% R_punto_medio_superior = itur_p0837_7_annex1(0.01,43.211341, -8.458397,0)
  R_punto_medio_superior =39.198960977634940;
% R_001_total = [R_punto_medio_inferior R_punto_medio_total R_punto_medio_superior]

MTBF = 175320; %En horas
MTTR = 24;

f         = 23e9;
lambda    = 3e8/(f)
Distancia = 55.1e3;
Distancia = Distancia/2;

% Disponibilidad por la lluvia        
    
 Ptx_dBm = 15.5;
 G_dB = 43.6;
 
 Lgas_dB = 0.16*(Distancia/1000);
 Lt_dB = 1.5;
 Lbf_dB = 20*log10((4*pi*Distancia)/lambda)
 
 Prx_dBm          = Ptx_dBm + G_dB - Lt_dB - Lbf_dB - Lgas_dB + G_dB - Lt_dB -2
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
 
 
 Equipos = 1.5*(MTTR/MTBF)*100;
 
 
 Total = 2*(q_calculado + Equipos)
 
 
 
 
 
    
    
