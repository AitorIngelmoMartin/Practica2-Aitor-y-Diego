% En la figura adjunta se representa un radioenlace para enlazar dos edificios. Debido a la existencia de otro edificio situado en la línea de vista de los edificios considerados, se estudia la alternativa de diseñar el enlace a través de un reflector:
% Frecuencia de trabajo: 18 GHz
% Régimen binario: 2 Mbps
% Modulación: 128 QAM.
% Factor de roll-off: 0,2
% Atenuación debida a gases: despreciable
% Figura de ruido del receptor: 6 dB.
% Potencia transmitida: 29 dBm
% C/N (umbral) = 9 dB
% Pérdidas en guías y branching: 1 dB.
% Antenas: Parabólicas de 36dB de ganancia.
% Reflector parabólico de 1,2m^2 de superficie geométrica
% ectivaR0,01=24 mm/h; α =1,0818; k=0,0708
% Atenuador variable frente a desvanecimientos
% Determinar la indisponibilidad de propagación debida a la atenuación por lluvia.




clc;clear;

c = 3e8;
f = 18e9;
lambda = c/f;

Rb = 2e6;
M = 128;
"128 QAM"
roll_off = 0.2;

Ptx_dBm = 29;
C_N_umbral_dB = 9;


Gant_dB = 36;
Gant = 10^(Gant_dB/10);

Sgeo = 1.2; %m^2

Lt_dB = 1;
Lt = 10^(Lt_dB/10);
figura_ruido_rx_dB = 6;
figura_ruido_rx = 10^(figura_ruido_rx_dB/10);

R_001 = 24;
alpha = 1.0818;
k = 0.0708;

"Atenuador Variable"

d_directa = 11e3;
d = 2*(sqrt(11000^2 + 3700^2));
d1 = d/2;
d2 = d - d1;
a = 3.7e3;

% GANANCIA DEL REFLECTOR

beta = atan(d_directa/a);

Seff_rp = Sgeo*cos(beta);

Grp =4*pi*Seff_rp/lambda^2;
Grp_dB = 10*log10(Grp);



% Seff_rp = lambda^2*G/(4*pi);


% POTENCIA RECIBIDA

%pérdidas vano 1
%perdidas
gamma_gases = 0;
Lgases_dB = gamma_gases*d/1000;

rendimientorp = 1;
Lrp_dB= - Grp_dB +10*log10(1/rendimientorp) - Grp_dB;

Lbf_dB = 20*log10(4*pi*d1/lambda);
Lb_dB = - Grp_dB + Lbf_dB + Lgases_dB + Lbf_dB + Lgases_dB - Grp_dB;

Prxcn_dBm = Ptx_dBm + Gant_dB - Lt_dB - Lb_dB + Gant_dB - Lt_dB;


%DISTANCIA DEL VANO



%UMBRAL A LA SALIDA DE LOS TERMINALES

K = 1.381e-23;
Bn = Rb/log2(M);

T0 = 290;
T1 = T0*(Lt - 1);
T2 = T0*(figura_ruido_rx - 1);
T_total = T0/Lt + T1/Lt + T2;

Umbral_dBm = C_N_umbral_dB + 10*log10(K*T_total*Bn) + 30;

%q DEBIDO A LA LLUVIA


MD = Prxcn_dBm - Umbral_dBm;


%Paso 2

R_001_alpha = R_001^alpha;
gamma_R = k*R_001_alpha; % Atenuación específica (dB/Km)



%Paso 3 en radioenlace terrenal

% d_eff = (d/1000)*1/(0.477*(d/1000)^0.633*R_001_mmh^(0.073*alpha)*(f*1e-9)^0.123 -(10.579*(1-exp(-0.024*(d/1000))))); % Correccion del rayo
d_eff=(0.477*(d*1e-3)^0.633*R_001^(0.073*alpha)*(f*1e-9)^0.123)-(10.579*(1-exp(-0.024*(d*1e-3))));

%Paso 4

if d_eff<0.4
 Lef=(d*1e-3)*2.5;
else
 Lef=(d*1e-3)/d_eff;
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
if MD>MDmin
 if MD<MDmax
 solucion=roots([C3 C2 log10(MD/(F_001*C1))]);
 q=10.^(max(solucion));
 else
 q=0.001;
 end
else
 q=Inf;
end


