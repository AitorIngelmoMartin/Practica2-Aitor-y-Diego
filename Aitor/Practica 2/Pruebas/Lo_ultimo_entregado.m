clear;clc;close all;
K      = 4/3;
c      = 3e8;
f      = [300,1300, 2300, 3300, 4300,7475,12650, 17825, 23000].*1e6;
lambda = c./f;
d      = 20.09e3;
R0     = 6370e3;
Re     = R0*K;
h1     = 807;
h2=805+8;
e  = [796 800 803 799 735 760 788 805];
a  = [10 0 0 0 0 0 0 8];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;

flecha         = d1.*d2/(2*Re);
altura_rayo    = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);
despejamiento  = e + flecha - altura_rayo;
    
numero_iteraciones    = size(lambda);
columnas              = size(f);

for iteracion=1:numero_iteraciones(2)
    R1(iteracion,:) = sqrt(lambda(1,iteracion)*d1.*d2/d); %Altura del primer rayo de Fresnel    
end

despejamiento(:,1)    =[];
despejamiento(:,end)  =[];
d1(:,1)        =[];
d1(:,end)      =[];
R1(:,1)        =[];
R1(:,end)      =[];
flecha(:,1)    =[];
flecha(:,end)  =[];
e(:,1) = [];
e(:,end) = [];

uve                      = sqrt(2)*despejamiento./R1;
Ldif_iterado             = 6.9 + 20*log10(sqrt((uve-0.1).^2 +1) + uve-0.1);

C =10+0.04*(d1(2)/1000+d2(2)/1000);
Distancia=d;
for iteracion=1:9
if(uve(iteracion,1)>-0.78 && uve(iteracion,2)>-0.78 && uve(iteracion,3)>-0.78 )
%SUBVANO IZQ---------

Distancia_IZQ =1910;
D1_IZQ = 806;
D2_IZQ = Distancia_IZQ - D1_IZQ;
e_IZQ            = 800;

h2_IZQ = 803;
h1_IZQ = 796+10;

AlturaRayo_IZQ   = ((h2_IZQ-h1_IZQ)/Distancia_IZQ)*D1_IZQ + h1_IZQ;


Flecha_IZQ            = (D1_IZQ*D2_IZQ)/(2*K*R0);
Despejamiento_IZQ     = Flecha_IZQ + e_IZQ-AlturaRayo_IZQ;

Rfresnell_IZQ     = sqrt((lambda*D1_IZQ*D2_IZQ)/(D1_IZQ+D2_IZQ));

Difracc_IZQ       = sqrt(2)*(Despejamiento_IZQ./Rfresnell_IZQ)

Lad_izquierda =transpose(6.9 + 20*log10(sqrt((Difracc_IZQ-0.1).^2 +1) + Difracc_IZQ-0.1));
%SUBVANO DRCH---------

Distancia_DRCH =18180;
D1_DRCH = 1811;
D2_DRCH= Distancia_DRCH - D1_DRCH;
e_DRCH            = 799;

h2_DRCH = 805+8;
h1_DRCH = 803;

AlturaRayo_DRCH   = ((h2_DRCH-h1_DRCH)/Distancia_DRCH)*D1_DRCH + h1_DRCH;


Flecha_DRCH  = (D1_DRCH*D2_DRCH)/(2*K*R0);
Despejamiento_DRCH      = Flecha_DRCH + e_DRCH-AlturaRayo_DRCH;


Rfresnell_DRCH     = sqrt((lambda*D1_DRCH*D2_DRCH)/(D1_DRCH+D2_DRCH));

Difracc_DRCH       = sqrt(2)*(Despejamiento_DRCH./Rfresnell_DRCH)

Ldif_DRCH          =  transpose(6.9 + 20*log10(sqrt((Difracc_DRCH-0.1).^2 +1) + Difracc_DRCH-0.1))


T =1-exp(-(Ldif_iterado(:,2))/6);   
T =   [T(1:3)]; 

Ldiff_3_obtaculos(iteracion,:) = Ldif_iterado(iteracion,2) + T(iteracion,:).*((Ldif_DRCH(iteracion,:) + Lad_izquierda(iteracion,:) + C))

else
    
    
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


for iteracion=1:9
if( ( (Difracc_O1(iteracion)<0) ||(Difracc_O2(iteracion)<0) ) && (abs(Difracc_O1(iteracion) -Difracc_O2(iteracion))<0.5) )
    
        %Para Ldif(uve'1)
        Distancia_entre_obstaculos = Distancia_E1_O2-Distancia_E1_O1;

        flecha_A_prima         = Distancia_entre_obstaculos*Distancia_E1_O1/(2*Re);
        altura_rayo_A_prima    = ((h1-e_O2)*Distancia_entre_obstaculos/Distancia_E1_O2)+e_O2;
        Despejamiento_A_prima  = e_O1 + flecha_A_prima - altura_rayo_A_prima;

        R1_A_prima      = sqrt(lambda(iteracion)*Distancia_entre_obstaculos*Distancia_E2_O1/Distancia_E1_O2);
        Difracc_A_prima(iteracion,:) = sqrt(2)*(Despejamiento_A_prima./R1_A_prima);

        %Para Ldif(uve'2)
        flecha_2p             = Distancia_entre_obstaculos*Distancia_E2_O2/(2*Re);
        altura_rayo_B_prima   = ((h2-e_O1)*Distancia_entre_obstaculos/Distancia_E2_O1)+e_O1;
        Despejamiento_B_prima = e_O2 + flecha_2p - altura_rayo_B_prima;

        R1_B_prima      = sqrt(lambda(iteracion)*Distancia_entre_obstaculos*Distancia_E2_O2/Distancia_E2_O1);
        Difracc_B_prima(iteracion,:) = sqrt(2)*(Despejamiento_B_prima./R1_B_prima);
        
        Ldif_A_prima    = 6.9 + 20*log10(sqrt((Difracc_A_prima-0.1).^2+1)+Difracc_A_prima-0.1);
        Ldif_B_prima    = 6.9 + 20*log10(sqrt((Difracc_B_prima-0.1).^2+1)+Difracc_B_prima-0.1);
        
        Ldif_dB(iteracion,:) = Ldif_A_prima(iteracion,:)+Ldif_B_prima(iteracion,:)+10*log10((Distancia_E1_O2*Distancia_E2_O1)/(Distancia_entre_obstaculos*(Distancia_E1_O2+Distancia_E2_O1)))
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

        Lad(iteracion,:)=Ldif_V1(:,iteracion)+Ldif_V2_prima(:,iteracion)-Tc
end

if(Difracc_O2(iteracion)<-0.78 && Difracc_O1(iteracion)>-0.78)
    Ldif_dB(iteracion,:)       = 6.9 + 20*log10(sqrt( (Difracc_O1(iteracion)      -0.1).^2 +1) + Difracc_O1(iteracion)      -0.1)
end

if(Difracc_O1(iteracion)<-0.78 && Difracc_O2(iteracion)>-0.78)
   Ldif_dB(iteracion,:)       = 6.9 + 20*log10(sqrt( (Difracc_O2(iteracion)      -0.1).^2 +1) + Difracc_O2(iteracion)      -0.1)
end

if(Difracc_O2(iteracion)<-0.78 && Difracc_O1(iteracion)<-0.78)
   "Los obstáculos no afectan" 
end


end
    
end
end
Un_obs = [-0.358134521542571;-0.425124067513148;-0.482908490334681]

Ldif_un_obs = 6.9 + 20*log10(sqrt( (Un_obs      -0.1).^2 +1) + Un_obs      -0.1)

Ltotales = [Ldiff_3_obtaculos;0;0;0;0;0;0] + Ldif_dB;
