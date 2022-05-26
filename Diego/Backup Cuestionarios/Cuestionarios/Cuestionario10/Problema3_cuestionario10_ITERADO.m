clc;clear;

% Un servicio de radioenlace fijo en la banda de los 13 GHz.
f = 13e9;
lambda = 3e8/f;
% El radioenlace está compuesto por dos vanos de 27 km y 19 km. 

Distancia = [27 19]*1e3;
Distancia_total = sum(Distancia);
% Teniendo en cuenta el plan de disposición de frecuencias correspondiente de la UIT (UIT-R F.497),
% en el rango de frecuencias de trabajo, 12.75 - 13.25 GHz, se 
BW_total = (13.25 -12.75)*1e9;
% transmiten 8 canales con alternancia de polarizaciones. 
% Las bandas de guarda a extremos son 15 y 23 MHz, y entre direcciones de 70 MHz.
N =8;
roll_off =0.4;

% Las estaciones terminales transmiten 20 dBm de potencia. 
Ptx_dBm = 20;
% Las antenas de todas las estaciones presentan una ganancia de 39dB en polarización horizontal, 
G_dB    = 39;
% y se encuentran conectadas a través de un cable coaxial que presenta 4 dB de pérdidas. 
Lt_dB = 4;
Lt    = 10^(Lt_dB/10);

MTTR = 5;
MTBF = 10^5;
%La figura de ruido de los receptores es 4,5 dB. La indisponibilidad total máxima es de 0,025%,
% asumiendo que en cualquier estación se necesita al menos una C/N = 18 dB 
F_receptor_dB = 4.5;
f_receptor    = 10^(F_receptor_dB/10);
U_total       =0.025;
C_N_umbral    = 18;
% 1) Calcular la velocidad binaria máxima que se puede ofrecer con el plan de frecuencias, 
% si la modulación es QPSK y el factor del filtro es 1,4. 
M =4;
Boltzman    = 1.381e-23;

Guarda_1               = 15e6;
Separacion_direcciones = 70e6;
Guarda_2               = 23e6;

% BW_total = Guarda_1 +(N-1)*Separacion_canal + Separacion_direcciones + (N-1)*Separacion_canal + Guarda_2;
Separacion_canal = (BW_total - Separacion_direcciones - Guarda_1 - Guarda_2)/(2*(N-1))
Rb_bps           = (Separacion_canal*log2(M))/(1+roll_off)
% 2) Calcular el campo eléctrico que se recibe en cada vano en condiciones normales de propagación. 
% Datos: Considerar como velocidad binaria la máxima posible y atenuador variable frente a desvanecimientos;
% R0.01=35mm/h

R_001 = 35;
Bn    = Rb_bps/(log2(M));

T0           = 290;
T_despues_lt = T0*(1/Lt) + T0*(Lt-1)*(1/Lt) + T0*(f_receptor-1);
Umbral_dBm   = C_N_umbral + 10*log10(T_despues_lt*Boltzman*Bn) +30;


K_lluvia = 0.03041;    
alpha    = 1.1586;     

gamma_R  = K_lluvia* R_001^alpha; %dB/Km
d_eff=(0.477*(Distancia*1e-3).^0.633*R_001^(0.073*alpha)*(f*1e-9)^0.123)-(10.579*(1-exp(-0.024*(Distancia*1e-3))));

%Paso 4

if d_eff<0.4
 Lef=(Distancia*1e-3).*2.5;
else
 Lef=(Distancia*1e-3)./d_eff;
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

q_total = U_total -(1.5 + 1.5)*MTTR/MTBF*100;

numero_vanos = size(Distancia);
iteraciones  = numero_vanos(1,2);

for i = 1:iteraciones
 q(i) = q_total*Distancia(i)/(sum(Distancia));
end


Fq_dB =  F_001.*C1.*(q.^(-(C2+C3.*log10(q))));

MD = Fq_dB;

%-----------------------------------------

gamma_gases = 0.022;
Lgases_dB   = gamma_gases*Distancia/1000;

Lgases = 10.^(Lgases_dB/10);
Lbf_dB = 20*log10((4*pi*Distancia)/lambda);
Lb_dB     = Lbf_dB + Lgases_dB;
Prx_dB = Ptx_dBm + G_dB - Lt_dB - Lb_dB + G_dB - Lt_dB;

PIRE_dBm = Umbral_dBm + Fq_dB + Lb_dB -G_dB +Lt_dB ;
PIRE_w   = 1e-3*10.^(PIRE_dBm/10);

e     = sqrt(30*PIRE_w./(Distancia.^2));
e_dBu = 20*log10(e/1e-6)