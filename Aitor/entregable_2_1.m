clear;close all;clc;

f      = 5800e6;
c      = 3e8;
lambda = c/f;

% Alturas, distancia y radio en metros

d  = 20.09e3; %en Km
R0 = 6370e3;

e  = [797 800 803 799 735 760 788 805];
a  = [11 0 0 0 0 0 0  11];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;


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
