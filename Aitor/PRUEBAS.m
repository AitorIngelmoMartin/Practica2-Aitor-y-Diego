clc;clear;

f      = 2.3e9;
c      = 3e8;
lambda = c/f;

Distancia =1910;
K =4/3;
h2 = 803;
h1 = 796+10;
R0 = 6370e3;
Re          = R0*K;

%OBSTACULO A---------
Distancia_E1_O1 = 806;
Distancia_E2_O1 = Distancia - Distancia_E1_O1;
e_O1            = 800;

Flecha_O1        = (Distancia_E1_O1*Distancia_E2_O1)/(2*K*R0);

AlturaRayo_O1    = ((h2-h1)/Distancia)*Distancia_E1_O1 + h1;

Despejamiento_O1 = Flecha_O1 + e_O1-AlturaRayo_O1;

Rfresnell_O1 = sqrt((lambda*Distancia_E1_O1*Distancia_E2_O1)/(Distancia_E1_O1+Distancia_E2_O1));

Difracc_O1   = sqrt(2)*(Despejamiento_O1/Rfresnell_O1)

