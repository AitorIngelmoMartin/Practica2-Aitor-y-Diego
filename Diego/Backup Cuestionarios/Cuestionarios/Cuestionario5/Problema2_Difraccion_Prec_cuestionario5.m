clear;clc;

f = 5e9;
c=3e8;
lambda= c/f;


% Alturas, distancia y radio en metros

Prec_min_dBm =-80;
Ptx_dBW = -15;
G_dB = 27;

Epsilon_relativa = 15;
Conductividad=0.001;
Polarizacion = "horizontal";

h1 = 10;
h2 = 8;
d = 21e3;
R0 =6370e3;

Epsilon0=Epsilon_relativa-1i*60*Conductividad*lambda;

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

numerador   = sin(Phi) - sqrt(Epsilon0-(cos(Phi)^2));
denominador = sin(Phi) + sqrt(Epsilon0-(cos(Phi)^2));
 Rh =numerador/denominador;

%Polarizaciín Vertical

% numerador   = Epsilon0*sin(Phi) - sqrt(Epsilon0-(cos(Phi)^2));
% denominador = Epsilon0*sin(Phi) + sqrt(Epsilon0-(cos(Phi)^2));
% Rv =numerador/denominador;


if(Phi>=Phi_lim)
 %Código ejecutado si hay reflexión -> MTC
    "Hay pérdidas por reflexión"

else
 %Código ejecutado si hay difracción -> MDTE
    "Hay pérdidas por difracción"

    %beta = 1+1.6*thao^2+0.75*thao^4/(1+4.5*thao^2+1.35*thao^4);
    %thao_h = (2*pi*Re/lamda)^(-1/3)*((Epsilon_relativa-1)^2+(60*lambda*sigma)^2)^(-1/4);
    %thao_v = thao_h*(Epsilon_relativa^2+(60*lambda*sigma)^2)^(1/2);

        beta = 1; %siempre en PH en PV solo enn frecuencias altas

        X = beta*d*(pi/(lambda*Re^2))^(1/3);
        Y1 = 2*beta*h1*(pi^2/((lambda^2)*Re))^(1/3);
        Y2 = 2*beta*h2*(pi^2/((lambda^2)*Re))^(1/3);
        
        if(X>=1.6)
            FX = 11 + log10(X) - 17.6*X;

        else
            FX = -20*log10(X) - 5.6488*X^1.425;

        end
%------------------------------------------------------

        %Para Y1
        if(Y1>2)
           GY1 = 17.6*sqrt(beta*Y1-1.1) - 5*log10(beta*Y1-1.1) - 8;
          
        else
            GY1 = 20*log10(beta*Y1+0.1*(beta*Y1)^3);
        end   


        if (GY1 < (2+20*log10(k)))
            GY1 = 2+20*log10(k);
        end
%-----------------------------------------------------
        
        %Para Y2
        if(Y2>2)
           GY2 = 17.6*sqrt(beta*Y2-1.1) - 5*log10(beta*Y2-1.1) - 8;
          
        else
            GY2 = 20*log10(beta*Y2+0.1*(beta*Y2)^3);
        end   


        if (GY2 < (2+20*log10(k)))
            GY2 = 2+20*log10(k);
        end


        Lad_dB = - FX - GY1 - GY2;
end


% -------------------------------------------------------------------------

PIRE_dBW = Ptx_dBW + G_dB;
Lbf_dB = 20*log10(4*pi*d/lambda);
Lb_dB =Lbf_dB + Lad_dB;
Prec_dBW = PIRE_dBW - Lb_dB + G_dB;
Prec_dBm = Prec_dBW + 30;


if(Prec_dBm<Prec_min_dBm)
    "No es viable"

else 
    "Es viable"
end

