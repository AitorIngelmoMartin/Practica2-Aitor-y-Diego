lear;clc;close all;
K      = 4/3;
c      = 3e8;
f      = [300,1300, 2300, 3300, 4300,7475,12650, 17825, 23000].*1e6;
lambda = c./f;
d      = 20.09e3;
R0     = 6370e3;
Re     = R0*K;
h1     = 807;
h2=805+8;
e  = [796 800 803 799 735 760 788 805];
a  = [10 0 0 0 0 0 0 8];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;

altura_rayo = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);

numero_iteraciones    = size(lambda);
columnas              = size(f);

for iteracion=1:numero_iteraciones(2)
    R1(iteracion,:) = sqrt(lambda(1,iteracion)*d1.*d2/d); %Altura del primer rayo de Fresnel    
end


d1(:,1)        =[];
d1(:,end)      =[];
R1(:,1)        =[];
R1(:,end)      =[];
e(:,1) = [];
e(:,end) = [];


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

Distancia_IZQ =1910;
D1_IZQ = 806;
D2_IZQ = Distancia_IZQ - D1_IZQ;
e_IZQ            = e(1);

h2_IZQ = 803;
h1_IZQ = 796+10;

AlturaRayo_IZQ   = ((h2_IZQ-h1_IZQ)/Distancia_IZQ)*D1_IZQ + h1_IZQ;


Flecha_IZQ  = (D1_IZQ*D2_IZQ)/(2*K*R0);
Despejamiento_IZQ      = Flecha_IZQ + e_IZQ - AlturaRayo_IZQ;


Rfresnell_IZQ     = sqrt((lambda*D1_IZQ*D2_IZQ)/(D1_IZQ+D2_IZQ));

Difracc_IZQ       = sqrt(2)*(Despejamiento_IZQ./Rfresnell_IZQ)

%SUBVANO DRCH---------

Distancia_DRCH =18180;
D1_DRCH = 1811;
D2_DRCH= Distancia_DRCH - D1_DRCH;
e_DRCH            = 799;

h2_DRCH = 805+8;
h1_DRCH = 803;

AlturaRayo_DRCH   = ((h2_DRCH-h1_DRCH)/Distancia_DRCH)*D1_DRCH + h1_DRCH;


    Flecha_DRCH  = (D1_DRCH*D2_DRCH)/(2*K*R0);
    Despejamiento_DRCH     = Flecha_DRCH + e_DRCH-AlturaRayo_DRCH;


Rfresnell_DRCH     = sqrt((lambda*D1_DRCH*D2_DRCH)/(D1_DRCH+D2_DRCH));

Difracc_DRCH       = sqrt(2)*(Despejamiento_DRCH./Rfresnell_DRCH)

