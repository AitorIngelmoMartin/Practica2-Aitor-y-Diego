

clear;clc;

f = 25e9;
c=3e8;
lambda= c/f;


% Alturas, distancia y radio en metros

d = 17e3; %En metros
R0 =6370e3;

e = [252 396 642 855];
a = [40 0 0 36];
d1 = [0 3e3 10e3 d];
d2 = d - d1;

G_dB = 15;
Lt_dB = 1.5;

% -------------------------------------------------------------------------
k = 4/3;
Re = R0*k;
dmax = sqrt(2*Re)*(sqrt(e(1)+a(1))+sqrt(e(end)+a(end))); 


% a) La potencia transmitida necesaria para una configuración basada en un atenuador 
% variable que garantiza una indisponibilidad por desvanecimientos por lluvia de 0,05% y
% un receptor con un nivel de sensibilidad de -107 dBm.
% b) El flujo de potencia parásito 
% con polarización horizontal en condiciones de máximo desvanecimiento permitido por el
% atenuador variable Datos R0,01=26mm/h; K=4/3 (atmósfera estándar); R=6370 km



if(d<0.1*dmax) 
    %Código ejecutado si tierra plana
    "Tierra plana"
else
    %Código ejecutado si tierra curva
    "Tierra curva"
end

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
            "Despejamiento suficiente obstáculo 1"
             Lad_dB=6.9+20*log10(sqrt(((uve(3)-0.1)^2)+1)+uve(3)-0.1);
        end
    end

    %Despejamiento suficiente en obstaculo 2

    if(uve(3)<=-0.78)
        if(uve(2)>-0.78)
            "Despejamiento suficiente obstáculo 2"
            Lad_dB=6.9+20*log10(sqrt(((uve(2)-0.1)^2)+1)+uve(2)-0.1);
         end
    end


    if(uve(2)<=-0.78 && uve(3)<=-0.78)
        Lad_dB = 0;
    end


    if( uve(3) > -0.78)
        Lad_dB = 6.9+20*log10(sqrt(((uve(3)-0.1)^2)+1)+uve(3)-0.1);
    end

%---------------------------------------------------------------------------

    if( (((uve(2)<0) || (uve(3)<0) ) && (abs(uve(2) - uve(3))<0.5)) || ( ( (uve(2)>0) && (uve(3)>0) ) && (abs(uve(2) -uve(3)) < 0.5)))
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

 
%Parte DOS

R_001 = 26; % Intensidad de lluvia (mm/h)
alpha = 0.9491;
k = 0.1533 ;
q = 0.05; %porciento
f = 25;
Prec_CN_dBm = -107;


%----------------------------------------------------------------------


%Paso 2

R_001_alpha = R_001^alpha;
gamma_R = k*R_001_alpha; % Atenuación específica (dB/Km)



%Paso 3 en radioenlace terrenal

d_eff = (d/1000)*1/(0.477*(d/1000)^0.633*R_001^(0.073*alpha)*(f)^0.123 -(10.579*(1-exp(-0.024*(d/1000))))); % Correccion del rayo

%Paso 4

F_01 = gamma_R *d_eff; % En 1h/año la lluvia va a atenuar al menos F0.01
% Si F0.01 = MD, sistema indisponible 1h/año. %indisponibilidad = 0.01,
% %disponibilidad = 0.99

%Paso 5 


if (f>=10)
    C0 = 0.12 + 0.4*log10((f/10)^0.8);
else
    C0 = 0.12;
end

C1 = (0.07^C0)*(0.12^(1-C0));
C2 = (0.855*C0)+0.546*(1-C0);
C3 = (0.139*C0)+0.043*(1-C0);

Fq = F_01*C1*q^(-C2-C3*log10(q)); %minimo de atenuacion de la luvia en el q% del año

MD_dB = F_01; %porque q es 0.01%

%calcular la q teniendo Fq
% ecuacion = [C3 C2 log10(Fq/(F_01*C1))];
% x = roots(ecuacion);
% q1 = abs(10^x(1));
% q2 = abs(10^x(2));
% 
% if(q1>q2)
%     q = q1;
% else
%     q = q2;
% end



    %----------------------------------------------------------------------

    %Calcular Prec(dBm)
    gamma_gases = 0.16;
    Lgases = gamma_gases*(d/1000);
    Lbf_dB = 20*log10(4*pi*d/lambda);
    Lb_dB =Lbf_dB + Lad_dB + Lgases;
%   Prec_dBm = Ptx_dBm + G_dB - Lt_dB - Lb_dB +G_dB - Lt_dB;

    % A) Ptx con atenuador variable

    Ptx_dBm = Prec_CN_dBm - G_dB + Lt_dB + Lb_dB - G_dB + Lt_dB;


    % B)FLUJO PARÁSITO

%   FLUJO_PH = Prx_PH/Sef;
%   Lb_CMD = Lb_dB + Fq;
%    Sef = lambda^2*g/4*pi;
    G = 10^(G_dB/10);

    U = 15 + 30*log10(f);

    if (f>8 && f<=20)
      V = 12.8*f^0.19;
    elseif (f>20 && f<=35)
       V = 22.6;
    end

    XPD_ll = U - V*log10(MD_dB);
    XPD_ant = 15;

    Lad = 10^(Lad_dB/10);
    fq = 10^(Fq/10);

    PIRE_dBm = Ptx_dBm + G_dB - Lt_dB;
    PIRE = 10e-3*10^(PIRE_dBm/10);
    E_PV_Vm = PIRE/(4*pi*d^2*Lad*fq);

    E_parasita_PH_Vm = E_PV_Vm/(10^(XPD_ll/10));
    Prx_parasita_PH_W = E_parasita_PH_Vm^2*lambda^2*G/(120*pi*4*pi*10^(XPD_ant/10));

    Sef = lambda^2*G/4*pi;
    Flujo_parasito_PH = Prx_parasita_PH_W/Sef;
    Flujo_parasito_PH_dBm = 10*log10(Flujo_parasito_PH/(10e-3));
