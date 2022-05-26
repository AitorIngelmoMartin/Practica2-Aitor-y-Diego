clc; clear;

%datos

"TDMA"

f_up = 15e9;
f_down = 12e9;

PIRE_sat_dBW = 80 - 30;

Angulo_elevacion = 35; %en grados

PIREmax_est_dBW = 68;
G_T_est = 28;

%antena receptora
d = 40620e3;
h = 4.1e3;
Grx_dB = 40;

T0 = 290;
T_antena = 65;
T_fisica = 295;

figura_ruido_dB = 4;
figura_ruido = 10^(figura_ruido_dB/10);

G_A_dB = 25;
G_A = 10^(G_A_dB/10);

figura_ruido_rec_dB = 12;
figura_ruido_rec = 10^(figura_ruido_rec_dB/10);

Lt_dB = 1;
Lt = 10^(Lt_dB/10);

Lgases_dB = 0.02;
Margen = 0.5 + 0.5 + 1;
Lad_down_dB = Lgases_dB;

T1 = T_fisica*(Lt-1);
T2 = T0*(figura_ruido-1);
T3 = T0*(figura_ruido_rec-1);
T_tot = T_antena + T1 + T2*Lt + T3*Lt/G_A; %T_antena/Lt + T1/Lt + T2 + T3/G_A;


%a)	La atenuación específica para el canal descendente (dB/Km),
% para una intensidad de lluvia excedida en el 0,01% del tiempo

c = 3e8;

lambda = c/f_down;
f = f_down*1e-9;

q = 0.01; 

k = 0.3884;
alpha = 0.8552;


%b)	La atenuación por lluvia para el canal descendente que sólo se supera el 0,01% del tiempo.
% Si los CAG disponibles para equipar la estación terrena tienen 10, 12, 14, 16, 18, 20 y 22dB 
% de margen de amplificación, ¿Cuál de ellos escogería?

%Paso 2

% R_001_alpha = R_001_mmh^alpha;
% gamma_R = k*R_001_alpha; % Atenuación específica (dB/Km)



%Paso 3 en radioenlace terrenal

% d_eff = (d/1000)*1/(0.477*(d/1000)^0.633*R_001_mmh^(0.073*alpha)*(f)^0.123 -(10.579*(1-exp(-0.024*(d/1000))))); % Correccion del rayo

%Paso 4

% F_01 = gamma_R *d_eff; % En 1h/año la lluvia va a atenuar al menos F0.01
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



%c)	Calcular la G/T de la estación terrena receptora.

G_T_estrx = Grx_dB - 10*log10(T_tot);

%d)	Calcular la C/N0 del enlace descendente.

K = 1.381e-23;

Lbf_down_dB = 20*log10(4*pi*d/lambda);
Lb_down_dB =Lbf_down_dB + Lad_down_dB + Margen;

C_N0_down = PIRE_sat_dBW - Lbf_down_dB - Lad_down_dB + G_T_estrx - 10*log10(K); %No hay IBO/OBO

%e)	Si La C/N0 del enlace ascendente es 85dB. ¿Cuál sería la C/N0|T del sistema? 
% ¿Cuál de los dos enlaces limita la calidad del sistema y por qué?

C_N0_up = 85;
c_n0_total  = 1./(1./(10.^(C_N0_up./10))+ 1./(10.^(C_N0_down./10)));
C_N0_total = 10*log10(c_n0_total); %TDMA no tiene productos IM