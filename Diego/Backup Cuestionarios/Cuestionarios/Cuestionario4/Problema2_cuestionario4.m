clear;clc;close all;

f = 15e9;
c=3e8;
lambda = c/f;

D = 24000; % 24Km

Ptx_w = (1/1000)*(10^(24/10));
Ptx_dBw = 10*log10(Ptx_w);

Perdida_guia = (5/100)*33; %En dBm
Perdida_alimentador = 0.5; %dB

Lt_dB =  Perdida_guia +Perdida_alimentador;
Lt = 10*10^(Lt_dB/10);

% Pérdidas en espacio libre
Lbf_dB = 20*log10((4*pi*D)/lambda)
Lbf    = 10^(Lbf_dB/10);
% PIRE en dBw y W
g_dB=28;
g = 10^(g_dB/10);

PIRE_dBw = Ptx_dBw + g_dB - Lt_dB;
PIRE_w = 10^(PIRE_dBw/10);

% Flujo en dBw/m2
Flujo     = (PIRE_w)/(4*pi*D*D);
Flujo_dBw = 10*log10(Flujo)

e       = sqrt(Flujo*120*pi);
e_dBu   = 20*log10(e/1e-6);

% Cálculos adicionales
Seff    = ((lambda^2)/(4*pi))*g
Seff_dB = 10*log10(Seff);

Prx     = Ptx_w*g*(1/Lt)*(1/Lbf)*g*(1/Lt)
Prx_log = 10*log10(Prx)
Prx_dBw = Ptx_dBw + g_dB + g_dB -Lbf_dB -Lt_dB -Lt_dB 