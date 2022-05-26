clear;clc;

f = 32e9;
c=3e8;
lambda= c/f;


% Alturas, distancia y radio en metros

Ptx_dBm = 55;
Gtx_dB = 15 - 5;
Grx_dB = 50;
Lt_tx_dB = 2;
Lt_rx_dB = 1;
Lt = 10^(Lt_rx_dB/10);

Epsilon_relativa = 70;
Conductividad=5;
Polarizacion = "vertical";

h1 = 277;
h2 = 91;
d = 35e3;
R0 =6370e3;

Epsilon0=Epsilon_relativa-1i*60*Conductividad*lambda;



% -------------------------------------------------------------------------
k = 4/3;
Re = R0*k;
dmax = sqrt(2*Re)*(sqrt(h1)+sqrt(h2)); 

if(d<0.1*dmax) 
    %Código ejecutado si tierra plana
    "Tierra plana"
else
    %Código ejecutado si tierra curva
    "Tierra curva"
end
% -------------------------------------------------------------------------


if(d>0.1*dmax)
    p=(2/sqrt(3))*(k*R0*(h1+h2)+(d^2)/4)^(1/2);

    if(h1>h2)
        tetha=acos((2*k*R0*(h1-h2)*d)/p^3); 
        d1=(d/2)+p*cos((pi+tetha)/3);
        d2=d-d1;
    end

    if(h2>h1)
        tetha=acos((2*k*R0*(h2-h1)*d)/p^3);
        d2=(d/2)+p*cos((pi+tetha)/3);
        d1=d-d2;
    end

hp1=h1-(d1^2)/(2*k*R0);
hp2=h2-(d2^2)/(2*k*R0);
Phi=atan(hp1/d1);
end
Phi_lim = ((5400/(f/1e6))^(1/3));

%Polarización Horizontal

numerador   = sin(Phi) - sqrt(Epsilon0-(cos(Phi)^2));
denominador = sin(Phi) + sqrt(Epsilon0-(cos(Phi)^2));
 Rh =numerador/denominador;

%Polarizaciín Vertical

% numerador   = Epsilon0*sin(Phi) - sqrt(Epsilon0-(cos(Phi)^2));
% denominador = Epsilon0*sin(Phi) + sqrt(Epsilon0-(cos(Phi)^2));
% Rv =numerador/denominador;


if(Phi>=Phi_lim*1e-3)
 %Código ejecutado si hay reflexión -> MTC
    "Hay pérdidas por reflexión"
    dif_caminos =sqrt( d^2 + abs(hp1+hp2)^2 ) - sqrt( d^2 + (hp1-hp2)^2 );
        rugosidad = 0;
        Divergencia = ( 1 + (5*(d1/1000)^2*d2/1000)/(16*k*(d/1000)*hp1))^(-0.5);
        R_efectivo = Rh*Divergencia; %terreno liso: gamma <0,3 (exp(-gamma^2/2))=1;
        rho = rugosidad*lambda/(4*pi*sin(Phi));
        % gamma = 4*pi*rho*sin(Phi)/lambda;
        %  R_efectivo = Rv*Divergencia*exp(-gamma^2/2);
        
        exponente = (-1i*2*pi*dif_caminos/lambda);  
        %Lad=-20*log10(abs(1+R_efectivo*exp(-1i*((2*pi)/lambda)*dif_caminos)));
        Lad_dB=-20*log10(abs(1+R_efectivo*exp(exponente)));   

else
 %Código ejecutado si hay difracción -> MDTE
    "Hay pérdidas por difracción"

    %beta = 1+1.6*thao^2+0.75*thao^4/(1+4.5*thao^2+1.35*thao^4);
    %thao_h = (2*pi*Re/lamda)^(-1/3)*((Epsilon_relativa-1)^2+(60*lambda*sigma)^2)^(-1/4);
    %thao_v = thao_h*(Epsilon_relativa^2+(60*lambda*sigma)^2)^(1/2);

        beta = 1; %siempre en PH en PV solo enn frecuencias altas

        X = beta*d*(pi/(lambda*Re^2))^(1/3);
        Y1 = 2*beta*h1*(pi^2/((lambda^2)*Re))^(1/3);
        Y2 = 2*beta*h2*(pi^2/((lambda^2)*Re))^(1/3);
        
        if(X>=1.6)
            FX = 11 + log10(X) - 17.6*X;

        else
            FX = -20*log10(X) - 5.6488*X^1.425;

        end
%------------------------------------------------------

        %Para Y1
        if(Y1>2)
           GY1 = 17.6*sqrt(beta*Y1-1.1) - 5*log10(beta*Y1-1.1) - 8;
          
        else
            GY1 = 20*log10(beta*Y1+0.1*(beta*Y1)^3);
        end   


        if (GY1 < (2+20*log10(k)))
            GY1 = 2+20*log10(k);
        end
%-----------------------------------------------------
        
        %Para Y2
        if(Y2>2)
           GY2 = 17.6*sqrt(beta*Y2-1.1) - 5*log10(beta*Y2-1.1) - 8;
          
        else
            GY2 = 20*log10(beta*Y2+0.1*(beta*Y2)^3);
        end   


        if (GY2 < (2+20*log10(k)))
            GY2 = 2+20*log10(k);
        end


        Lad_dB = - FX - GY1 - GY2;
end


%-----------------------------------------
f = 32;

K  = 1.381e-23;

k_PV = 0.2646;
alpha_PV = 0.8981;

MTTR_tx = 8;
MTBF_tx =3.2e5;

MTTR_rx= 4;
MTBF_rx = 1e5;

CNR_min_dB = 11;

G_LNA_dB = 25;
G_LNA = 10^(G_LNA_dB);

figura_ruido_dB = 5;
figura_ruido = 10^(figura_ruido_dB/10);

L_mez_dB = 12;
L_mez = 10^(L_mez_dB/10);

"Atenuador variable"

M = 16;

q = 0.01;

roll_off = 0.3;

Rb = 64e6;

Ux = 1.5;

R_001 = 18; 

%Paso 2

R_001_alpha = R_001^alpha_PV;
gamma_R = k_PV*R_001_alpha; % Atenuación específica (dB/Km)


%Paso 3 en radioenlace terrenal

d_eff = (d/1000)*1/(0.477*(d/1000)^0.633*R_001^(0.073*alpha_PV)*(f)^0.123 -(10.579*(1-exp(-0.024*(d/1000))))); % Correccion del rayo

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

% Fq = F_01*C1*q^(-C2-C3*log10(q)); %minimo de atenuacion de la luvia en el q% del año

Bn = Rb/log2(M);

T0 = 290;
T1 = T0*(Lt-1);
T2 = T0*(figura_ruido-1);
T3 = T0*(L_mez-1);
T_total = T0/Lt + T1/Lt + T2 + T3/G_LNA;
Umbral_dBm = CNR_min_dB+ 10*log10(K*T_total*Bn) + Ux + 30;








 gamma_gases = 0.09;
 Lgases_dB = gamma_gases*d/1000;

 Lbf_dB = 20*log10(4*pi*d/lambda);
 Lb_dB =Lbf_dB + Lgases_dB + Lad_dB;
 
%PIRE_dBm = Ptx_dBm + G_dBi - Lt_dB; 
% Prec_atenuador = Umbral_dBm + MD_dB = Ptx_dBm + G_dBi - Lt_dB - Lb_dB + G_dBi - Lt_dB;

Prec_atenuador_dBm = Ptx_dBm + Gtx_dB - Lt_tx_dB - Lb_dB + Grx_dB - Lt_rx_dB;

% MD_dB = Ptx_dBm - Umbral_dBm + Gtx_dB - Lt_tx_dB - Lb_dB + Grx_dB - Lt_rx_dB;
MD_dB = Prec_atenuador_dBm - Umbral_dBm;


% Prec_atenuador =  Ptx_dBm + G_dBi - Lt_dB - Lb_dB - F_ll + G_dBi - Lt_dB;



% -------------------------------------------------------------------------

% PIRE_dBW = Ptx_dBW + G_dB;
% Lbf_dB = 20*log10(4*pi*d/lambda);
% Lb_dB =Lbf_dB + Lad_dB;
% Prec_dBW = PIRE_dBW - Lb_dB + G_dB;
% Prec_dBm = Prec_dBW + 30;