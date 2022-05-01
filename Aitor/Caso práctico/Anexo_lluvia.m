clc;clear
f = 28.5e9;
Distancia = 21e3;

f       = f/(1e9);Distancia =Distancia/1000;
K_lluvia = 0.2051

R_001   = 29;       % mm/Km
Alpha = 0.9679;     %Tabulando casi a 20 en PV

Gamma_r  = K_lluvia* R_001^Alpha %dB/Km
Deff     = (Distancia)/(0.477*(Distancia^0.633)*(R_001^(0.073*Alpha))*(f^(0.123))-10.579*(1-exp(-0.024*Distancia))) %Km

F_001    = Gamma_r * Deff % dB

if(f>=10)
 C0 = 0.12+0.4*log10((f/10)^0.8);
else
 C0 = 0.12;    
end

C1 = (0.07^C0)  * (0.12^(1-C0));
C2 = (0.855*C0) + 0.5446*(1-C0);
C3 = (0.139*C0) + 0.043* (1-C0);

if(q == 0.01)
Fq_dB = F_001; % ya que q=0.01
end

Fq_dB   = F_001_PH*C1*(q^(-(C2+C3*log10(q))))

% Calcular q -----------------------------------
MD_dB = Fq_dB
logaritmo = log10(MD_dB/(F_001_PH*C1));

soluciones_x =  [( -C2 + sqrt( C2*C2 -4*logaritmo*C3 ) )/(2*C3),( -C2 - sqrt( C2*C2 -4*logaritmo*C3 ) )/(2*C3)];
x =max(soluciones_x);
q_calculado = 10^x

Fq_calculado_dB = F_001*C1*(q_calculado^(-(C2+C3*log10(q_calculado))));
% Calcular q -----------------------------------

U = 15 + 30*log10(f);

if (f>8 && f<=20)
    V = 12.8*f^0.19;
elseif (f>20 && f<=35)
    V = 22.6;
end

XPD_ll = U - V*log10(Fq_dB);
