% Se constituye un enlace radioeléctrico de 16 km con antenas de ganancia 27dB sintonizadas a una frecuencia de 18GHz. Las pérdidas de los terminales son despreciables, el umbral mínimo de señal esperado es de -88dBm y se trabaja con polarización vertical.
% Determinar el margen dinámico de los mecanismos de protección frente a lluvia con un porcentaje del 0,01% y la PIRE por las estaciones para:
% a) estaciones con atenuadores variables
% b) estaciones con amplificadores CAG
%  Datos:  R_001=29mm/h

clear; clc;

f = 18e9;
c = 3e8;

lambda = c/f;

f = 18; %en km

%datos

d = 16e3;
Polarizacion = "Vertical";

G_dB = 27;
Umbral_dBm = -88;

% MD_dB = 34; %Margen dinámico
alpha = 1.0025 ;
R_001 = 29; % Intensidad de lluvia (mm/h)
k = 0.07708 ;
q = 0.01; %porciento


%----------------------------------------------------------------------
%Paso 1

% Nii = ;%Numero de dias de cada mes en Cº
% tii = ;%temperatura media mensual en la superficie en Cº
% MTii = ;% Intensidad de lluvia mensual total (mm) 
% 
% if(tii > 0)
%     rii = 0.5874*exp(0.0883*tii); % temperatura que hay en cada mes
% else
%     rii = 0.5874;
% end
% 
% P0ii = 100*MTii/(24*Nii*rii); % Probabilidad de que llueva en cada mes
% Pii = P0ii * 0.5*erfc(ln(Rq)+0.7938-ln(rii)/(1.26*sqrt(2))); %Probabilidad de que R > Rq
% 
% q = Nii*Pii/365.25;%Valor de lluvia que se supera en el q % de un año

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

%--------------------------------------------------------------------------

% proteccion = 100 - q;

%Perdidas

%  Lgases_dB = %en km
 gamma_gases = 0.09;
 Lgases_dB = gamma_gases*d/1000;
 Lbf_dB = 20*log10(4*pi*d/lambda);
 Lb_dB =Lbf_dB + Lgases_dB;

 PIRE_dBm_at = Umbral_dBm + MD_dB - G_dB + Lb_dB ;
 PIRE_dBm_CAG = Umbral_dBm - G_dB + Lb_dB;