clear;close all;clc;

f      = 2.3e9;
c      = 3e8;
lambda = c/f;

% Alturas, distancia y radio en metros

d  = 20.09e3; %en Km
R0 = 6370e3;

e  = [796 800 803 799 735 760 788 805];
a  = [10 0 0 0 0 0 0 8];
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

numero_iteraciones    = size(Re);
columnas              = size(d1);
flecha_iterada        = zeros(numero_iteraciones(2),columnas(2));
despejamiento_iterado = zeros(numero_iteraciones(2),columnas(2));
uve_iterado           = zeros(numero_iteraciones(2),columnas(2));
Ldif_iterado          = zeros(numero_iteraciones(2),columnas(2));

figure(1);title("Coeficiente de difracción por obstáculo");
for iteracion=1:numero_iteraciones(2)    
    
    flecha_iterada(iteracion,:)        = (d1.*d2)/(2*Re(iteracion));
    
    despejamiento_iterado(iteracion,:) =  e + flecha_iterada(iteracion,:) - altura_rayo;
    
    uve_iterado(iteracion,:)           = sqrt(2)*despejamiento_iterado(iteracion,:)./R1

    Ldif_iterado(iteracion,:)          =  6.9 + 20*log10(sqrt((uve_iterado(iteracion,:)-0.1).^2 +1) + uve_iterado(iteracion,:)-0.1);
        
    hold on
    plot(uve_iterado(iteracion,:))
    xticks(1:6);
    hold off
    
end
ylabel("Valor coeficiente");xlabel("Obstáculo");
legend("Difracción K = 1/2","Difracción K = 2/3","Difracción K = 1","Difracción K = 4/3");

% ********

%SUBVANO IZQ---------

Distancia_IZQ =1910;
D1_IZQ = 806;
D2_IZQ = Distancia_IZQ - D1_IZQ;
e_IZQ            = 800;

h2_IZQ = 803;
h1_IZQ = 796+10;

AlturaRayo_IZQ   = ((h2_IZQ-h1_IZQ)/Distancia_IZQ)*D1_IZQ + h1_IZQ;

for(iteracion=1:4)
    Flecha_IZQ(iteracion)  = (D1_IZQ*D2_IZQ)/(2*K(iteracion)*R0);
    Despejamiento_IZQ(iteracion)      = Flecha_IZQ(iteracion) + e_IZQ-AlturaRayo_IZQ;
end

Rfresnell_IZQ     = sqrt((lambda*D1_IZQ*D2_IZQ)/(D1_IZQ+D2_IZQ));

Difracc_IZQ       = sqrt(2)*(Despejamiento_IZQ/Rfresnell_IZQ)

% for(iteracion=1:4)
%  Ldif_iterado(iteracion)         =  6.9 + 20*log10(sqrt((Difracc_O1(iteracion)-0.1).^2 +1) + Difracc_O1(iteracion)-0.1);
% end

% ********


%SUBVANO DRCH---------

Distancia_DRCH =18180;
D1_DRCH = 1811;
D2_DRCH= Distancia_DRCH - D1_DRCH;
e_DRCH            = 799;

h2_DRCH = 805+8;
h1_DRCH = 803;

AlturaRayo_DRCH   = ((h2_DRCH-h1_DRCH)/Distancia_DRCH)*D1_DRCH + h1_DRCH;

for(iteracion=1:4)
    Flecha_DRCH(iteracion)  = (D1_DRCH*D2_DRCH)/(2*K(iteracion)*R0);
    Despejamiento_DRCH(iteracion)      = Flecha_DRCH(iteracion) + e_DRCH-AlturaRayo_DRCH;
end

Rfresnell_DRCH     = sqrt((lambda*D1_DRCH*D2_DRCH)/(D1_DRCH+D2_DRCH));

Difracc_DRCH       = sqrt(2)*(Despejamiento_DRCH/Rfresnell_DRCH)

% for(iteracion=1:4)
%  Ldif_iterado(iteracion)         =  6.9 + 20*log10(sqrt((Difracc_O1(iteracion)-0.1).^2 +1) + Difracc_O1(iteracion)-0.1);
% end

% ********
