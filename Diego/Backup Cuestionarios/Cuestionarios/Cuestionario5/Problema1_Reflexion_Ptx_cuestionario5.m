clear;clc;

f = 2.5e9;
c=3e8;
lambda= c/f;

% Alturas, distancia y radio en metros

Lt_dB = 3;
E_dBu = 71.2;
R_efectivo = -0.8628;
Gmax_dB = 34;
G_dB = 34-13;

h1 = 8;
h2 = 22;
d = 13e3;
R0 =6370e3;

%Epsilon0=Epsilon_relativa-1i*60*Conductividad*lambda;
rho = 0.1;

% -------------------------------------------------------------------------
k = 4/3;
Re = R0*k;
dmax = sqrt(2*Re)*(sqrt(h1)+sqrt(h2)); 

if(d<0.1*dmax) 
    %Código ejecutado si tierra plana
    "Tierra plana"
else
    %Código ejecutado si tierra curva
    "Tierra curva"
end
% -------------------------------------------------------------------------


if(d>0.1*dmax)
    p=(2/sqrt(3))*(k*R0*(h1+h2)+(d^2)/4)^(1/2);
    if(h1>h2)
        tetha=acos((2*k*R0*(h1-h2)*d)/p^3); 
        d1=(d/2)+p*cos((pi+tetha)/3);
        d2=d-d1;
    end
    if(h2>h1)
        tetha=acos((2*k*R0*(h2-h1)*d)/p^3);
        d2=(d/2)+p*cos((pi+tetha)/3);
        d1=d-d2;
    end
hp1=h1-(d1^2)/(2*k*R0);
hp2=h2-(d2^2)/(2*k*R0);
Phi=atan(hp1/d1)*1000;
end
Phi_lim = ((5400/(f/1e6))^(1/3));

%Polarización Horizontal

% numerador   = sin(Phi) - sqrt(Epsilon0-(cos(Phi)^2));
% denominador = sin(Phi) + sqrt(Epsilon0-(cos(Phi)^2));
%  Rh =numerador/denominador;

%Polarizaciín Vertical

% numerador   = Epsilon0*sin(Phi) - sqrt(Epsilon0-(cos(Phi)^2));
% denominador = Epsilon0*sin(Phi) + sqrt(Epsilon0-(cos(Phi)^2));
% Rv =numerador/denominador;


if(Phi>=Phi_lim)
 %Código ejecutado si hay reflexión -> MTC
    "Hay pérdidas por reflexión"
    
        dif_caminos =sqrt( d^2 + abs(hp1+hp2)^2 ) - sqrt( d^2 + (hp1-hp2)^2 );
        
        %Divergencia = ( 1 + (5*(d1/1000)^2*d2/1000)/(16*k*(d/1000)*hp1))^(-0.5);
        %R_efectivo = Rv*Divergencia; %terreno liso: gamma <0,3 (exp(-gamma^2/2))=1;

        %gamma = 4*pi*rho*sin(Phi)/lambda;
        %R_efectivo = Rv*Divergencia*exp(-gamma^2/2);
        
        exponente = (-1i*2*pi*dif_caminos/lambda);  
        %Lad=-20*log10(abs(1+R_efectivo*exp(-1i*((2*pi)/lambda)*dif_caminos)));
        Lad_dB=-20*log10(abs(1+R_efectivo*exp(exponente)));     
else
 %Código ejecutado si hay difracción -> MDTE
    "Hay pérdidas por difracción"
end

% -------------------------------------------------------------------------

pire_W = (((10^(E_dBu/20))*1e-6)^2*d^2*10^(Lad_dB/10))/30;
PIRE_dbW = 10*log10(pire_W);
Ptx_dBW = PIRE_dbW - G_dB + Lt_dB;