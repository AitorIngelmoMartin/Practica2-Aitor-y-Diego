clc;clear;

% Se pretende diseñar una red de radioenlaces con la configuración 
% representada en la figura adjunta que conecta tres estaciones terminales 
% a partir de repetidores activos situados en el emplazamiento D.

% La banda de trabajo seleccionada para ofrecer el servicio es 
% 13GHz (12,75 – 13,25 GHz) y la separación entre canales es de 28MHz. 
% Como primer paso del diseño se asume que todas las estaciones tienes
% propiedades similares

f = 13e9;
lambda = 3e8/f;
% - Ganancia 36dB
G_dB = 36;
% - Polarización horizontal

k = 0.03041;
alpha    = 1.1586;
% - Pérdidas en terminales 2dB
Lt_dB = 2;
% - CAG como mecanismo de protección frente a desvanecimientos
% - Figura de ruido 8dB
figura_ruido_rx_dB = 8;
% - MTTR=4h y MTBF=250.000h
MTTR = 4;
MTBF = 250000;
% - CNR_ideal=10dB 
CNR_ideal = 10;
% - Capacidad de 20Mbps modulados en 16QAM con un filtro de coseno alzado 
% con factor de roll-off 0,3 (degradación por el filtro de 1dB)
Rb = 20e6;
M  = 16;
roll_off = 0.3;
% - Diagrama de radiación de la antena (azul para polarización horizontal, rojo para polarización vertical)
% 1) Determinar el número de radiocanales que se puede ofrecer si ZS1=15MHz, ZS2=23MHz e YS=70MHz
BW_total = (13.25 -12.75)*1e9;
SC = 28e6;
ZS1 = 15e6;
YS = 70e6;
ZS2 = 23e6;

% BW_total = Guarda_1 +(N-1)*Separacion_canal + Separacion_direcciones + (N-1)*Separacion_canal + Guarda_2;
N = (((BW_total - YS - ZS1 - ZS2)/SC) +2)/2;

% Rb_bps = (Separacion_canal*log2(M))/(1+roll_off)
% 2) Determinar la potencia a transmitir en cada vano del enlace A-C 
% despreciando el efecto de las interferencias y la indisponibilidad por
% equipos en dicho enlace

Distancia = [28 23 14]*1e3;

Lt = 10^(Lt_dB/10);
figura_ruido_rx = 10^(figura_ruido_rx_dB/10);

K = 1.381e-23;
Bn = Rb/log2(M);

T0 = 290;
T1 = T0*(Lt - 1);
T2 = T0*(figura_ruido_rx - 1);
T_total = T0/Lt + T1/Lt + T2;


% UMBRAL REAL SIN EFECTO DE LAS INTERFERENCIAS
degradacion = 1;
Umbral_ideal_dBm = CNR_ideal  + 10*log10(T_total*K*Bn) + 30;
Umbral_real_dBm = Umbral_ideal_dBm + degradacion;


% POTENCIA TRANSMITIDA EN LOS VANOS A-D Y D-C
gamma_gases = 0.02;
Lgases_dB   = gamma_gases*Distancia/1000;
Lbf_dB      = 20*log10((4*pi*Distancia)/lambda);
Lb_dB = Lbf_dB + Lgases_dB;

PIRE_dBm = Umbral_real_dBm + Lb_dB - G_dB + Lt_dB;
Ptx_dBm = PIRE_dBm - G_dB + Lt_dB;


% 3) Comprobar la viabilidad del enlace A-B teniendo en cuenta el efecto sólo de las interferencias intrasistema cocanales y asumiendo que todas las estaciones transmiten con 4dBm: demostrar que la potencia recibida en condiciones normales es mayor que el umbral en cada vano.

% DATOS:
% CIR                                 Degradación del umbral
% CIR≥30dB                      1dB
% 20dB≤CIR<30dB          3dB
% 10dB≤CIR<20dB          10dB

% PRX EN LOS VANOS DESEADOS A-->D Y D-->B
Ptx_dBm = 4; 
Prxn_dBm = Ptx_dBm + G_dB - Lt_dB - Lb_dB + G_dB - Lt_dB;


% CIR ASUMIENDO COMO RECEPTORES DESEADOS D (A-->D) Y B (D-->B)

D_DAsalida = 67;
D_DCsalida = 67;

%NODO D (A-->D):

I_BD = Ptx_dBm - Lt_dB + G_dB - D_DAsalida - Lb_dB(3) + G_dB - Lt_dB;
I_CD = Ptx_dBm - Lt_dB + G_dB - D_DCsalida -Lb_dB(2) + G_dB - Lt_dB;

ItotalAB = 10^(I_BD/10) + 10^(I_CD/10);
ItotalAB = 10*log10(ItotalAB);

CIR_AD = Prxn_dBm(1) - ItotalAB;

% UMBRAL REAL EN LOS VANOS A-D Y D-B
Umbral_real_CIR_dBm = Umbral_real_dBm + 1;
%NODO B (D-->B):

I_AB = Ptx_dBm - Lt_dB + G_dB - D_DAsalida - Lb_dB(3) + G_dB - Lt_dB;
I_CB = Ptx_dBm - Lt_dB + G_dB - D_DCsalida - Lb_dB(2) + G_dB - Lt_dB;

ItotalDB = 10^(I_AB/10) + 10^(I_CB/10);
ItotalDB = 10*log10(ItotalDB);

CIR_DB = Prxn_dBm(3) - ItotalDB;

