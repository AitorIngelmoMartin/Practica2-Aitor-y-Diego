%  Determinar la potencia recibida a la salida de los terminales del receptor teniendo en cuenta 
% tanto las pérdidas por espacio libre como las pérdidas en exceso debidas a la difracción 
% (k=4/3) para una frecuencia de 2,3 GHz y las alturas de las antenas calculadas 
% anteriormente. Justificar si el enlace diseñado supera el umbral fijado para ofrecer el 
% servicio de radiocomunicación.


clear;clc;

f = 2.3e9;
c=3e8;
lambda= c/f;


% Alturas, distancia y radio en metros

d = 20.09e3; %en Km
R0 =6370e3;

e = [796 803 799 805];
a = [17 0 0 12];

d1 = [0 1.910e3 3.721e3 d];
d2 = d - d1;


Ptx_dBm = 23;
G_dB = 19;
Lt_dB = 1;

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

%--------------------------------------------------------------------------

    %Despejamiento suficiente en obstaculo 1

    if(uve(2)<=-0.78)
        if(uve(3)>-0.78)
             Lad=6.9+20*log10(sqrt(((uve(3)-0.1)^2)+1)+uve(3)-0.1);
        end
    end

    %Despejamiento suficiente en obstaculo 2

    if(uve(3)<=-0.78)
        if(uve(2)>-0.78)
            Lad=6.9+20*log10(sqrt(((uve(2)-0.1)^2)+1)+uve(2)-0.1);
         end
    end


    if(uve(2)<=-0.78 && uve(3)<=-0.78)
        Lad_dB = 0;
    end
%---------------------------------------------------------------------------
if(uve(2)>-0.78 && uve(3)>-0.78)
    if( ( (uve(2)<0) ||(uve(3)<0) ) && (abs(uve(2) - uve(3))<0.5) )
        "Método uno, obstáculos parecidos"
        %Para Ldif(uve'1)
        do1_o2 = d1(3)-d1(2); %distancia entre obstaculos

        flecha_1p = do1_o2*d1(2)/(2*Re);
        altura_rayo_1p = ((a(1)+e(1)-e(3))*do1_o2/d1(3))+e(3);
        despejamiento_1p = e(2) + flecha_1p - altura_rayo_1p;

        R1_1p = sqrt(lambda*do1_o2*d1(2)/d1(3)); %Altura del primer rayo de Fresnel
        uve_1p = sqrt(2)*(despejamiento_1p/R1_1p);

        Ldif_p1_dB = 6.9 + 20*log10(sqrt((uve_1p-0.1)^2+1)+uve_1p-0.1);

        %Para Ldif(uve'2)
        do1_o2 = d1(3)-d1(2); %distancia entre obstaculos

        flecha_2p = do1_o2*d2(3)/(2*Re);
        altura_rayo_2p = ((a(end)+e(end)-e(2))*do1_o2/d2(2))+e(2);
        despejamiento_2p = e(3) + flecha_2p - altura_rayo_2p;

        R1_2p = sqrt(lambda*do1_o2*d2(3)/d2(2)); %Altura del primer rayo de Fresnel
        uve_2p = sqrt(2)*(despejamiento_2p/R1_2p);

        Ldif_p2_dB = 6.9 + 20*log10(sqrt((uve_2p-0.1)^2+1)+uve_2p-0.1);

        %------------------------------------------------------------------

        Lad_dB = Ldif_p1_dB + Ldif_p2_dB + 10*log10(d1(3)*d2(2)/(do1_o2*(d1(3)+d2(3))));
    end

    if( ( (uve(2)>0) && (uve(3)>0) ) && (abs(uve(2) -uve(3))>0.5) )
        "Método dos, obsáculo dominante"

        % Parámetros modificados

        %Obstaculo 1 predominante
        if(uve(2)>uve(3))
            "Obstáculo 1 dominante"

             do1_o2 = d1(3)-d1(2); %distancia entre obstaculos

             flecha_2p = do1_o2*d2(3)/(2*Re);
             altura_rayo_2p = ((a(end)+e(end)-e(2))*do1_o2/d2(2))+e(2);
             despejamiento_2p = e(3) + flecha_2p - altura_rayo_2p;

             R1_2p = sqrt(lambda*do1_o2*d2(3)/d2(2)); %Altura del primer rayo de Fresnel
             uve_2p = sqrt(2)*(despejamiento_2p/R1_2p);
  
%-------------------------------------------------------------------------------------

            tan_alfa = (d*do1_o2/(d1(2)*d2(3)))^(1/2);
            alfa = atan(tan_alfa);
            p = uve(2);
            q = uve(3);
            Tc = (12-20*log10(2/(1-(alfa/pi))))*(q/p)^(2*p);

        if uve_2p<=-0.78

             Ldif_p2_dB = 0;

         else

         Ldif_p2_dB = 6.9 + 20*log10(sqrt((uve_2p-0.1)^2+1)+uve_2p-0.1);

         end

         Ldif1_dB = 6.9 + 20*log10(sqrt((uve(2)-0.1)^2+1)+uve(2)-0.1);

        end
         Lad_dB = Ldif1_dB + Ldif_p2_dB - Tc;
    end
end
    %----------------------------------------------------------------------

    Lbf_dB = 20*log10(4*pi*d/lambda);
    Lb_dB =Lbf_dB + Lad_dB;
    Prec_dBm = Ptx_dBm + G_dB - Lt_dB - Lb_dB +G_dB - Lt_dB;