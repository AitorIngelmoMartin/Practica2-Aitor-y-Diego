clc;clear;

% Un radioenlace a 18 GHz implementado en torno a un puerto para manejar toda
% la información que se genera en las actividades propias del puerto 
% (vigilancia, transporte de mercancías,…), está compuesto por las 
% estaciones terminales A y C y la estación nodal B. 
% La indisponibilidad total del enlace es 0,015%.
f       = 18e9;
lambda  = 3e8/f;
U_total = 0.015;
% Las características de las estaciones A, B y C son las siguientes:
% • Modulación 16QAM
M = 16;
% • Capacidad = 16 Mbps
Rb = 16e6;
% • G = 41,2 dB
G_dB = 41.2;
% • Lt = 1,3 dB
Lt_dB = 1.3;
Lt    = 10^(Lt_dB/10);
% • Freceptor = 9 dB
F_receptor_dB = 9;
F_receptor    = 10^(F_receptor_dB/10);
Boltzman      = 1.381e-23;
% • La Eb/N0 requerida idealmente para una BER máxima de 0,0001 es 12,5 dB
Eb_No_ideal = 12.5;
% Las estaciones cuentan con un atenuador variable para compensar las variabilidades de la señal recibida
% • Polarización horizontal
Gamma_gases  = 0.06;
K_lluvia     = 0.07078;
Alpha = 1.0818;
% • MTBF=7,5·10^5 horas y MTTR=6 horas
MTBF = 7.5e5;
MTTR = 6;
% En el vano de AB la potencia transmitida es 10,9dBm, mientras que en 
% el vano BC la potencia transmitida es 27,1dBm.
Ptx_AB_dBm = 10.9;
Ptx_BC_dBm = 27.1;
% El reparto de indisponibilidad por lluvia puede asignarse proporcionalmente
% directa a la longitud de cada vano. 
% En el mismo escenario existe otro radioenlace ED que reutiliza las misma 
% frecuencias que el radioenlace de interés AC.

% Se pide determinar la potencia máxima de la estación D en condiciones de 
% no desvanecimiento para mantener la viabilidad del sistema en términos de 
% interferencia cocanal en la estación C. Considerar que los parámetros de 
% la estación D son iguales que los de las estaciones A, B y C.

% Datos:
R_001 = 34;
% ΔEb/N0(dB) = (0,47·(CIR(dB)-3)) %degradación del umbral

% 1)INDISPONIBILIDAD DE EQUIPOS EN CADA VANO
Distancia = [10 21]*1000;
U_equipos = 2*(MTTR/MTBF)*100;

% 2)INDISPONIBILIDAD DE LLUVIA EN CADA VANO
q_total = U_total -((2+2)*(MTTR/MTBF)*100);

numero_vanos = size(Distancia);
iteraciones  = numero_vanos(1,2);

for i = 1:iteraciones
 q(i) = q_total*Distancia(i)/(sum(Distancia));
end

% 3)MD en el vano BC
f=f/1e9;Distancia = Distancia/1000;

Gamma_r  = K_lluvia* R_001^Alpha; %dB/Km
Deff     = (Distancia)./(0.477*(Distancia.^0.633)*(R_001^(0.073*Alpha))*(f^(0.123))-10.579*(1-exp(-0.024*Distancia))); %Km
F_001    = Gamma_r * Deff; % dB

if(f>=10)
 C0 = 0.12+0.4*log10((f/10)^0.8);
else
 C0 = 0.12;    
end

C1 = (0.07^C0)  * (0.12^(1-C0));
C2 = (0.855*C0) + 0.5446*(1-C0);
C3 = (0.139*C0) + 0.043* (1-C0);

Fq_dB =  F_001.*C1.*(q.^(-(C2+C3.*log10(q))));

f=f*1e9;Distancia = Distancia*1000;

% 4)Umbral real
MD       = Fq_dB;
Ptx_dBm  = [Ptx_AB_dBm Ptx_BC_dBm];
PIRE_dBm = Ptx_dBm +G_dB -Lt_dB;

Lgases_dB   = Gamma_gases*Distancia/1000;
Lgases      = 10.^(Lgases_dB/10);
Lbf_dB      = 20*log10((4*pi*Distancia)/lambda);

Lb_dB = Lgases_dB + Lbf_dB;

Umbral_real_dBm    = PIRE_dBm -Lb_dB + G_dB - Lt_dB - MD + G_dB - Lt_dB

T0 = 290;
T_despues_lt = T0*(1/Lt) + T0*(Lt-1)*(1/Lt) + T0*(F_receptor-1)

Bn = Rb/log2(M);
% Prx_dBm  = Ptx_dBm - Lb_dB + (numero_vanos(1,2)+1)*( G_dB - Lt_dB)
Prx_BC_dBm =  Ptx_BC_dBm +G_dB - Lt_dB - Lb_dB(2) + G_dB - Lt_dB
Umbral_real_dBm  = Prx_BC_dBm - MD(2)
Umbral_ideal_dBm = Eb_No_ideal  + 10*log10(T_despues_lt*Boltzman*Rb) + 30


% INTERFERENCIA ESTACION B -> A
D1_B = 20; %Es la potencia con la que sale f2, la del vano AB.
Interferencia_B = Ptx_AB_dBm + G_dB - Lt_dB - D1_B - Lb_dB(2) + G_dB - Lt_dB;
% Como todo es comolar, la XPD no se tiene en cuenta. Como concide con la
% direccion de máxima radiacion de C, no hay discriminación de entrada.
% INTERFERENCIA ESTACION D
Distancia_DC   = sqrt( (5*5) +(7*7) );
Alfa_salida_D  = acosd(7/Distancia_DC);
Alfa_llegada_C = acosd(5/Distancia_DC);

D1_D = 15;
D2_D = 20;

% Interferencia_D

Incremento_Degradacion_umbral = Umbral_real_dBm - Umbral_ideal_dBm
CIR = (Incremento_Degradacion_umbral+3)/0.47
Interferenccia_total =Prx_BC_dBm - CIR;
Interferencia_D = 10^(Interferenccia_total/10) - 10^(Interferencia_B/10);
Interferencia_D = 10*log10(Interferencia_D);

Prx_D = Interferencia_D - (+ G_dB - Lt_dB - D1_D - Lb_dB(2) + G_dB - Lt_dB - D2_D)
% 47,48dBm