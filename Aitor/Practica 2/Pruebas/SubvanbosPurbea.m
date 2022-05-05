clear;clc;close all;
K      = 4/3;
c      = 3e8;
f      = [300,1300, 2300, 3300, 4300,7475,12650, 17825, 23000].*1e6;
lambda = c./f;
d      = 20.09e3;
R0     = 6370e3;
Re     = R0*K;
h1     = 807;

e  = [796  800     815     799    735      760     788  805];
a  = [10    0       0       0     0         0       0     8];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;

flecha         = d1.*d2/(2*Re);
altura_rayo    = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);
despejamiento  = e + flecha - altura_rayo;
  
altura_rayo(:,1)    =[];
altura_rayo(:,end)  =[];

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

uve                      = sqrt(2).*despejamiento./R1;
Ldif_iterado             = 6.9 + 20*log10(sqrt((uve-0.1).^2 +1) + uve-0.1);

C =10+0.04*((d1(2)+d2(2))*(1/1000));

%SUBVANO IZQ---------

Distancia_IZQ =d1(2)-d1(1);
D1_IZQ = d1(2);
D2_IZQ = Distancia_IZQ - D1_IZQ;
e_IZQ  = e(1);
h2_IZQ = e(2);
h1_IZQ = 796+10;

AlturaRayo_IZQ    = ((h1_IZQ-h2_IZQ)*Distancia_IZQ)/D1_IZQ + h2_IZQ;
Flecha_IZQ        = (Distancia_IZQ*d1(1))/(2*K*R0);
Despejamiento_IZQ = Flecha_IZQ + e_IZQ-AlturaRayo_IZQ;
Rfresnell_IZQ     = sqrt((lambda*Distancia_IZQ*d1(1))/(D1_IZQ));
Difracc_IZQ       = sqrt(2)*(Despejamiento_IZQ./Rfresnell_IZQ)

Ldif_IZQ =transpose(6.9 + 20*log10(sqrt((Difracc_IZQ-0.1).^2 +1) + Difracc_IZQ-0.1));

for iteracion=1:9
    if (Ldif_IZQ(iteracion,:) < 0)
        Ldif_IZQ(iteracion,:) = 0;
    end
end
%SUBVANO DRCH---------

Distancia_DRCH =d1(3)-d1(2);
D1_DRCH = d2(3);
D2_DRCH= d2(4);
e_DRCH            = e(3);

h2_DRCH = 805+8;
h1_DRCH = e(2);

AlturaRayo_DRCH    = ((h2_DRCH-h1_DRCH)*Distancia_DRCH)/D1_DRCH + h1_DRCH;
Flecha_DRCH        = (Distancia_DRCH*D2_DRCH)/(2*K*R0);
Despejamiento_DRCH = Flecha_DRCH + e_DRCH-AlturaRayo_DRCH;
Rfresnell_DRCH     = sqrt((lambda*Distancia_DRCH*D2_DRCH)/(D1_DRCH));
Difracc_DRCH       = sqrt(2)*(Despejamiento_DRCH./Rfresnell_DRCH);

Ldif_DRCH          =  transpose(6.9 + 20*log10(sqrt((Difracc_DRCH-0.1).^2 +1) + Difracc_DRCH-0.1))
for iteracion=1:9
    if (Ldif_DRCH(iteracion,:) < 0)
        Ldif_DRCH(iteracion,:) = 0;
    end
end
T =1-exp(-(Ldif_iterado(:,2))/6); 

Ldiff_totales1 = Ldif_iterado(:,2) + T.*((Ldif_DRCH + Ldif_IZQ + C))

Un_obs = [2.29254501056348;2.72136865122584;3.09126706162538];

Ldif_un_obs = 6.9 + 20*log10(sqrt( (Un_obs      -0.1).^2 +1) + Un_obs      -0.1)
