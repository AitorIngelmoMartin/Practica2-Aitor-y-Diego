clc;clear;close all;


MTBF = 175320; %En horas
MTTR = 24;
G_dB = 43.6;
R_punto_medio =40.141518816862316;

f         = 23e9;
lambda    = 3e8/(f);
Distancia_total = 55.1e3;

Distancia = [9.7 13.6 20.7 22.1]*1e3
% Umbral_dataSheet = [-85 -81.5 -75 -72 -68.5 -64.5];
Umbral_dataSheet = -68.5+2;
 
Lgas_dB = 0.16*((Distancia)/1000);
Lt_dB   = 1.5;
Lbf_dB  = 20*log10((4*pi*Distancia)/lambda);
Ptx_dBm = 15.5;
Prx_dBm             = Ptx_dBm + G_dB - Lt_dB - Lbf_dB - Lgas_dB + G_dB - Lt_dB -2
 
longitud_2          = size(Distancia);
numero_tramos       = longitud_2(1,2);

% Prx_dBm = [-36.77 -39.6 -43.3 -43.9] -2;
longitud            = size(Prx_dBm);
numero_iteraciones  = longitud(1,2);

Margen_dBm = Prx_dBm - Umbral_dataSheet
 
f        = f/(1e9);Distancia = Distancia/1000;
K_lluvia = 0.1286;
Alpha    = 1.0214;     
 
R_001_total = R_punto_medio
Gamma_r     = K_lluvia*(R_001_total.^(Alpha)) %dB/Km
Deff        = (Distancia)./(0.477*(Distancia.^0.633)*(R_001_total.^(0.073*Alpha))*(f^(0.123))-10.579*(1-exp(-0.024*Distancia))) %Km

F_001       = Gamma_r .* Deff % dB

if(f>=10)
  C0 = 0.12+0.4*log10((f/10)^0.8);
else
  C0 = 0.12;    
end

C1 = (0.07^C0)  * (0.12^(1-C0));
C2 = (0.855*C0) + 0.5446*(1-C0);
C3 = (0.139*C0) + 0.043* (1-C0);

MD_dB = Margen_dBm

for iteracion=1:numero_iteraciones
   logaritmo(iteracion) = log10(MD_dB(iteracion)/(F_001(iteracion)*C1));
end

for iteracion=1:(numero_iteraciones)
   soluciones_x(iteracion,:) =  [( -C2 + sqrt( C2*C2 -4*logaritmo(iteracion)*C3 ) )/(2*C3),( -C2 - sqrt( C2*C2 -4*logaritmo(iteracion)*C3 ) )/(2*C3)];
end
% [-1.839294175513773,-7.573417233506026]
for iteracion=1:(numero_iteraciones)
        x1    = soluciones_x(iteracion,1)
        x2    = soluciones_x(iteracion,2)
        x(iteracion) = max(x1,x2);
end
 q_calculado = 10.^x;
 q_calculado = transpose(q_calculado)
 Suma_q =sum(q_calculado)
 
 Equipos = 2*(1.5*(MTTR/MTBF)*100) + 2*(0.5*(MTTR/MTBF)*100);  
 Total =   (Suma_q + Equipos)
 
hold on
    plot(Distancia,q_calculado)
hold off
xlabel("Distancia del vano [Km]");ylabel("valor q");

