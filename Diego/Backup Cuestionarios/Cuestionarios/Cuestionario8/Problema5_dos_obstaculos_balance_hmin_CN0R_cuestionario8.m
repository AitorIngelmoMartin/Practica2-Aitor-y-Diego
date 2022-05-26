

clear;clc;

f = 25e9;
c=3e8;
lambda= c/f;


% Alturas, distancia y radio en metros

d = 17e3; %en Km
R0 =6370e3;

e = [252 396 642 855];
a = [40 0 0 0];

d1 = [0 3e3 10e3 d];
d2 = d - d1;

%otros datos

Lt_dB = 1.5;
Lt = 10^(Lt_dB/10);

G_dB = 35;
"Polarización Horizontal"
figura_ruido_dB = 8;
figura_ruido = 10^(figura_ruido_dB/10);
MD_CAG_dB = 15;
R_001 = 26; %mm/h

% a) La altura mínima que tiene que tener la antena de la estación B para evitar pérdidas por difracción. 
% b) Si el flujo de potencia recibido en condiciones normales de propagación es de -94dBW/m^2, determinar la CN0R en condiciones normales.
    Flujo_dBW = -94; %flujo de potencia en condiciones normales en dBW/m^2
% c)Calcular el campo parásito que aparece en condiciones de máximo desvanecimiento

% -------------------------------------------------------------------------

%APARTADO A
k = 4/3;
Re = R0*k;

%parámetros

    flecha = d1.*d2/(2*Re);
    R1 = sqrt(lambda*d1.*d2/d); %Altura del primer rayo de Fresnel
    uve = -0.78;
    despejamiento = R1*uve/sqrt(2);
%   despejamiento = e + flecha - altura_rayo;
    altura_rayo = -(despejamiento - e - flecha);

%   altura_rayo = ((e(end)+a(end)-e(1)-a(1))/d) * d1 + e(1)+a(1);
    alturas = ((altura_rayo - e(1)- a(1))./d1)*d + e(1) + a(1) - e(end);
    
    a(end) = round(max(alturas)); %se coge la menor altura para que no haya pérdidas por difracción.

    
%     uve = sqrt(2)*despejamiento./R1; %tiene que ser -0.78

   if(uve <= -0.78)
        
       "Despejamiento suficiente para ambos obstáculos, no existen pérdidas por difracción"
            Lad_dB = 0;
   end


%     if(uve(2) <= -0.78)
%         if(uve(3)<= -0.78)
% 
%             "Despejamiento suficiente para ambos obstáculos, no existen pérdidas por difracción"
%             Lad_dB = 0;
%         end
%     end



%APARTADO B
f = 25;
K = 1.381e-23;
T0 = 290;
T1 = T0*(Lt - 1);
T2 = T0*(figura_ruido - 1);
T_total = T0/Lt + T1/Lt + T2;


gamma_gases = 0.15;
Lgases_dB = gamma_gases*d/1000;

Lbf_dB = 20*log10(4*pi*d/lambda);
Lb_dB =Lbf_dB + Lgases_dB + Lad_dB;

PIRE_W = 10^(Flujo_dBW/10)*(4*pi*d^2)*(10^(Lad_dB/10));

Prec_dBW = 10*log10(PIRE_W) + G_dB - Lb_dB - Lt_dB;

%otra forma
% S_eff = lambda^2/(4*pi);
% Prec_dBW = Flujo_dBW + 10*log10(S_eff) + G_dB - Lt_dB;
 
CN0R_total = Prec_dBW - 10*log10(K*T_total);

%APARTADO C campo parásito:causado por XPD lluvia

U = 15 + 30*log10(f);

if (f>8 && f<=20)
    V = 12.8*f^0.19;
elseif (f>20 && f<=35)
    V = 22.6;
end

Fll_dB = MD_CAG_dB;
XPD_ll = U - V*log10(MD_CAG_dB);

EespacioLibre = sqrt(10^(Flujo_dBW/10)*120*pi);

EespacioLibre_dBu = 20*log10(EespacioLibre/1e-6);

E_CMD_dBu = EespacioLibre_dBu - MD_CAG_dB;

Eparasito_total_dBu = E_CMD_dBu - XPD_ll;


% E_pv = PIRE_W/(4*pi*d^2*10^(MD_CAG_dB/10));
% E_pv_dBu = 20*log10(E_pv/1e-6);
% 
% 
% E_parasito_dBu = E_pv_dBu - XPD_ll;


