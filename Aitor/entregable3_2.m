%  EJERCICIO 1.3*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*
clear;clc;close all;
K      = 4/3;
c      = 3e8;
f      = [300,1300, 2300, 3300, 4300,7475,12650, 17825, 23000].*1e6;
lambda = c./f;
d      = 20.09e3;
R0     = 6370e3;
Re     = R0*K;
h1     = 807;

e  = [797 800 803 799 735 760 788 805];
a  = [10 0 0 0 0 0 0  8];
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

d2=d-d1;

obstaculo_mayor          = max(e);
posicion_obstaculo_mayor = find(e==obstaculo_mayor);
uve                      = sqrt(2)*despejamiento./R1;
Ldif_iterado             = 6.9 + 20*log10(sqrt((uve-0.1).^2 +1) + uve-0.1);


Ldif_sd                                      = zeros(1,numero_iteraciones(2));
uve_obstaculo_principal_y_subvano            = zeros(numero_iteraciones(2),3);
posicion_uve_menos_negativo_inferior_subvano = zeros(numero_iteraciones(2),3);
altura_rayo(:,1) = [];
altura_rayo(:,end) = [];

flecha        = (d1.*d2)/(2*Re);
despejamiento =  e + flecha - altura_rayo;
for iteracion=1:numero_iteraciones(2)       
    uve_iterado(iteracion,:)   = sqrt(2)*despejamiento./R1(iteracion,:);   
end
figure(1);title("Parámetro de difracción en función de la f")
% find(uve_iterado(5,:) < -0.78)
for iteracion=1:numero_iteraciones(2)
    hold on
    plot(uve(iteracion,:));
    xticks(1:7)
    hold off
end

frec = ["300","1300", "2300", "3300", "4300","7475","12650","17825","23000"];
ylabel("Parametro de difracción");xlabel("Obstáculo");
lgd = legend(frec);title(lgd,'Frecuencias en Mhz');


d_izq   = d1(2);
d1_izq  = d1(1);
d2_izq  = d1(2)-d1(1);
h2_izq  = e(2);
h1_izq  = h1;
AlturaRayo_izq   = ((h2_izq-h1_izq)/d_izq)*d1_izq+h1_izq;


Flecha_izquierda        = (d1_izq*d2_izq)/(2*Re);
Despejamiento_izquierda = Flecha_izquierda + e(1) - AlturaRayo_izq;      
        
d_drch  = d2(2);
d1_drch = d1(3)-d1(2);
d2_drch = d2(3);
h2_drch = e(6);
h1_drch = e(2);
AlturaRayo_drch  = ((h2_drch-h1_drch)/d_drch)*d1_drch+h1_drch;

Flecha_derecha        = (d1_drch*d2_drch)/(2*Re);
Despejamiento_derecha = Flecha_derecha + e(1) - AlturaRayo_drch;   

C =10+0.04*(d1(2)/1000+d2(2)/1000);

figure(5);title("Ldiff obstáculos con V > -0.78")
for iteracion=1:numero_iteraciones(2)

   %IZQUIERDA 
        R1_izq(iteracion,:)        = sqrt(lambda(1,iteracion)*d1_izq*d2_izq/d_izq);
  
        uve_izquiera(iteracion,:)  = sqrt(2)*(Despejamiento_izquierda./R1_izq(iteracion,:));
        
        Lad_izquierda(iteracion,:) = 6.9 + 20*log10(sqrt((uve_izquiera(iteracion,:)-0.1).^2 +1) + uve_izquiera(iteracion,:)-0.1)
   %DERECHA
     
        R1_drch(iteracion,:)     = sqrt(lambda(1,iteracion)*d1_drch*d2_drch/d_drch);
        
        uve_derecha(iteracion,:) = sqrt(2)*(Despejamiento_derecha./R1_drch(iteracion,:));
      
        Lad_derecha(iteracion,:) = 6.9 + 20*log10(sqrt((uve_derecha(iteracion,:)-0.1).^2 +1) + uve_derecha(iteracion,:)-0.1)
     
        T(iteracion,:) =1-exp(-(max(Ldif_iterado(iteracion,:)))/6);
   
   Ldiff_totales(iteracion,:) = max(Ldif_iterado(iteracion,:)) + T(iteracion,:)*(Lad_derecha(iteracion,:) + Lad_izquierda(iteracion,:) + C)

   
end
plot(f,Ldiff_totales)
ylabel("Pérdidas en dB ");xlabel("Valores de f");

% *-*-*--*-*-*-*-*-*-*-*-*-*-*-*
K      = 4/3;
c      = 3e8;
f      = [300,1300, 2300, 3300, 4300,7475,12650, 17825, 23000].*1e6;
lambda = c./f;
d      = 20.09e3;
R0     = 6370e3;
Re     = R0*K;
h1     = 807;

e  = [797 800 803 799 735 760 788 805];
a  = [10 0 0 0 0 0 0  8];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;

flecha         = d1.*d2/(2*Re);
altura_rayo    = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);
despejamiento  = e + flecha - altura_rayo;
for iteracion=1:numero_iteraciones(2)
    R1_2(iteracion,:) = sqrt(lambda(1,iteracion)*d1.*d2/d); %Altura del primer rayo de Fresnel    
end
despejamiento(:,1)    =[];
despejamiento(:,end)  =[];
d1(:,1)        =[];
d1(:,end)      =[];
R1_2(:,1)        =[];
R1_2(:,end)      =[];
flecha(:,1)    =[];
flecha(:,end)  =[];
e(:,1) = [];
e(:,end) = [];

obstaculo_mayor          = max(e);
posicion_obstaculo_mayor = find(e==obstaculo_mayor);
uve                      = sqrt(2)*despejamiento./R1;
Ldif_iterado             = 6.9 + 20*log10(sqrt((uve-0.1).^2 +1) + uve-0.1);


Ldif_sd                                      = zeros(1,numero_iteraciones(2));
uve_obstaculo_principal_y_subvano            = zeros(numero_iteraciones(2),3);
posicion_uve_menos_negativo_inferior_subvano = zeros(numero_iteraciones(2),3);
altura_rayo(:,1) = [];
altura_rayo(:,end) = [];

despejamiento =  e + flecha - altura_rayo;
for iteracion=1:numero_iteraciones(2)       
    uve_iterado(iteracion,:)   = sqrt(2)*despejamiento./R1_2(iteracion,:);   
end
figure(2);title("Parámetro de difracción en función de la f")
% find(uve_iterado(5,:) < -0.78)
for iteracion=1:numero_iteraciones(2)
    hold on
    plot(uve(iteracion,:));
    xticks(1:7)
    hold off
end

frec = ["300","1300", "2300", "3300", "4300","7475","12650","17825","23000"];
ylabel("Parametro de difracción");xlabel("Obstáculo");
lgd = legend(frec);title(lgd,'Frecuencias en Mhz');


d_izq   = d1(2);
d1_izq  = d1(1);
d2_izq  = d1(2)-d1(1);
h2_izq  = e(2);
h1_izq  = h1;
AlturaRayo_izq   = ((h2_izq-h1_izq)/d_izq)*d1_izq+h1_izq;


Flecha_izquierda        = (d1_izq*d2_izq)/(2*Re);
Despejamiento_izquierda = Flecha_izquierda + e(1) - AlturaRayo_izq;      
        
d_drch  = d2(2);
d1_drch = d1(3)-d1(2);
d2_drch = d2(3);
h2_drch = e(6);
h1_drch = e(2);
AlturaRayo_drch  = ((h2_drch-h1_drch)/d_drch)*d1_drch+h1_drch;

Flecha_derecha        = (d1_drch*d2_drch)/(2*Re);
Despejamiento_derecha = Flecha_derecha + e(1) - AlturaRayo_drch;   

C =10+0.04*(d1(2)/1000+d2(2)/1000);

figure(6);title("Ldiff obstáculos con V > -0.78")
for iteracion=1:numero_iteraciones(2)

   %IZQUIERDA 
        R1_izq(iteracion,:)        = sqrt(lambda(1,iteracion)*d1_izq*d2_izq/d_izq);
  
        uve_izquiera(iteracion,:)  = sqrt(2)*(Despejamiento_izquierda./R1_izq(iteracion,:));
        
        Lad_izquierda(iteracion,:) = 6.9 + 20*log10(sqrt((uve_izquiera(iteracion,:)-0.1).^2 +1) + uve_izquiera(iteracion,:)-0.1)
   %DERECHA
     
        R1_drch(iteracion,:)     = sqrt(lambda(1,iteracion)*d1_drch*d2_drch/d_drch);
        
        uve_derecha(iteracion,:) = sqrt(2)*(Despejamiento_derecha./R1_drch(iteracion,:));
      
        Lad_derecha(iteracion,:) = 6.9 + 20*log10(sqrt((uve_derecha(iteracion,:)-0.1).^2 +1) + uve_derecha(iteracion,:)-0.1)
     
        T(iteracion,:) =1-exp(-(max(Ldif_iterado(iteracion,:)))/6);
   
   Ldiff_totales2(iteracion,:) = max(Ldif_iterado(iteracion,:)) + T(iteracion,:)*(Lad_derecha(iteracion,:) + Lad_izquierda(iteracion,:) + C)

   
end
plot(f,Ldiff_totales2)
ylabel("Pérdidas en dB ");xlabel("Valores de f");
