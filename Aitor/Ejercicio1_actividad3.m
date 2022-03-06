%  EJERCICIO 1.3*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*
clear;clc;close all;
K = 4/3;
c = 3e8;
f = [300,1300, 2300, 3300, 4300,7475,12650, 17825, 23000].*1e6;
lambda = c./f;
d  = 20.09e3; %en Km
R0 = 6370e3;
Re = R0*K;

e  = [786 800 803 799 735 760 788 795];
a  = [10 0 0 0 0 0 0  10];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;

flecha         = d1.*d2/(2*Re);
altura_rayo    = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);
despejamiento  = e + flecha - altura_rayo;
    
numero_iteraciones    = size(lambda);
   %parámetros
for iteracion=1:numero_iteraciones(2)
    R1(iteracion,:) = sqrt(lambda(1,iteracion)*d1.*d2/d); %Altura del primer rayo de Fresnel
    
end

uve = sqrt(2)*despejamiento./R1;
Ldif_iterado= 6.9 + 20*log10(sqrt((uve-0.1).^2 +1) + uve-0.1);

figure(1)
for iteracion=1:numero_iteraciones(2)
    hold on
    plot(Ldif_iterado(iteracion,:))
    xticks([2:7])
    hold off
end
frec = ["300","1300", "2300", "3300", "4300","7475","12650","17825","23000"];
ylabel("Pérdidas por difracción dB ");
xlabel("Obstáculo");
lgd = legend(frec);
title(lgd,'Frecuencias en Mhz');

%  EJERCICIO 1.3 PARTE 2-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*

e  = [786 800 815 799 735 760 788 795];

altura_rayo    = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);
despejamiento  = e + flecha - altura_rayo;
    
numero_iteraciones    = size(lambda);
   %parámetros
for iteracion=1:numero_iteraciones(2)
    R1(iteracion,:) = sqrt(lambda(1,iteracion)*d1.*d2/d); %Altura del primer rayo de Fresnel
    
end

uve = sqrt(2)*despejamiento./R1;
Ldif_iterado= 6.9 + 20*log10(sqrt((uve-0.1).^2 +1) + uve-0.1);

figure(2);title("Obstáculodominante con cota 815")
for iteracion=1:numero_iteraciones(2)
    hold on
    plot(Ldif_iterado(iteracion,:))
    xticks([2:7])
    hold off
end
frec = ["300","1300", "2300", "3300", "4300","7475","12650","17825","23000"];
ylabel("Pérdidas por difracción dB ");
xlabel("Obstáculo");
lgd = legend(frec);
title(lgd,'Frecuencias en Mhz');
