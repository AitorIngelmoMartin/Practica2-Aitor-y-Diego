% Se ha constituido un enlace radio entre dos puntos separados 14km a 11,2GHz. Las dos estaciones utilizan antenas del modelo UXA 4 - 107B capaces de trabajar de forma simultánea con polarización vertical y horizontal. La potencia de transmisión con polarización horizontal es 23dBm y las pérdidas en los terminales son 1dB. El mecanismo de protección utilizado en ambas estaciones se basa en un atenuador variable.
% Determinar los valores de las potencias recibidas copolares y contrapolares superados en el 0,005% (condiciones de propagación de máximo desvanecimiento) de un año en el receptor asociado a la polarización horizontal y en el receptor asociado a la polarización vertical, si la única señal transmitida tiene polarización horizontal. Se asume que únicamente se producen desvanecimientos por lluvia y no hay atenuación por difracción aunque el terreno no sea liso.
% Datos: R0,01=37mm/h; kh=0,0189; αh=1,2069; kv=0,0187; αv=1,1528.

clear;clc;

f = 11.2e9;
c=3e8;
lambda= c/f;
f = f/(1e9);

%datos

d = 14e3; %En metros
R0 =6370e3;

Ptx_PH_dBm = 23; %ptx con PH
G_dB = 40.4;
Lt_dB = 1;
q = 0.005; %porciento

R_001 = 37; %mm/h

%Solo se transmite en PH
k_PH = 0.0189;
alpha_PH = 1.2069;

% k_PV = 0.0187;
% alpha_PV = 1.1528;

%Paso 2

R_001_alpha_PH = R_001^alpha_PH;
gamma_R_PH = k_PH*R_001_alpha_PH; % Atenuación específica (dB/Km)

% R_001_alpha_PV = R_001^alpha_PV;
% gamma_R_PV = k_PV*R_001_alpha_PV; % Atenuación específica (dB/Km)


%Paso 3 en radioenlace terrenal

d_eff_PH = (d/1000)*1/(0.477*(d/1000)^0.633*R_001^(0.073*alpha_PH)*(f)^0.123 -(10.579*(1-exp(-0.024*(d/1000))))); % Correccion del rayo
% d_eff_PV = (d/1000)*1/(0.477*(d/1000)^0.633*R_001^(0.073*alpha_PV)*(f)^0.123 -(10.579*(1-exp(-0.024*(d/1000))))); % Correccion del rayo

%Paso 4

F_01_PH = gamma_R_PH *d_eff_PH; % En 1h/año la lluvia va a atenuar al menos F0.01
% F_01_PV = gamma_R_PV *d_eff_PV; % En 1h/año la lluvia va a atenuar al menos F0.01

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

Fq_PH = F_01_PH*C1*q^(-C2-C3*log10(q)); %minimo de atenuacion de la luvia en el q% del año
% Fq_PV = F_01_PV*C1*q^(-C2-C3*log10(q)); %minimo de atenuacion de la luvia en el q% del año

MD_dB_PH = Fq_PH;
% MD_dB_PV= Fq_PV;

%--------------------------------------------------------------------------------
gamma_gases = 0.016;
Lgases = gamma_gases*d/1000;

U = 15 + 30*log10(f);

if (f>8 && f<=20)
    V = 12.8*f^0.19;
elseif (f>20 && f<=35)
    V = 22.6;
end

XPD_ll = U - V*log10(MD_dB_PH);

Lbf_dB = 20*log10(4*pi*d/lambda);
Lad_dB = Lgases;
Lb_dB = Lbf_dB + Lad_dB;
XPD_antena = 0 -(-40);

%En polarización Horizontal
Prec_CP_PH_dBm = Ptx_PH_dBm + G_dB - Lt_dB - Lb_dB + G_dB - Lt_dB - MD_dB_PH;
Prec_XP_PH_dBm = Prec_CP_PH_dBm -XPD_ll - XPD_antena;

%En polarización Vertical
Prec_CP_PV_dBm = Ptx_PH_dBm + G_dB - Lt_dB - Lb_dB + G_dB - Lt_dB - MD_dB_PH - XPD_ll ;
Prec_XP_PV_dBm = Prec_CP_PV_dBm + XPD_ll - XPD_antena;

% En polarización Horizontal 
% Prec_CP_PH_dBm = Ptx_PH_dBm + G_dB - Lt_dB - Lb_dB + G_dB - Lt_dB - MD_dB_PH;
% Prec_XP_PH_dBm = Prec_CP_PH_dBm - XPD_antena;
% 
% %En polarización Vertical
% Prec_CP_PV_dBm = Ptx_PH_dBm + G_dB - Lt_dB - Lb_dB + G_dB - Lt_dB - MD_dB_PH - XPD_antena - XPD_ll;
% Prec_XP_PV_dBm = Prec_CP_PV_dBm - XPD_ll + XPD_antena;