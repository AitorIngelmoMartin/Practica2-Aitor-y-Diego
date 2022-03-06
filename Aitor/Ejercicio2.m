clear;close all;clc;

f      = 5800e6;
c      = 3e8;
lambda = c/f;

% Alturas, distancia y radio en metros

d  = 20.09e3; %en Km
R0 = 6370e3;

e  = [786 800 803 799 735 760 788 795];
a  = [10 0 0 0 0 0 0  10];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;



% -------------------------------------------------------------------------
k    = 4/3;
Re   = R0*k;
dmax = sqrt(2*Re)*(sqrt(e(1)+a(1))+sqrt(e(end)+a(end))); 

if(d<0.1*dmax) 
    %Código ejecutado si tierra plana
    "Tierra plana"
else
    %Código ejecutado si tierra curva
    "Tierra curva"
end
% -------------------------------------------------------------------------

K           = [0.5, 2/3 ,1, 4/3];
Re          = R0*K;
altura_rayo = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);
R1          = sqrt(lambda*d1.*d2/d); 

%Repito el código de Diego pero "K" es un vector, y por tanto "Re" tambien.

% -----------------------------------------------------------------------
% Esta parte elimina el primer y último elemento de los arrays, ya que se 
% corresponde con los valores de las torres y se obtienen valores que no se usan.
d1(:,1)   =[];
d1(:,end) =[];
e(:,1)    =[];
e(:,end)  =[];
R1(:,1)   =[];
R1(:,end) =[];
altura_rayo(:,1)   = [];
altura_rayo(:,end) = [];
% -----------------------------------------------------------------------
d2=d-d1;

obstaculo_mayor          = max(e);
posicion_obstaculo_mayor = find(e==obstaculo_mayor);

numero_iteraciones    = size(Re);
columnas              = size(d1);
flecha_iterada        = zeros(numero_iteraciones(2),columnas(2));
despejamiento_iterado = zeros(numero_iteraciones(2),columnas(2));
uve_iterado           = zeros(numero_iteraciones(2),columnas(2));
Ldif_iterado          = zeros(numero_iteraciones(2),columnas(2));
Ldiff_totales         = zeros(numero_iteraciones(2),columnas(2));
Ldif_sd               = zeros(1,numero_iteraciones(2));
uve_obstaculo_principal_y_subvano            = zeros(numero_iteraciones(2),3);
posicion_uve_menos_negativo_inferior_subvano = zeros(numero_iteraciones(2),3);

figure(1);title("Coeficiente de difracción por obstáculo");
for iteracion=1:numero_iteraciones(2)    
    flecha_iterada(iteracion,:)        = (d1.*d2)/(2*Re(iteracion));
    despejamiento_iterado(iteracion,:) =  e + flecha_iterada(iteracion,:) - altura_rayo;
    uve_iterado(iteracion,:)           = sqrt(2)*despejamiento_iterado(iteracion,:)./R1;
    Ldif_iterado(iteracion,:)          =  6.9 + 20*log10(sqrt((uve_iterado(iteracion,:)-0.1).^2 +1) + uve_iterado(iteracion,:)-0.1);
    
    uve_obstaculo_principal_y_subvano(iteracion,:)  = [uve_iterado(iteracion,posicion_obstaculo_mayor-1),uve_iterado(iteracion,posicion_obstaculo_mayor),uve_iterado(iteracion,posicion_obstaculo_mayor+1)];
    posicion_uve_menos_negativo_inferior_subvano    = find( (uve_iterado(iteracion,:))<(min(uve_obstaculo_principal_y_subvano(iteracion,:))), 1, 'last' );
    
    Ldif_sd(1,iteracion)      = Ldif_iterado(iteracion,posicion_uve_menos_negativo_inferior_subvano);
    Ldiff_sin_CN(iteracion,:) = Ldif_iterado(iteracion,:) + Ldif_sd(1,iteracion);
    
    hold on
    plot(uve_iterado(iteracion,:))
    xticks(1:6);
    hold off
    
end
ylabel("Valor coeficiente");xlabel("Obstáculo");
legend("Difracción K = 1/2","Difracción K = 2/3","Difracción K = 1","Difracción K = 4/3");


figure(2);title("Ldiff de cada obstáculo por separado");
for iteracion=1:numero_iteraciones(2)
    hold on 
    plot(Ldif_iterado(iteracion,:));
    xticks(1:6);
    hold off
end
ylabel("Pérdidas en dB ");xlabel("Obstáculo");
legend("Difracción K = 1/2","Difracción K = 2/3","Difracción K = 1","Difracción K = 4/3");


for mux=1:5   
    binomios(1,mux)=(d1(mux) +d1(mux+1));    
end
CN = sqrt((sum(d1)*prod(d1))/prod(binomios));

Ldiff_totales_dB  = Ldiff_sin_CN - 20*log10(CN);

figure(3);title("Ldiff totales en funcion de K");
for iteracion=1:numero_iteraciones(2)
    hold on 
    plot(Ldiff_totales_dB(iteracion,:));
    xticks(1:6);
    hold off
end
ylabel("Pérdidas en dB ");xlabel("Obstáculo");
legend("Difracción K = 1/2","Difracción K = 2/3","Difracción K = 1","Difracción K = 4/3");

figure(4);title("Ldiff totales en funcion de K");
plot(K,Ldif_iterado(:,posicion_obstaculo_mayor));
ylabel("Pérdidas en dB ");xlabel("Obstáculo");
legend("Difracción K = 1/2","Difracción K = 2/3","Difracción K = 1","Difracción K = 4/3");
