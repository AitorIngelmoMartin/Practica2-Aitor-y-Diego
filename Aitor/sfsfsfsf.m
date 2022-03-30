
clear;clc;

f = 2300e6;
c=3e8;
lambda= c/f;


% Alturas, distancia y radio en metros

d = 20.09e3; %en Km
R0 =6370e3;

e = [796 800 803 799 735 760 788 805];
a = [10 0 0 0 0 0 0 8];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;

% -------------------------------------------------------------------------
k = 4/3;
Re = R0*k;

%Como hay obstáculos, solo existen pérdidas por difracción
    "Hay pérdidas por difracción"


   %parámetros

    flecha = d1.*d2/(2*Re);
    altura_rayo = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);
    despejamiento = e + flecha - altura_rayo;

    R1 = sqrt(lambda*d1.*d2/d); %Altura del primer rayo de Fresnel
    uve = sqrt(2)*despejamiento./R1;

    porcentaje = (despejamiento./R1)*100;