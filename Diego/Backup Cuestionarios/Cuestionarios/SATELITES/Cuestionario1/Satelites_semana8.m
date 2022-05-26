
%SATÉLITES

%PROBLEMA 1

% Una estación terrena de un radioenlace por satélite trabaja a 
% una frecuencia de 12 GHz. Su antena tiene un diámetro de 60 cm y 
% un  rendimiento del 60%. Calcula la G/T de una estación terrena cuya 
% Temperatura de antena son 93K y está conectada a un LNA con factor de ruido de 5 dB mediante 
% una guía que introduce 0,6dB de perdidas.


clc;clear;

f = 12e9;
c = 3e8;
lambda = c/f;
diametro = 0.6;
rendimiento = 0.6;
T0 = 290;

T_antena = 93; %Kelvin
factor_ruido_LNA_dB = 5;
factor_ruido_LNA = 10^(factor_ruido_LNA_dB/10);
L_guia_dB = 0.6; %pérdidas en la guia
L_guia = 10^(L_guia_dB/10);

%solucion

G = rendimiento*(pi*diametro/lambda)^2;
G_dB = 10*log10(G);


T_antena_total = T_antena + T0*(L_guia-1)+ T0*(factor_ruido_LNA -1)*L_guia;

G_T = G_dB - 10*log10(T_antena_total);

%PROBLEMA 2

% La C/N0 objetivo de un enlace de comunicaciones por satélite que trabaja en la banda Ku (12 GHz, 14 GHz) es 72 dB. 
% La C/No del enlace ascendente es 75 dB. ¿En que punto de trabajo debe trabajar el satélite para cumplir con el objetivo 
% de calidad si la PIRE de saturación del satélite es de 48 dBW, la G/T de la estación terrena son 8 dB/K , las pérdidas por gases 
% atmosféricos en el enlace descendente son 0.4 dB y las pérdidas debidas a nubes son 0,8dB? ¿Cuál será la potencia que debe radiar el 
% satélite al enlace descendente? La distancia del satélite a la estación terrena receptora son 38000 km

clc; clear;

d = 36e6;

IBO_trpdor_dB = -3;
OBO_trpdor_dB = -0.9;

Flujo_satelite_dB = -90;
Flujo_satelite = 10^(Flujo_satelite_dB/10);

Lgases_dB = 0.8;
Lnubes_dB = 1.2;
Margen_dB = 1.5;

IBO_portadora_dB = IBO_trpdor_dB;

"Enlace ascendente"

K = 1.381e-23;
T_sat = 270;


%solucion

% % Flujo = PIRE_satelite/(4*pi*d^2);
% PIRE_satelite = Flujo_satelite*(4*pi*d^2);
% 
% %Lbf_dB = 20*log10(4*pi*d/lambda); 
% C = PIRE_satelite
% 
% C_N0 = PIRE_et + IBO_portadora_dB -Lbf - La - Margen_dB + G_T_sat - 10*log10(K);
% 
% PIRE = PIRE_et+ IBO_portadora_dB;


Lta_dB = Lnubes_dB + Lgases_dB + Margen_dB;

% Flujo_satelite = PIRE_et/(4*pi*d^2*Lta_dB);
PIRE_et = Flujo_satelite_dB + 10*log10(4*pi*d^2) + Lta_dB;
PIRE = PIRE_et + IBO_portadora_dB;


%PROBLEMA 3

% La C/N0 objetivo de un enlace de comunicaciones por satélite que trabaja en la banda Ku (12 GHz, 14 GHz) es 72 dB. La C/No del enlace ascendente es 75 dB. 
% ¿En que punto de trabajo debe trabajar el satélite para cumplir con el objetivo de calidad si la PIRE de saturación del satélite es de 48 dBW, la G/T de la estación terrena son 8 dB/K ,
% las pérdidas por gases atmosféricos en el enlace descendente son 0.4 dB y las pérdidas debidas a nubes son 0,8dB? ¿Cuál será la potencia que debe radiar el satélite al enlace descendente? 
% La distancia del satélite a la estación terrena receptora son 38000 km.

clc;clear;

d = 38e6;
c = 3e8;

C_N0_satelite_dB = 72;
C_N0_asc_dB =75;

PIRE_sat_dBW = 48;
G_T_et_dB = 8;

Lgases_dB = 0.4;


Lnubes_dB = 0.8;
Margen_dB = 1.5;

"Banda Ku (12Ghz, 14 GHz)"
f_as = 14e9;
f_des = 12e9;
K = 1.381e-23;

%solucion

lambda_des = c/f_des;
Lbf_des_dB = 20*log10(4*pi*d/lambda_des);
Ldes_dB = Lbf_des_dB + Lnubes_dB + Lgases_dB + Margen_dB;

C_N0_des = 1/(1/10^(72/10)-(1/10^(75/10)));
C_N0_des_dB = 10*log10(C_N0_des);

%Balance del enlace decendente

% L = C_N0_sat_dB - C_N0_asc_dB;
% C_N = -10*log10(10^(-L/10)-1);
% C_N0_des_dB = C_N0_asc_dB + C_N;

%C_N0_des_dB = PIRE_sat + OBO_portadora - Ltdes_dB + G_T_et_dB - l0*log10(K)
OBO_portadora_dB = C_N0_des_dB - PIRE_sat_dBW + Ldes_dB - G_T_et_dB + 10*log10(K);

PIRE_dBW = PIRE_sat_dBW + OBO_portadora_dB;





%PROBLEMA 4


% Se desea situar 10 portadoras de 14 Mbps de forma equiespaciada en un transpondedor en
% banda Ku de 56 MHz dejando una banda de guarda en cada extremo del transpondedor de 1 MHz. 
% El ancho de banda del transpondedor se extiende desde 11900 MHz hasta 11956 MHz. Todas las
% portadoras están moduladas con una señal 16 QAM, usan un filtro de coseno alzado con un alfa
% de 0,2 y un codificación contra errores FEC de tasa de codificación 3/4. Calcula la frecuencia 
% de las tres primeras portadoras.

clear;clc;

N_portadoras = 10;
Rb = 14e6;
B_tpdr = 56e6;
B_guarda_tpdr = 1e6;

"Modulación 16-QAM"

alfa = 0.2; %factor de roll-off del coseno alzado
FEC = 3/4; %codificación contra errores

















%PROBLEMA 5

% Un enlace de satélite usa una portadora con una capacidad de 14 Mbps
% de información modulada con un esquema MOD-COD 16 QAM-FEC3/4 filtrada  
% con un filtro de coseno alzado de alfa de 0,2 . Si la Eb/No necesaria para 
% conseguir una BER = 10^-6 es de 13.2 dB, ¿Cuál seria la C/N0t mínima del enlace?

Rb = 14e6; %capacidad
"Modulacion 16-QAM"
alfa = 0.2; %factor de roll-off de coseno alzado
BER = 10e-6;
Eb_N0_dB = 13.2;

%solucion

C_N0_min_dB = Eb_N0_dB + 10*log10(Rb);







