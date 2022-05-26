% Se analiza un radioenlace entre dos puntos separados 21km a 18GHz. La capacidad del enlace es de 64Mbps con una modulación 64QAM y un filtro de coseno alzado con un factor de roll-off de 0,3. El terreno presente entre las estaciones es un terreno seco (sigma=0,001 S/m y epsilon_R=15) y un factor de rugosidad del terreno gamma=0,2. Se utilizan antenas con polarización horizontal poco directivas de 9dB de ganancia. Las alturas de las antenas con respecto al nivel del mar son 210m, en un extremo, y 54m, en el otro extremo. Los terminales de ambas estaciones presentan 2dB de pérdidas. Los terminales de la estación receptora conectan con un LNA con una figura de ruido de 6dB y ganancia 20dB, un mezclador con pérdidas 12dB y un amplificador en frecuencia intermedia con figura de ruido de 14dB. Este último amplificador cuenta con un control automático de potencia que permite amplificar hasta 20dB. El requisito de Eb/N0 es de 16dB para un filtro ideal. El MTTR es de 4 horas y el MTBF de 468.000 horas. Datos: R0,01=33mm/h
% Determinar la PIRE y la indisponibilidad del enlace.


clc;clear;

f = 18e9; %en hercios
c = 3e8;
lambda = c/f;
d = 21e3; %en metros

Lt_dB = 2;
G_dB = 9;

figura_ruido_LNA_dB = 6;
figura_ruido_LNA = 10^(figura_ruido_LNA_dB/10);

G_LNA_dB = 20;
G_LNA = 10^(G_LNA_dB/10);

L_mezclador_dB = 12; %atenuacion
L_mezclador = 10^(L_mezclador_dB/10);

figura_ruido_AFI_dB = 14; % amplificador en frecuencia intermedia 
figura_ruido_AFI = 10^(figura_ruido_AFI_dB/10);

G_AFI_dB = 20; % amplificador en frecuencia intermedia
G_AFI = 10^(G_AFI_dB);

MTTR = 4; %en horas
MTBF = 468e3; %en horas
Eb_No_dB = 16;
R_001 = 33; %mm/h
alpha_PH = 1.0818; %Para PH
k_PH = 0.07078;


T0 = 290; %temperatura normal en Kelvin
K = 1.38*10e-23; %constante de boltzman en J/K
Rb = 64e6; %capacidad del enlace en bps
roll_off = 0.3; %Factor filtro coseno alzado. Degradación del umbral: 1dB
"Modulación 64-QAM"
M=64;
"Atenuador variable frente a desvanecimientos"

%terreno seco

Conductividad = 0.001;
Epsilon_relativa = 15;
rugosidad = 0.2; %<=0.3 por tanto terreno liso

"Polarización Horizontal"

h1=210;
h2=54;  %alturas respecto nivel del mar
R0 = 6370e3;
%solucion

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
Phi=atan(hp1/d1)*1000;
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


if(Phi>=Phi_lim)
 %Código ejecutado si hay reflexión -> MTC
    "Hay pérdidas por reflexión"

        dif_caminos =sqrt( d^2 + abs(hp1+hp2)^2 ) - sqrt( d^2 + (hp1-hp2)^2 );
        
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

%---------------------------------------------------------------------------

f = f/(1e9);

%Paso 2

R_001_alpha = R_001^alpha_PH;
gamma_R = k*R_001_alpha; % Atenuación específica (dB/Km)



%Paso 3 en radioenlace terrenal

d_eff = (d/1000)*1/(0.477*(d/1000)^0.633*R_001^(0.073*alpha_PH)*(f)^0.123 -(10.579*(1-exp(-0.024*(d/1000))))); % Correccion del rayo

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


%-----------------------------------------------

B = (1+roll_off)*Rb; %ancho de banda
% Eb_No_dB = CNR_dB -10*log10(Rb/B);
CNR_dB = Eb_No_dB + 10*log10(Rb/B);

T1 = T0*(figura_ruido_LNA_dB-1);
T2 = T0*(L_mezclador_dB-1);
T3 = T0*(figura_ruido_AFI_dB-1);
T_tot = T0*G_LNA*G_AFI/L_mezclador + T1*G_LNA*G_AFI/L_mezclador + T2*G_AFI/L_mezclador * T3*G_AFI;

% CNR_dB = Prec_total - 10*log10(K*T_tot*B);
Prec_total_dBm = CNR_dB + 10*log10(K*T_tot*B) + 30;

%perdidas
gamma_gases = 0.06;
Lgases_dB = gamma_gases*d/1000;

Lbf_dB = 20*log10(4*pi*d/lambda);
Lb_dB =Lbf_dB + Lgases_dB + Lad_dB;

Prec_antena_dBm = Prec_total_dBm - G_AFI_dB + L_mezclador_dB - G_LNA_dB;

%Prec_antena_dB = PIRE_dB - Lb_dB + G_dB - Lt_dB
PIRE_dBm = Prec_antena_dBm + Lb_dB - G_dB + Lt_dB;

%Al constar de un CAG tenemos que:
% Prec_total_dBm = PIRE_dBm - Lb_dB - Fll_dB + G_dB - Lt_dB;
Fq_dB = PIRE_dBm - Prec_total_dBm - Lb_dB + G_dB - Lt_dB;
MD_dB = Fq_dB;

%calcular la q teniendo Fq
ecuacion = [C3 C2 log10(Fq_dB/(F_01*C1))];
x = roots(ecuacion);
q1 = abs(10^x(1));
q2 = abs(10^x(2));

if(q1>q2)
    q = q1;
else
    q = q2;
end

UR_lluvia = q;
UR_total = q + (3*MTTR/MTBF) *100; %Indisponibilidad total, UR_lluvia + UR_equipos


