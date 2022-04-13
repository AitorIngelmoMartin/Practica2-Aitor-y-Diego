clear;clc;close all;
K      = 4/3;
c      = 3e8;
f      = [300,1300, 2300, 3300, 4300,7475,12650, 17825, 23000].*1e6;
lambda = c./f;
Distancia      = 20.09e3;
R0     = 6370e3;
Re     = R0*K;
h1     = 807;
h2=805+8;
e  = [796 800 803 799 735 760 788 805];
a  = [10 0 0 0 0 0 0 8];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 Distancia];
d2 = Distancia - d1;
d1(:,1)        =[];
d1(:,end)      =[];
e(:,1) = [];
e(:,end) = [];

%OBSTACULO A---------
Distancia_E1_O1 = d1(2);
Distancia_E2_O1 = Distancia - Distancia_E1_O1;
e_O1            = e(2);

Difracc_O1   = [-0.0551520361133051,-0.114808118378396,-0.152709073089100,-0.182918610211964,-0.208802238781151,-0.275300196625664,-0.358134521542571,-0.425124067513148,-0.482908490334681];


%OBSTACULO B---------
Distancia_E1_O2  = d1(3);
Distancia_E2_O2  = Distancia - Distancia_E1_O2;
e_O2             = e(3);

Difracc_O2   = [-0.120993041720418,-0.251867101121381,-0.335014562533955,-0.401288521630443,-0.458072262939894,-0.603956091621655,-0.785678791939806,-0.932641071152821,-1.05940906693221];
%--------------------


for iteracion=4:9
f(iteracion)
if( ( (Difracc_O1(iteracion)<0) ||(Difracc_O2(iteracion)<0) ) && (abs(Difracc_O1(iteracion) -Difracc_O2(iteracion))<0.5) )
    
        %Para Ldif(uve'1)
        Distancia_entre_obstaculos = Distancia_E1_O2-Distancia_E1_O1;

        flecha_A_prima         = Distancia_entre_obstaculos*Distancia_E1_O1/(2*Re);
        altura_rayo_A_prima    = ((h1-e_O2)*Distancia_entre_obstaculos/Distancia_E1_O2)+e_O2;
        Despejamiento_A_prima  = e_O1 + flecha_A_prima - altura_rayo_A_prima;

        R1_A_prima      = sqrt(lambda(iteracion)*Distancia_entre_obstaculos*Distancia_E2_O1/Distancia_E1_O2);
        Difracc_A_prima = sqrt(2)*(Despejamiento_A_prima./R1_A_prima);

        %Para Ldif(uve'2)
        flecha_2p             = Distancia_entre_obstaculos*Distancia_E2_O2/(2*Re);
        altura_rayo_B_prima   = ((h2-e_O1)*Distancia_entre_obstaculos/Distancia_E2_O1)+e_O1;
        Despejamiento_B_prima = e_O2 + flecha_2p - altura_rayo_B_prima;

        R1_B_prima      = sqrt(lambda(iteracion)*Distancia_entre_obstaculos*Distancia_E2_O2/Distancia_E2_O1);
        Difracc_B_prima = sqrt(2)*(Despejamiento_B_prima./R1_B_prima);
        
        Ldif_A_prima    = 6.9 + 20*log10(sqrt((Difracc_A_prima-0.1).^2+1)+Difracc_A_prima-0.1);
        Ldif_B_prima    = 6.9 + 20*log10(sqrt((Difracc_B_prima-0.1).^2+1)+Difracc_B_prima-0.1);
        
        Ldif_dB(:,iteracion) = Ldif_A_prima+Ldif_B_prima+10*log10((Distancia_E1_O2*Distancia_E2_O1)/(Distancia_entre_obstaculos*(Distancia_E1_O2+Distancia_E2_O1)))
end

if( ( (Difracc_O1(iteracion)>0) && (Difracc_O2(iteracion)>0) ) && (abs(Difracc_O1 -Difracc_O2)>0.5) )

        Dentre_obs             = Distancia_E1_O2-Distancia_E1_O1;

        Flecha_02_prima        = (Dentre_obs*Distancia_E2_O2)/(2*Re);

        e_O2_prima             = ((h2-e_O1)*Dentre_obs/Distancia_E2_O1)+e_O1;

        Despejamiento_O2_prima = Flecha_02_prima+e_O2-e_O2_prima;

        Rfresnell_O2_prima     = sqrt(lambda*((Dentre_obs*Distancia_E2_O2)/(Dentre_obs+Distancia_E2_O2)));

        Difracc_O2_prima       = sqrt(2)*(Despejamiento_O2_prima/Rfresnell_O2_prima);

        Alpha         = atan(((Distancia*Dentre_obs)/(Distancia_E1_O1*Distancia_E2_O2))^(1/2));

        Ldif_V1(:,iteracion)       = 6.9 + 20*log10(sqrt( (Difracc_O1      -0.1)^2 +1) + Difracc_O1      -0.1);
        Ldif_V2_prima(:,iteracion) = 6.9 + 20*log10(sqrt(((Difracc_O2_prima-0.1)^2)+1) + Difracc_O2_prima-0.1);

        Tc            =(12 - 20*log10(2/(1 - (Alpha/pi))))*((Difracc_O2/Difracc_O1)^(2*Difracc_O1));

        Lad(:,iteracion)=Ldif_V1(:,iteracion)+Ldif_V2_prima(:,iteracion)-Tc
end

if(Difracc_O2(iteracion)<-0.78 && Difracc_O1(iteracion)>-0.78)
    Ldif_dB(:,iteracion)       = 6.9 + 20*log10(sqrt( (Difracc_O1(iteracion)      -0.1).^2 +1) + Difracc_O1(iteracion)      -0.1)
end

if(Difracc_O1(iteracion)<-0.78 && Difracc_O2(iteracion)>-0.78)
   Ldif_dB(:,iteracion)       = 6.9 + 20*log10(sqrt( (Difracc_O2(iteracion)      -0.1).^2 +1) + Difracc_O2(iteracion)      -0.1)
end

if(Difracc_O2(iteracion)<-0.78 && Difracc_O1(iteracion)<-0.78)
   "Los obstáculos no afectan" 
end


end