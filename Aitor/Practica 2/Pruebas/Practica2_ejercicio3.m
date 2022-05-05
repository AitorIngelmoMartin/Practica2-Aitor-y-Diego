clc;clear;

R0     = 6370e3;
K = 4/3;
d      = 20.09e3;

lambda = 0.0909090909090909
% lambda = 0.0697674418604651
% lambda = 0.0401337792642141;

% CASO 803***********************
Difracc_O1 = -0.182918610211964
% Difracc_O1 = -0.208802238781151
% Difracc_O1 = -0.275300196625664;


Difracc_O2 = -0.401288521630443;
% Difracc_O2 =-0.458072262939894;
% Difracc_O2 =-0.603956091621655;
% ********************************

% CASO 815***********************
Difracc_O1 = [1.17092634738033];
% Difracc_O1 = [1.33661655584160];
% Difracc_O1 = [1.76229336804184];


Difracc_O2 = [-0.401288521630443];
% Difracc_O2 =[-0.458072262939894];
% Difracc_O2 =[-0.603956091621655];
% ********************************

Distancia_E1_O2 = 3.721e3;
Distancia_E1_O1 = 1.910e3;
Distancia_E2_O1 = d - Distancia_E1_O1;
Distancia_E2_O2 = d - Distancia_E1_O2;
e_O1 = 803;
e_O2 = 799;
h1   = 796+10;
h2   = 805+8;

Re     = R0*K;

if( (((Difracc_O1<0) ||(Difracc_O2<0) ) && (abs(Difracc_O1 -Difracc_O2)<0.5)) || (((Difracc_O1>0) && (Difracc_O2>0) ) && (abs(Difracc_O1 -Difracc_O2)<0.5)) )    "Método uno"        
        %Para Ldif(uve'1)
        Distancia_entre_obstaculos = Distancia_E1_O2-Distancia_E1_O1;

        flecha_A_prima         = Distancia_entre_obstaculos*Distancia_E1_O1/(2*Re);
        altura_rayo_A_prima    = ((h1-e_O2)*Distancia_entre_obstaculos/Distancia_E1_O2)+e_O2;
        Despejamiento_A_prima  = e_O1 + flecha_A_prima - altura_rayo_A_prima;

        R1_A_prima      = sqrt(lambda*Distancia_entre_obstaculos*Distancia_E1_O1/Distancia_E1_O2);
        Difracc_A_prima = sqrt(2)*(Despejamiento_A_prima/R1_A_prima)

        %Para Ldif(uve'2)
        flecha_2p             = Distancia_entre_obstaculos*Distancia_E2_O2/(2*Re);
        altura_rayo_B_prima   = ((h2-e_O1)*Distancia_entre_obstaculos/Distancia_E2_O1)+e_O1;
        Despejamiento_B_prima = e_O2 + flecha_2p - altura_rayo_B_prima;

        R1_B_prima      = sqrt(lambda*Distancia_entre_obstaculos*Distancia_E2_O2/Distancia_E2_O1);
        Difracc_B_prima = sqrt(2)*(Despejamiento_B_prima/R1_B_prima);
        
        Ldif_A_prima    = 6.9 + 20*log10(sqrt((Difracc_A_prima-0.1)^2+1)+Difracc_A_prima-0.1)
        Ldif_B_prima    = 6.9 + 20*log10(sqrt((Difracc_B_prima-0.1)^2+1)+Difracc_B_prima-0.1)
        
        Ldif_dB = Ldif_A_prima+Ldif_B_prima+10*log10((Distancia_E1_O2*Distancia_E2_O1)/(Distancia_entre_obstaculos*(Distancia_E1_O2+Distancia_E2_O2)))
end

% if( ( (Difracc_O1>0) && (Difracc_O2>0) ) && (abs(Difracc_O1 -Difracc_O2)>0.5) )
     "Método dos"
        
        Dentre_obs             = Distancia_E1_O2-Distancia_E1_O1;

        Flecha_02_prima        = (Dentre_obs*Distancia_E2_O2)/(2*Re);

        e_O2_prima             = ((h2-e_O1)*Dentre_obs/Distancia_E2_O1)+e_O1;

        Despejamiento_O2_prima = Flecha_02_prima+e_O2-e_O2_prima;

        Rfresnell_O2_prima     = sqrt(lambda*((Dentre_obs*Distancia_E2_O2)/(Dentre_obs+Distancia_E2_O2)));

        Difracc_O2_prima       = sqrt(2)*(Despejamiento_O2_prima/Rfresnell_O2_prima);

        Alpha         = atan(((Distancia*Dentre_obs)/(Distancia_E1_O1*Distancia_E2_O2))^(1/2));

        Ldif_V1       = 6.9 + 20*log10(sqrt( (Difracc_O1      -0.1)^2 +1) + Difracc_O1      -0.1);
        Ldif_V2_prima = 6.9 + 20*log10(sqrt(((Difracc_O2_prima-0.1)^2)+1) + Difracc_O2_prima-0.1);

        Tc            =(12 - 20*log10(2/(1 - (Alpha/pi))))*((Difracc_O2/Difracc_O1)^(2*Difracc_O1));

        Lad=Ldif_V1+Ldif_V2_prima-Tc
% end

if(Difracc_O2<-0.78 && Difracc_O1>-0.78)
    Ldif_01       = 6.9 + 20*log10(sqrt( (Difracc_O1      -0.1)^2 +1) + Difracc_O1      -0.1)
end

if(Difracc_O1<-0.78 && Difracc_O2>-0.78)
    Ldif_02       = 6.9 + 20*log10(sqrt( (Difracc_O2      -0.1)^2 +1) + Difracc_O2      -0.1)
end

if(Difracc_O2<-0.78 && Difracc_O1<-0.78)
   "Los obstáculos no afectan" 
end