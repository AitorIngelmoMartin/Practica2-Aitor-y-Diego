clear;clc;close all;
K      = 4/3;
c      = 3e8;
f      = [300,1300, 2300, 3300, 4300,7475,12650, 17825, 23000].*1e6;
lambda = c./f;
d      = 20.09e3;
R0     = 6370e3;
Re     = R0*K;
h1     = 807;

e  = [796 800 803 799 735 760 788 805];
a  = [10 0 0 0 0 0 0 8];
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
e(:,1) = [];
e(:,end) = [];

uve                      = sqrt(2)*despejamiento./R1;
Ldif_iterado             = 6.9 + 20*log10(sqrt((uve-0.1).^2 +1) + uve-0.1);



%SUBVANO IZQ---------

Distancia_IZQ =1910;
D1_IZQ = 806;
D2_IZQ = Distancia_IZQ - D1_IZQ;
e_IZQ            = 800;

h2_IZQ = 803;
h1_IZQ = 796+10;

AlturaRayo_IZQ   = ((h2_IZQ-h1_IZQ)/Distancia_IZQ)*D1_IZQ + h1_IZQ;


Flecha_IZQ           = (D1_IZQ*D2_IZQ)/(2*K*R0);
Despejamiento_IZQ     = Flecha_IZQ + e_IZQ-AlturaRayo_IZQ;

Rfresnell_IZQ     = sqrt((lambda*D1_IZQ*D2_IZQ)/(D1_IZQ+D2_IZQ));

Difracc_IZQ       = sqrt(2)*(Despejamiento_IZQ./Rfresnell_IZQ)

Lad_izquierda = 6.9 + 20*log10(sqrt((Difracc_IZQ-0.1).^2 +1) + Difracc_IZQ-0.1);
%SUBVANO DRCH---------

Distancia_DRCH =18180;
D1_DRCH = 1811;
D2_DRCH= Distancia_DRCH - D1_DRCH;
e_DRCH            = 799;

h2_DRCH = 805+8;
h1_DRCH = 803;

AlturaRayo_DRCH   = ((h2_DRCH-h1_DRCH)/Distancia_DRCH)*D1_DRCH + h1_DRCH;


Flecha_DRCH  = (D1_DRCH*D2_DRCH)/(2*K*R0);
Despejamiento_DRCH      = Flecha_DRCH + e_DRCH-AlturaRayo_DRCH;


Rfresnell_DRCH     = sqrt((lambda*D1_DRCH*D2_DRCH)/(D1_DRCH+D2_DRCH));

Difracc_DRCH       = sqrt(2)*(Despejamiento_DRCH./Rfresnell_DRCH)

Ldif_DRCH       =  6.9 + 20*log10(sqrt((Difracc_DRCH-0.1).^2 +1) + Difracc_DRCH-0.1)





% Ldiff_totales1(iteracion,:) = Ldif_iterado(iteracion,:) + T(iteracion,:)*(Lad_derecha(iteracion,:) + Lad_izquierda(iteracion,:) + C);
% 
% Ldiff_totales1 = [Ldiff_totales1(1) Ldiff_totales1(2) Ldiff_totales1(3) 0 0 0 0 0 0];
% 
DistanciaObstaculos = 1811;
Distancia_E1_O1 = d1(2);
Distancia_E1_O2 = d1(3);
Distancia_E2_O1 = d2(2);
Distancia_E2_O2 = d2(3);
h2 = 813;
e_O2 = e(3);
e_O1 = e(2);
for iteracion = 4:9
    Ldiff_totales2(iteracion,:) = difraccionDosObstaculos(uve(iteracion,2),uve(iteracion,3),Distancia_E1_O1,Distancia_E1_O2,Re,h1,h2,e_O2,e_O1,lambda(iteracion),Distancia_E2_O1,Distancia_E2_O2);
end
Ldif_iterado_importante = [[5.55771553466051;5.04825916991385;4.72771278143924];0;0;0;0;0;0]

C =10+0.04*(d1(2)/1000+d2(2)/1000);
T =1-exp(-(Ldif_iterado(:,2))/6);   
   
Ldiff_totales1 = Ldif_iterado(:,2) + T.*(Ldif_DRCH + Lad_izquierda + C)


Perdidas = Ldiff_totales2 + [transpose(Ldif_DRCH(1:3));0;0;0;0;0;0] + [transpose(Lad_izquierda(1:3));0;0;0;0;0;0] + Ldif_iterado_importante