
clear;clc;

f = 2.3e9;
c=3e8;
lambda= c/f;


% Alturas, distancia y radio en metros

d = 20.09e3; %en Km
R0 =6370e3;

% e = [796 815 803 799 805];
% a = [10 0 0 0 8];
% 
% d1 = [0 0.806e3 1.910e3 3.721e3 d];
% d2 = d - d1;
e = [796 800 815 799 735 760 788 805];
a = [10 0 0 0 0 0 0 8];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;

% -------------------------------------------------------------------------
k = 4/3;
Re = R0*k;
dmax = sqrt(2*Re)*(sqrt(e(1)+a(1))+sqrt(e(end)+a(end))); 

% -------------------------------------------------------------------------

%Como hay obstáculos, solo existen pérdidas por difracción
    "Hay pérdidas por difracción"


   %parámetros

    flecha = d1.*d2/(2*Re);
    altura_rayo = ((e(end)+a(end)-e(1)-a(1))/d) * d1 + e(1)+a(1);
    despejamiento = e + flecha - altura_rayo;

    R1 = sqrt(lambda*d1.*d2/d); %Altura del primer rayo de Fresnel
    uve = sqrt(2)*despejamiento./R1;


    %Metodo 3: 3 obstáculos

    %Obstaculo a la izquierda del dominante

    do1_o2_SI = d1(3)-d1(2); %distancia entre obstaculo dominante y obstaculo izquierdo

    flecha_SI = do1_o2_SI*d1(2)/(2*Re);
    altura_rayo_SI = ((e(1)+a(1)-e(3))*do1_o2_SI/d1(3))+e(3);
    despejamiento_SI = e(2) + flecha_SI - altura_rayo_SI;

    R1_SI = sqrt(lambda*do1_o2_SI*d1(2)/d1(3)); %Altura del primer rayo de Fresnel
    uve_SI = sqrt(2)*(despejamiento_SI/R1_SI);

    Ldif_vpSI = 6.9 + 20*log10(sqrt((uve_SI-0.1)^2+1)+uve_SI-0.1)

    if (Ldif_vpSI < 0)
        Ldif_vpSI = 0;
    end

%-----------------------------------------------------------------------------

    %Obstaculo a la derecha del dominante

    do2_o3_SD = d1(4)-d1(3); %distancia entre obstaculo dominante y obstaculo derecho

    flecha_SD = do2_o3_SD*d2(4)/(2*Re);
    altura_rayo_SD = ((a(end)+e(end)-e(3))*do2_o3_SD/d2(3))+e(3);
    despejamiento_SD = e(4) + flecha_SD - altura_rayo_SD;


    R1_SD = sqrt(lambda*do2_o3_SD*d2(4)/d2(3)); %Altura del primer rayo de Fresnel
    uve_SD = sqrt(2)*(despejamiento_SD/R1_SD);

    Ldif_vpSD = 6.9 + 20*log10(sqrt((uve_SD-0.1)^2+1)+uve_SD-0.1)

    if (Ldif_vpSD < 0)
        Ldif_vpSD = 0;
    end

  %---------------------------------------------------------------------------

    Ldif_vd = 6.9 + 20*log10(sqrt((uve(3)-0.1)^2+1)+uve(3)-0.1); %Pérdidas del obstaculo dominante
    
    T = 1-exp(-Ldif_vd/6);
    C = 10 + 0.04*((d1(3)+d2(3))/1000);

    Lad_dB = Ldif_vd + T*(Ldif_vpSI + Ldif_vpSD + C);