clear;close all;clc;

f = 25e9;
c = 3e8;

lambda     = c/f;
Distancia  = 17e3;
alfa_gases = 0.15;

R0      = 6370000;
Lt_dB   = 1.5;

Lt = 10^(Lt_dB/10);
T0 = 290;

Boltzman = 1.381e-23;
G_PH_dB = 35;
G_PH    = 10^(G_PH_dB/10);

R_001   = 26;
CAG_dB  = 15;
h1      = 292;
h2      = 855;
K       = 4/3;

Difracc_A = 0;
Difracc_B = 0;

    %OBSTACULO A---------
    Distancia_E1_O1  = 3000;
    Distancia_E2_O1  = Distancia - Distancia_E1_O1;
    e_O1             = 396;
    %OBSTACULO B---------
    Distancia_E1_O2  = 10000;
    Distancia_E2_O2  = Distancia - Distancia_E1_O2;
    e_O2             = 642;
    

while( (Difracc_A >= -0.78) || (Difracc_B >= -0.78) )
    h2 = h2+0.1

    Flecha_A        = (Distancia_E1_O1*Distancia_E2_O1)/(2*K*R0);

    AlturaRayo_A    = ((h2-h1)/Distancia)*Distancia_E1_O1 + h1;

    Despejamiento_A = Flecha_A + e_O1-AlturaRayo_A;

    Rfresnell_A     = sqrt((lambda*Distancia_E1_O1*Distancia_E2_O1)/(Distancia_E1_O1+Distancia_E2_O1));

    Difracc_A       = sqrt(2)*(Despejamiento_A/Rfresnell_A);


    Flecha_B        = (Distancia_E1_O2*Distancia_E2_O2)/(2*K*R0);

    AlturaRayo_B    = ((h2-h1)/Distancia)*Distancia_E1_O2 + h1;

    Despejamiento_B = Flecha_B + e_O2 - AlturaRayo_B;

    Rfresnell_B     = sqrt((lambda*Distancia_E1_O2*Distancia_E2_O2)/(Distancia_E1_O2+Distancia_E2_O2));

    Difracc_B       = sqrt(2)*(Despejamiento_B/Rfresnell_B);
end

Lbf_dB       = 20*log10((4*pi*Distancia)/lambda)

Lgases_dB    = alfa_gases*Distancia/1000;

Lb_dB        = Lbf_dB+Lgases_dB;

% Tras lo terminales, el receptor presenta un figura de ruido de 8dB.
% Además, el receptor cuenta con un CAG como mecanismo de protección frente a desvanecimientos de 15dB. R0,01=26mm/h

% Determinar:
% a)	La altura mínima que tiene que tener la antena de la estación B para evitar pérdidas por difracción. 
        Hminima = h2-855
% b)	Si el flujo de potencia recibido en condiciones normales de propagación es de -94dBW/m^2, determinar la CN0R en condiciones normales.


Flujo_dBw    = -94; %dBw/m^2

Flujo_W      = 10^(Flujo_dBw/10);
PIRE_W_rx    = Flujo_W *(4 * pi*Distancia*Distancia)
PIRE_dBW_rx  = 10*log10(PIRE_W_rx)
Prx_dBW      = PIRE_dBW_rx - Lt_dB + G_PH_dB - Lb_dB


CAG      = 10^(CAG_dB/10);
F_CAG_dB = 8;
F_CAG    = 10^(F_CAG_dB/10);

T_antes_dispositivo = T0*(1/Lt) + T0*(Lt-1)*(1/Lt) +T0*(F_CAG-1)

CNoR = Prx_dBW-10*log10(Boltzman*T_antes_dispositivo)

% c)    Calcular el campo parásito que aparece en condiciones de máximo desvanecimiento
Distancia = Distancia/1000;f=f/(1e9);  

K_PH      = 0.1571;
Alpha_PH  = 0.9991;
Lgases_dB = 0.060*Distancia; 

Lespecifica_lluvia = K_PH *(R_001^Alpha_PH)  % dB/Km

termino1 = 0.477*(Distancia^0.633)*(R_001^(0.073*Alpha_PH))*(f^(0.123));
termino2 = 10.579*(1-exp(-0.024*Distancia));
Deff     = (Distancia)/(termino1-termino2) %Km

F_001_PH  = Lespecifica_lluvia* Deff % dB


if(f>=10)
 C0 = 0.12+0.4*log10((f/10)^0.8);
else
 C0 = 0.12;    
end

C1 = (0.07^C0)  * (0.12^(1-C0));
C2 = (0.855*C0) + 0.5446*(1-C0);
C3 = (0.139*C0) + 0.043* (1-C0);

MD_dB = CAG_dB;

logaritmo = log10(MD_dB/F_001_PH*C1);

soluciones_x =  [( -C2 + sqrt( C2*C2 -4*logaritmo*C3 ) )/(2*C3),( -C2 - sqrt( C2*C2 -4*logaritmo*C3 ) )/(2*C3)];
x = max(soluciones_x);
q = 10^x

% Fq_dB   = F_001_PH*C1*(q^(-(C2+C3*log10(q))))
Fq_dB = CAG_dB;

U = 15 + 30*log10(f);

if (f>8 && f<=20)
    V = 12.8*f^0.19;
elseif (f>20 && f<=35)
    V = 22.6;
end

XPD_ll = U - V*log10(Fq_dB);


Distancia = Distancia*1000;f=f*(1e9);  

EespacioLibre     = sqrt(Flujo_W*120*pi)

EespacioLibre_dBu = 20*log10(EespacioLibre/1e-6)


Eparasito_total_dBu = EespacioLibre_dBu - MD_dB - XPD_ll