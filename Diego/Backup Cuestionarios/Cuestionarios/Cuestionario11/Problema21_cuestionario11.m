clc;clear;

c = 3e8;
f = 18e9;
lambda = c/f;

Rb = 20e6;
M = 16;
"16 QAM"
roll_off = 0.3;
degradacion = 1;

G_dB = 36;
G = 10^(G_dB/10);

Lt_dB = 2;
Lt = 10^(Lt_dB/10);
figura_ruido_rx_dB = 8;
figura_ruido_rx = 10^(figura_ruido_rx_dB/10);

CNR_ideal = 10;

MTTR = 4;
MTBF = 250e3;

R_001 = 34;
alpha = 1.0818;
k = 0.0708;

Boltzman    = 1.381e-23;

% BW_total = ZS1 +(N-1)*SC +YS + (N-1)*SC + ZS2;
BW_total = (13.25 - 12.75)*1e9;
ZS1 = 15e6; %guarda1
YS = 70e6; %separacion entre direcciones
ZS2 = 23e6; %guarda2
SC = 28e6;
