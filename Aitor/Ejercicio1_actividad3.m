%  EJERCICIO 1.3*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*
close all;
K = 4/3;
Re = R0*K;
f = [300,1300, 2300, 3300, 4300,7475,12650, 17825, 23000].*1e6;
lambda = c./f;


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
title(lgd,'Frecuencias en Mhz')