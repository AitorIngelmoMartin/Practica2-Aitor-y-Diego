%  EJERCICIO 1.3*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*
clear;clc;close all;
K      = 4/3;
c      = 3e8;
f      = [300,1300, 2300, 3300, 4300,7475,12650, 17825, 23000].*1e6;
lambda = c./f;
d      = 20.09e3;
R0     = 6370e3;
Re     = R0*K;

e  = [786 800 803 799 735 760 788 795];
a  = [10 0 0 0 0 0 0  10];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;

flecha         = d1.*d2/(2*Re);
altura_rayo    = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);
despejamiento  = e + flecha - altura_rayo;
    
numero_iteraciones    = size(lambda);
columnas              = size(f);
for iteracion=1:numero_iteraciones(2)
    R1(iteracion,:) = sqrt(lambda(1,iteracion)*d1.*d2/d); %Altura del primer rayo de Fresnel    
end

despejamiento(:,1)    =[];
despejamiento(:,end)  =[];
d1(:,1)        =[];
d1(:,end)      =[];
R1(:,1)        =[];
R1(:,end)      =[];
flecha(:,1)    =[];
flecha(:,end)  =[];
d2=d-d1;

obstaculo_mayor          = max(e);
posicion_obstaculo_mayor = find(e==obstaculo_mayor);
uve                      = sqrt(2)*despejamiento./R1;
Ldif_iterado             = 6.9 + 20*log10(sqrt((uve-0.1).^2 +1) + uve-0.1);


Ldif_sd                                      = zeros(1,numero_iteraciones(2));
uve_obstaculo_principal_y_subvano            = zeros(numero_iteraciones(2),3);
posicion_uve_menos_negativo_inferior_subvano = zeros(numero_iteraciones(2),3);

 for iteracion=1:numero_iteraciones(2)
        
    uve_obstaculo_principal_y_subvano(iteracion,:)  = [uve(iteracion,posicion_obstaculo_mayor-1),uve(iteracion,posicion_obstaculo_mayor),uve(iteracion,posicion_obstaculo_mayor+1)];
    posicion_uve_menos_negativo_inferior_subvano    = find( (uve(iteracion,:))>(min(uve_obstaculo_principal_y_subvano(iteracion,:))), 1, 'last' );
    
    Ldif_sd(1,iteracion)      = Ldif_iterado(iteracion,posicion_uve_menos_negativo_inferior_subvano);
    Ldiff_sin_CN(iteracion,:) = Ldif_iterado(iteracion,:) + Ldif_sd(1,iteracion);       
    
end

figure(1);title("Parámetro de difracción en función de la f")
for iteracion=1:numero_iteraciones(2)
    hold on
    plot(uve(iteracion,:));
    xticks(2:7)
    hold off
end

frec = ["300","1300", "2300", "3300", "4300","7475","12650","17825","23000"];
ylabel("Pérdidas por difracción dB ");xlabel("Obstáculo");
lgd = legend(frec);title(lgd,'Frecuencias en Mhz');

for mux=1:5   
    binomios(1,mux)=(d1(mux) +d1(mux+1));    
end


%  EJERCICIO 1.3 PARTE 2-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*

e         = [786 800 815 799 735 760 788 795];
e(:,1)    =[];
e(:,end)  =[];


altura_rayo         = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);
despejamiento       = e + flecha - altura_rayo;    
numero_iteraciones  = size(lambda);
% 
% despejamiento(:,1)    =[];
% despejamiento(:,end)  =[];
% d1(:,1)        =[];
% d1(:,end)      =[];
% R1(:,1)        =[];
% R1(:,end)      =[];
% flecha(:,1)    =[];
% flecha(:,end)  =[];
% d2=d-d1;

obstaculo_mayor          = max(e);
posicion_obstaculo_mayor = find(e==obstaculo_mayor);
uve                      = sqrt(2)*despejamiento./R1;
Ldif_iterado             = 6.9 + 20*log10(sqrt((uve-0.1).^2 +1) + uve-0.1);


Ldif_sd                                      = zeros(1,numero_iteraciones(2));
uve_obstaculo_principal_y_subvano            = zeros(numero_iteraciones(2),3);
posicion_uve_menos_negativo_inferior_subvano = zeros(numero_iteraciones(2),3);

 for iteracion=1:numero_iteraciones(2)
        
    uve_obstaculo_principal_y_subvano(iteracion,:)  = [uve(iteracion,posicion_obstaculo_mayor-1),uve(iteracion,posicion_obstaculo_mayor),uve(iteracion,posicion_obstaculo_mayor+1)];
    posicion_uve_menos_negativo_inferior_subvano    = find( (uve(iteracion,:))>(min(uve_obstaculo_principal_y_subvano(iteracion,:))), 1, 'last' );
    
    Ldif_sd(iteracion)      = Ldif_iterado(iteracion,posicion_uve_menos_negativo_inferior_subvano);
    Ldiff_sin_CN(iteracion,:) = Ldif_iterado(iteracion,:) + Ldif_sd(iteracion);       
end

figure(2);title("Obstáculodominante con cota 815")
for iteracion=1:numero_iteraciones(2)    
    hold on
    plot(Ldif_iterado(iteracion,:))
    xticks(2:7)
    hold off    
end
frec = ["300","1300", "2300", "3300", "4300","7475","12650","17825","23000"];
ylabel("Pérdidas por difracción dB ");xlabel("Obstáculo");
lgd = legend(frec);title(lgd,'Frecuencias en Mhz');

CN = sqrt((sum(d1)*prod(d1))/prod(binomios));

Ldiff_totales_dB  = Ldiff_sin_CN - 20*log10(CN);

figure(3);title("Pérdidas totales en función de F");
for iteracion=1:numero_iteraciones(2)
    hold on
    plot(Ldiff_totales_dB(iteracion,:));
    xticks(2:7)
    hold off
end
frec = ["300","1300", "2300", "3300", "4300","7475","12650","17825","23000"];
ylabel("Pérdidas por difracción dB ");xlabel("Obstáculo");
lgd = legend(frec);title(lgd,'Frecuencias en Mhz');
