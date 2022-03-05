% %ESTUDIO DE LA INFLUENCIA DE LA DIFRACCIÓN EN EL RADIOENLACE 
% En primer lugar, se procederá al estudio de la influencia de los obstáculos en el radioenlace que se 
% ha implementado en PROYECTO RADIO en una atmósfera estándar (K=4/3).
% Los datos de cota y altura de antenas de las dos estaciones y de los obstáculos, se deben obtener 
% del programa. 
% Los seis obstáculos están situados a las siguientes distancias de la estación transmisora CAL1, 
% expresadas en kilómetros:
% [01, 02, 03, 04, 05, 06]= [0.806 1.910 3.721 7.831 10.955 14.965]
% Para ello, se deben seguir los siguientes pasos: 

% EJERCICIO 1. CÁLCULO DE LAS PÉRDIDAS POR DIFRACCIÓN
% Calcular las pérdidas por difracción para atmósfera estándar:
% 1. Determinar el despejamiento en forma de porcentaje del radio de la primera zona de 
% Fresnel y el parámetro de difracción (ν) correspondiente a los obstáculos presentes, las 
% alturas consideradas para las antenas y k=4/3.
% 2. Comparar el despejamiento en forma de porcentaje de la primera zona de Fresnel del 
% obstáculo dominante con el obtenido mediante PROYECTO RADIO.
% 3. Determinar las pérdidas por difracción por múltiples obstáculos considerados como 
% aristas de cuchillo para k=4/3


clear;clc;

f = 5800e6;
c=3e8;
lambda= c/f;


% Alturas, distancia y radio en metros

d = 20.09e3; %en Km
R0 =6370e3;

e = [786 800 803 799 735 760 788 795];
a = [10 0 0 0 0 0 0  10];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;

% -------------------------------------------------------------------------
k = 4/3;
Re = R0*k;
dmax = sqrt(2*Re)*(sqrt(e(1)+a(1))+sqrt(e(end)+a(end))); 

if(d<0.1*dmax) 
    %Código ejecutado si tierra plana
    "Tierra plana"
else
    %Código ejecutado si tierra curva
    "Tierra curva"
end
% -------------------------------------------------------------------------

%Como hay obstáculos, solo existen pérdidas por difracción
    "Hay pérdidas por difracción"


   %parámetros

    flecha = d1.*d2/(2*Re);
    altura_rayo = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);
    despejamiento = e + flecha - altura_rayo;

    R1 = sqrt(lambda*d1.*d2/d); %Altura del primer rayo de Fresnel
    uve = sqrt(2)*despejamiento./R1;