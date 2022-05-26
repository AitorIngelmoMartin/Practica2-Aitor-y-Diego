clc; clear;

%datos

c = 3e8;
d = 38.2e6;

f_up = 14e9;
f_down = 12.75e9;

Rb =  2e6;
Rb_ptdr = 34e6;

PIRE_sat_dBW = 40.8;
G_T_sat = 8.7;

Eb_N0_dB = 5.9;

G_T_est = 23;


Lt_dB = 1;





%a)	Número de estaciones móviles que podrán estar operando simultáneamente con 
% la portadora alquilada, considerando que todas ellas transmitirán y recibirán 
% información.



%b)	Degradación debida al enlace ascendente.

K = 1.381e-23;

lambda_up = c/f_up;
lambda_down = c/f_down;

Lexc_up = 0.2;
Lexc_down = 0.5;

% gamma_gases_up = 0.03;
% Lgases_up_dB = gamma_gases_up*d/1000;

% gamma_gases_down = 0.02;
% Lgases_down_dB = gamma_gases_up*d/1000;

Margen = 1.5;

Lad_up_dB =  Lexc_up + Margen; % + Lgases_up_dB;
Lad_down_dB =  Lexc_down + Margen; %+ Lgases_down_dB;

Lbf_up_dB = 20*log10(4*pi*d/lambda_up);
Lb_up_dB =Lbf_up_dB + Lad_up_dB;

Lbf_down_dB = 20*log10(4*pi*d/lambda_down);
Lb_down_dB =Lbf_down_dB + Lad_down_dB;

%----------------------------------------

C_N0_dB = Eb_N0_dB + 10*log10(Rb);

C_N0_down = PIRE_sat_dBW - Lbf_down_dB - Lad_down_dB + G_T_est - 10*log10(K);

L = C_N0_dB - C_N0_down;


%c)	PIRE de las estaciones terrenas móviles.

delta_C_N = -10*log10(10^(-L/10)-1);
C_N0_up = C_N0_down + delta_C_N;

PIRE_et_dBW = C_N0_up + Lbf_up_dB + Lad_up_dB - G_T_sat + 10*log10(K);