clc;clear;close all;


MTBF = 175320; %En horas
MTTR = 24;
G_dB = 43.6;
R_punto_medio =40.141518816862316;

f         = 23e9;
lambda    = 3e8/(f);
Distancia_total = 55.1e3;

potencia =0;

Vanos_maximos    = 4;
for i=1:(Vanos_maximos)
   Distancia(i) =  Distancia_total/(i);
end
Distancia(:,1)      =[];

Umbral_dataSheet = [-85 -81.5 -75 -72 -68.5 -64.5];
Umbral_dataSheet = Umbral_dataSheet+2;
Ptx_dBm          = [19.5 17.5 17 16.5 15.5 13.5];

 
Lgas_dB = 0.16*((Distancia)/1000);
Lt_dB   = 1.5;
Lbf_dB  = 20*log10((4*pi*Distancia)/lambda);

longitud            = size(Ptx_dBm);
numero_iteraciones  = longitud(1,2);
longitud_2          = size(Distancia);
numero_tramos       = longitud_2(1,2);

for iteracion=1:numero_iteraciones
    for tramo=1:numero_tramos
        Prx_dBm(tramo,iteracion) = Ptx_dBm(iteracion)  + G_dB - Lt_dB - Lbf_dB(tramo) - Lgas_dB(tramo) + G_dB - Lt_dB -2
    end
end

Margen_dBm       = Prx_dBm - Umbral_dataSheet
 
f        = f/(1e9);Distancia = Distancia/1000;
K_lluvia = 0.1286;
Alpha    = 1.0214;     
 
R_001_total = R_punto_medio
Gamma_r     = K_lluvia*(R_001_total.^(Alpha)) %dB/Km
Deff        = (Distancia)./(0.477*(Distancia.^0.633)*(R_001_total.^(0.073*Alpha))*(f^(0.123))-10.579*(1-exp(-0.024*Distancia))) %Km

F_001     = Gamma_r .* Deff % dB

if(f>=10)
  C0 = 0.12+0.4*log10((f/10)^0.8);
else
  C0 = 0.12;    
end

C1 = (0.07^C0)  * (0.12^(1-C0));
C2 = (0.855*C0) + 0.5446*(1-C0);
C3 = (0.139*C0) + 0.043* (1-C0);

MD_dB = Margen_dBm;

for iteracion=1:numero_iteraciones
    for tramo=1:numero_tramos
      logaritmo(tramo,iteracion) = log10(MD_dB(tramo,iteracion)/(F_001(tramo)*C1));
    end
end

for iteracion=1:numero_tramos
 soluciones_x(iteracion,:) =  [( -C2 + sqrt( C2*C2 -4*logaritmo(iteracion,:)*C3 ) )/(2*C3),( -C2 - sqrt( C2*C2 -4*logaritmo(iteracion,:)*C3 ) )/(2*C3)];
end

for iteracion=1:(numero_iteraciones)
    for tramo = 1:numero_tramos
        x1    = soluciones_x(:,iteracion);
        x2    = soluciones_x(:,iteracion+6);
        x(iteracion,:) = max(x1,x2);
    end
end
 q_calculado = 10.^x;
 q_calculado = transpose(q_calculado);

  
 U_equipo = (MTTR/MTBF)*100;
 
 U_equipos_2 = [1.5 1.5]*U_equipo;
 U_equipos_3 = [1.5 1 1.5]*U_equipo;
 U_equipos_4 = [1.5 1 1 1.5]*U_equipo;
 
 U_equipos_2 = sum(U_equipos_2);
 U_equipos_3 = sum(U_equipos_3);
 U_equipos_4 = sum(U_equipos_4);
 
 q_calculado_total_alcatel = [q_calculado(1,:) + U_equipos_2; q_calculado(2,:) + U_equipos_3; q_calculado(3,:) + U_equipos_4 ];
 
%  MOTOROLA 
%  -----------------------------------------------------------------------
MTBF = 175320; %En horas
MTTR = 45;
G_dB = 43.6;
R_punto_medio =40.141518816862316;

f         = 23e9;
lambda    = 3e8/(f);
Distancia_total = 55.1e3;

Vanos_maximos    = 4;
for i=1:(Vanos_maximos)
   Distancia(i) =  Distancia_total/(i);
end
Distancia(:,1)      =[];

Umbral_dataSheet = [-85 -80.3 -76.4 -73.9 -70.9 -68.2];
Ptx_dBm          = [19.5 17.5   22    17   17      15];
Umbral_dataSheet = Umbral_dataSheet+2;

Lgas_dB = 0.16*((Distancia)/1000);
Lt_dB   = 1.5;
Lbf_dB  = 20*log10((4*pi*Distancia)/lambda);

longitud            = size(Ptx_dBm);
numero_iteraciones  = longitud(1,2);
longitud_2          = size(Distancia);
numero_tramos       = longitud_2(1,2);

for iteracion=1:numero_iteraciones
    for tramo=1:numero_tramos
        Prx_dBm(tramo,iteracion) = Ptx_dBm(iteracion)  + G_dB - Lt_dB - Lbf_dB(tramo) - Lgas_dB(tramo) + G_dB - Lt_dB -2
    end
end

Margen_dBm       = Prx_dBm - Umbral_dataSheet
 
f        = f/(1e9);Distancia = Distancia/1000;
K_lluvia = 0.1286;
Alpha    = 1.0214;     
 
R_001_total = R_punto_medio
Gamma_r     = K_lluvia*(R_001_total.^(Alpha)) %dB/Km
Deff        = (Distancia)./(0.477*(Distancia.^0.633)*(R_001_total.^(0.073*Alpha))*(f^(0.123))-10.579*(1-exp(-0.024*Distancia))) %Km

F_001     = Gamma_r .* Deff % dB

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
    for tramo=1:numero_tramos
      logaritmo(tramo,iteracion) = log10(MD_dB(tramo,iteracion)/(F_001(tramo)*C1));
    end
end

for iteracion=1:numero_tramos
 soluciones_x(iteracion,:) =  [( -C2 + sqrt( C2*C2 -4*logaritmo(iteracion,:)*C3 ) )/(2*C3),( -C2 - sqrt( C2*C2 -4*logaritmo(iteracion,:)*C3 ) )/(2*C3)];
end

for iteracion=1:(numero_iteraciones)
    for tramo = 1:numero_tramos
        x1    = soluciones_x(:,iteracion);
        x2    = soluciones_x(:,iteracion+6);
        x(iteracion,:) = max(x1,x2);
    end
end
 q_calculado = 10.^x;
 q_calculado = transpose(q_calculado);

  
 U_equipo = (MTTR/MTBF)*100;
 
 U_equipos_2 = [1.5 1.5]*U_equipo;
 U_equipos_3 = [1.5 1 1.5]*U_equipo;
 U_equipos_4 = [1.5 1 1 1.5]*U_equipo;
 
 U_equipos_2 = sum(U_equipos_2);
 U_equipos_3 = sum(U_equipos_3);
 U_equipos_4 = sum(U_equipos_4);
 
 q_calculado_total_motorola = [q_calculado(1,:) + U_equipos_2; q_calculado(2,:) + U_equipos_3; q_calculado(3,:) + U_equipos_4 ];
 
%  Eclipse
% ------------------------------------------------------------------------

MTBF = 175320; %En horas
MTTR = 36;
G_dB = 43.6;
R_punto_medio =40.141518816862316;

f         = 23e9;
lambda    = 3e8/(f);
Distancia_total = 55.1e3;

potencia =0;

Vanos_maximos    = 4;
for i=1:(Vanos_maximos)
   Distancia(i) =  Distancia_total/(i);
end
Distancia(:,1)      =[];

Umbral_dataSheet = [-85 -75.5 -75 -71 -70 -64.5];
Ptx_dBm          = [19.5 17.5  17 16.5 15.5 13.5];
Umbral_dataSheet = Umbral_dataSheet+2;

Lgas_dB = 0.16*((Distancia)/1000);
Lt_dB   = 1.5;
Lbf_dB  = 20*log10((4*pi*Distancia)/lambda);

longitud            = size(Ptx_dBm);
numero_iteraciones  = longitud(1,2);
longitud_2          = size(Distancia);
numero_tramos       = longitud_2(1,2);

for iteracion=1:numero_iteraciones
    for tramo=1:numero_tramos
        Prx_dBm(tramo,iteracion) = Ptx_dBm(iteracion)  + G_dB - Lt_dB - Lbf_dB(tramo) - Lgas_dB(tramo) + G_dB - Lt_dB -2
    end
end

Margen_dBm       = Prx_dBm - Umbral_dataSheet
 
f        = f/(1e9);Distancia = Distancia/1000;
K_lluvia = 0.1286;
Alpha    = 1.0214;     
 
R_001_total = R_punto_medio
Gamma_r     = K_lluvia*(R_001_total.^(Alpha)) %dB/Km
Deff        = (Distancia)./(0.477*(Distancia.^0.633)*(R_001_total.^(0.073*Alpha))*(f^(0.123))-10.579*(1-exp(-0.024*Distancia))) %Km

F_001     = Gamma_r .* Deff % dB

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
    for tramo=1:numero_tramos
      logaritmo(tramo,iteracion) = log10(MD_dB(tramo,iteracion)/(F_001(tramo)*C1));
    end
end

for iteracion=1:numero_tramos
 soluciones_x(iteracion,:) =  [( -C2 + sqrt( C2*C2 -4*logaritmo(iteracion,:)*C3 ) )/(2*C3),( -C2 - sqrt( C2*C2 -4*logaritmo(iteracion,:)*C3 ) )/(2*C3)];
end

for iteracion=1:(numero_iteraciones)
    for tramo = 1:numero_tramos
        x1    = soluciones_x(:,iteracion);
        x2    = soluciones_x(:,iteracion+6);
        x(iteracion,:) = max(x1,x2);
    end
end
 q_calculado = 10.^x;
 q_calculado = transpose(q_calculado);

  
 U_equipo = (MTTR/MTBF)*100;
 
 U_equipos_2 = [1.5 1.5]*U_equipo;
 U_equipos_3 = [1.5 1 1.5]*U_equipo;
 U_equipos_4 = [1.5 1 1 1.5]*U_equipo;
 
 U_equipos_2 = sum(U_equipos_2);
 U_equipos_3 = sum(U_equipos_3);
 U_equipos_4 = sum(U_equipos_4);
 
 q_calculado_total_eclipse= [q_calculado(1,:) + U_equipos_2; q_calculado(2,:) + U_equipos_3; q_calculado(3,:) + U_equipos_4 ];

 % hold on
% plot(q_calculado_total(1,:))
% plot(q_calculado_total(2,:))
% plot(q_calculado_total(3,:))
% hold off
% 
% title("Indisponibilidad total teórica");
% xlabel("Modulación");ylabel("valor q");
% legend("2 vanos","3 vanos","4 vanos");