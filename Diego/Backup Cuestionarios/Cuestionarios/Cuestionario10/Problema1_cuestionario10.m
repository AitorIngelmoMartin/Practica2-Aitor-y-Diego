% Un radioenlace que trabaja a 23GHz está compuesto por dos vanos y una única sección de conmutación. Las estaciones de radiocomunicación cuentan con un dispositivo CAG con un margen dinámico de 35 dB para protegerse frente a los desvanecimientos. Los parámetros que caracterizan dicho enlace con capacidad de 50 Mbps son:
% - Longitudes de los vanos: 24 y 15 km
% - Los receptores de las estaciones están descritas en la figura adjunta
% - Polarización horizontal.
% - Ganancias de las antenas: 35dB
% - Pérdidas de conexión en los transmisores: 1,5 dB
% - La atenuación específica debida a gases atmosféricos es aproximadamente 0,5dB/km.
% - Eb/N0 = 13 dB (debida únicamente al esquema de modulación)
% - Debido a la presencia de interferencias debidas a un servicio fijo satelital conlleva asumir una degradación del umbral de 6 dB. A la que se suma otra degradación de un 1 dB debido al factor de roll-off del filtro utilizado (α=0,4)
% - MTTR y MTBF de los equipos 20 horas y 10^6 horas respectivamente
% - Datos lluvia: k=0,1286, α=1,0214, R0,01=27 mm/h
% Determinar la calidad de disponibilidad y la potencia mínima que tienen que transmitir las estaciones para que todo el radioenlace sea viable.

clc;clear;

c = 3e8;
f = 23e9;
lambda = c/f;

G_dB = 35;
G= 10^(G_dB/10);

Lt_dB = 1.5;
Lt = 10^(Lt_dB/10);

Grf_dB = 15;
Grf = 10^(Grf_dB/10);


figura_ruido_rf_dB = 10;
figura_ruido_rf = 10^(figura_ruido_rf_dB/10);

L_mezclador_dB = 3;
L_mezclador = 10^(L_mezclador_dB/10);

Gfi_dB = 20;
Gfi = 10^(Gfi_dB/10);

figura_ruido_fi_dB = 20;
figura_ruido_fi = 10^(figura_ruido_fi_dB/10);

Eb_N0 = 13;
degradacion = 6 + 1;
roll_off = 0.4;
Rb = 50e6;

R_001 = 27;
alpha = 1.0214;
k = 0.1286;

"CAG"
MD_vano1 = 35;

dvano1 = 24e3;
dvano2 = 15e3;

MTTR = 20;
MTBF = 1e6;

%---------------------------------
%VANO1

K = 1.381e-23;

Tant = 350;
T0 = 290;
T1 = T0*(Lt-1);
T2 = T0*(figura_ruido_rf-1);
T3 = T0*(L_mezclador-1);
T4 = T0*(figura_ruido_fi-1);

T_total = Tant/Lt + T1/Lt + T2 + T3/Grf + T4*L_mezclador/Grf;

gamma_gases =0.5;
Lgases_vano1_dB = gamma_gases*dvano1/1000;
Lbf_vano1_dB =20*log10(4*pi*dvano1/lambda);
Lb_vano1_dB=Lbf_vano1_dB+Lgases_vano1_dB;
Umbral=Eb_N0+10*log10(K*T_total*Rb)+degradacion+30;
Prxd_vano1_dBm = Umbral;
% Prxd_vano1_dBm = PIRE_dBW - Lb_vano1_dB + G_dB - Lt_dB + 30;
PIRE_vano1_dBm = Prxd_vano1_dBm + Lb_vano1_dB - G_dB + Lt_dB ;
Ptx_vano1_dBm = PIRE_vano1_dBm + Lt_dB - G_dB;
%q DEBIDO A LA LLUVIA

%Paso 2

R_001_alpha = R_001^alpha;
gamma_R = k*R_001_alpha; % Atenuación específica (dB/Km)

%Paso 3 en radioenlace terrenal

d_eff=(0.477*(dvano1*1e-3)^0.633*R_001^(0.073*alpha)*(f*1e-9)^0.123)-(10.579*(1-exp(-0.024*(dvano1*1e-3))));

%Paso 4

if d_eff<0.4
 Lef=(dvano1*1e-3)*2.5;
else
 Lef=(dvano1*1e-3)/d_eff;
end
F_001=gamma_R*Lef;
if (f*1e-9)>=10
 C0=0.12+0.4*log10(((f*1e-9)/10)^0.8);
else
 C0=0.12;
end
C1=(0.07^C0)*(0.12^(1-C0));
C2=0.855*C0+0.546*(1-C0);
C3=0.139*C0+0.043*(1-C0);
 % MD mínimo cuando q=1%
MDmin=F_001*C1*1^(-C2-C3*log10(1));
 % MD máximo cuando q=0.001%
MDmax=F_001*C1*0.001^(-C2-C3*log10(0.001));
if MD_vano1>MDmin
 if MD_vano1<MDmax
 solucion=roots([C3 C2 log10(MD_vano1/(F_001*C1))]);
 q=10^(max(solucion));
 else
 q=0.001;
 end
else
 q=Inf;
end

Ueq=1.5*100*(MTTR/MTBF);
Utotalvano1=Ueq+q;

%VANO 2

gamma_gases =0.5;
Lgases_vano2_dB = gamma_gases*dvano2/1000;
Lbf_vano2_dB =20*log10(4*pi*dvano2/lambda);
Lb_vano2_dB=Lbf_vano2_dB+Lgases_vano2_dB;
Prxd_vano2_dBm = Umbral;
MD_vano2=MD_vano1;
PIRE_vano2_dBm = Prxd_vano2_dBm + Lb_vano2_dB - G_dB + Lt_dB ;
Ptx_vano2_dBm = PIRE_vano2_dBm + Lt_dB - G_dB;

%q DEBIDO A LA LLUVIA

%Paso 2

R_001_alpha = R_001^alpha;
gamma_R = k*R_001_alpha; % Atenuación específica (dB/Km)

%Paso 3 en radioenlace terrenal

d_eff=(0.477*(dvano2*1e-3)^0.633*R_001^(0.073*alpha)*(f*1e-9)^0.123)-(10.579*(1-exp(-0.024*(dvano2*1e-3))));

%Paso 4

if d_eff<0.4
 Lef=(d*1e-3)*2.5;
else
 Lef=(dvano2*1e-3)/d_eff;
end
F_001=gamma_R*Lef;
if (f*1e-9)>=10
 C0=0.12+0.4*log10(((f*1e-9)/10)^0.8);
else
 C0=0.12;
end
C1=(0.07^C0)*(0.12^(1-C0));
C2=0.855*C0+0.546*(1-C0);
C3=0.139*C0+0.043*(1-C0);
 % MD mínimo cuando q=1%
MDmin=F_001*C1*1^(-C2-C3*log10(1));
 % MD máximo cuando q=0.001%
MDmax=F_001*C1*0.001^(-C2-C3*log10(0.001));
if MD_vano2>MDmin
 if MD_vano2<MDmax
 solucion=roots([C3 C2 log10(MD_vano2/(F_001*C1))]);
 q=10^(max(solucion));
 else
 q=0.001;
 end
else
 q=Inf;
end

Ueq=1.5*100*(MTTR/MTBF);
Utotalvano2=Ueq + q;

%-----------------------------------------

Utotal = Utotalvano1 + Utotalvano2;