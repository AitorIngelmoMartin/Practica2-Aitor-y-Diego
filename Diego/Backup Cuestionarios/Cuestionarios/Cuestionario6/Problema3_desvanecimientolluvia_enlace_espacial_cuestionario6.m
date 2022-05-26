% Se analiza únicamente el enlace de bajada de un radioenlace espacial que trabaja a una frecuencia de 14 GHz. La distancia a la estación terrena, situada a 348m sobre el nivel del mar con una altura de antena de 20m en una latitud 36,71ºN y longitud 5,7ºW, es de 38920km. La estación terrena presenta un ángulo de elevación para ver al satélite de 27,3º. Asumiendo polarización horizontal, determinar la atenuación de lluvia superada en el 0,1%.
% Datos: R_001=38,89mm/h; k=0,0374; alpha=1,1396 y h0=2,33km

clear; clc;

f = 14e9;
c = 3e8;
lambda = c/f;
f = 14;

%datos

d = 38920e3;
Polarizacion = "Horizontal";

e1 = 348; %metros
a1 = 20;  %metros
h_S = (a1+e1)*1e-3;

h0 = 2.33; %en km
R_001_mmh = 38.89; % Intensidad de lluvia (mm/h)
k = 0.0374;
alpha = 1.1396;
angulo_elevacion = 27.3; %en grados
lat = 36.71; %latitud en grados
long = 5.7; %longitud en grados


q = 0.1;

R0 = 6370e3;
Re = k*R0;


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

R_001_alpha = R_001_mmh^alpha;
gamma_R = k*R_001_alpha; % Atenuación específica (dB/Km)



%Paso 3 en radioenlace espacial
h_R = h0 + 0.36; %altura de lluvia en km

if(angulo_elevacion >=5)

    LS = (h_R - h_S)/sind(angulo_elevacion);

else

    LS = (2*(h_R-h_S))/(sqrt((sind(angulo_elevacion)^2) + (2*(h_R-h_S))/Re)+sind(angulo_elevacion));

end

%-------------------------------------

LG = LS*cosd(angulo_elevacion);

r01 = 1/(1+0.78*sqrt(LG*gamma_R/f)-0.38*(1-exp(-2*LG)));

%------------------------------------

if(atand((h_R - h_S)/(LG*r01))>angulo_elevacion)

    LR = (LG*r01)/cosd(angulo_elevacion);

else
    LR = (h_R-h_S)/sind(angulo_elevacion);

end

%-----------------------------------------

if(abs(lat)<36)

    epsilon = 36-abs(lat);

else

    epsilon = 0;

end

%----------------------------------------

uve01 = 1/(1+sqrt(sind(angulo_elevacion))*(((31*(1-exp(-angulo_elevacion/(1+epsilon)))*sqrt(LR*gamma_R))/f^2) - 0.45));
d_eff = LR*uve01; % Correccion del rayo

%Paso 4

F_01 = gamma_R *d_eff; % En 1h/año la lluvia va a atenuar al menos F0.01
% Si F0.01 = MD, sistema indisponible 1h/año. %indisponibilidad = 0.01,
% %disponibilidad = 0.99

%Paso 5 

if(q>=0.01 || abs(lat)>=36)

    beta = 0;

elseif ( q<0.01 && abs(lat)<36 && angulo_elevacion>=25)

    beta = -0.005*(abs(lat)-36);

else

    beta = -0.005*(abs(lat)-36) + 1.8-4.25*sind(angulo_elevacion);

end

Fq = F_01*(q/0.01)^(-0.655-0.033*log(q)+0.045*log(F_01)+beta*(1-q)*sind(angulo_elevacion));%minimo de atenuacion de la luvia en el q% del año

