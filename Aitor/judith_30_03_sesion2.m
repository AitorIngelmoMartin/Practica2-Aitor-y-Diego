
clc;clear;


Distancia =36000e3;
PIRE_sat_dBw  = 48;
Lgas_dB   = 0.7;

OBO_dB = -1.3;

PIRE_total_dBw = PIRE_sat_dBw + OBO_dB -10*log10(8);


% *-*-*-*-*-*-*-*-*--*-*-*-*-

% Calcula la PIRE con la que deben transmitir 10 estaciones  iguales que comparten mediante FDMA un transpondedor de un satélite situado a 36000 km de la superficie terrestre, si el flujo necesario a la entrada del satélite son - 87 d B \frac{w}{m^{2}}
% −87dBm2w, y el enlace ascendente experimenta unas pérdidas debidas a gases atmosféricos de 0.5dB y a nubes de 0.3 dB

FLUJO_dBw = -87;
FLUJO_w   = 10^(FLUJO_dBw/10);
Lad_dB    = 0.5+0.3+1.5;
Lad       = 10^(Lad_dB/10);
% 0.5 por cada antena + 0.5 por desporalizacion
PIRE_w   = FLUJO_w*(4*pi*Distancia^2)*Lad;

PIRE_dBw =10*log10(PIRE_w)-(10*log10(10))

% *-*-*-*-*-*-*-*-*-*-*-*-*-*-*

% Calcula la PIRE con la que deben transmitir una estación de ancho de banda 5 MHz que comparte mediante FDMA un transpondedor de un satélite de 36 MHz con otras cuatro estaciones una de las cuales transmite un ancho de banda de 11MHz y las otras tres que transmiten 6 MHz cada una. El satélite está situado a 38500 km de la superficie terrestre, el flujo necesario a la entrada del satélite son - 90 d B \frac{W}{m^{2}}
% −90dB y el enlace ascendente experimenta unas pérdidas totales debidas a gases atmosféricos y a nubes de 0.5 dB
clear;clc;
Distancia = 38500e3;
FLUJO_dBw = -90;
FLUJO_w   = 10^(FLUJO_dBw/10)
Lad_dB    = 0.5+1.5;
Lad       = 10^(Lad_dB/10);
PIRE_w    = FLUJO_w*(4*pi*Distancia^2)*Lad


PIRE_5Mhz_dBw =10*log10(PIRE_w)-(10*log10(34/(5)))


% *-*-*-*-*-*-*

CNO_total = 79;

CNO_descendente = 80;

L = CNO_total -CNO_descendente

Incremento = -10*log10(10^(-L/10)-1)


% *-*-*-*-*-
clc;clear;


