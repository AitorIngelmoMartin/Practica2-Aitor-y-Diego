clear;close all;clc;

f      = 5800e6;
c      = 3e8;
lambda = c/f;

% Alturas, distancia y radio en metros

d  = 20.09e3; %en Km
R0 = 6370e3;

e  = [797 800 803 799 735 760 788 805];
a  = [10  0   0    0   0   0   0  8];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;
h1 = e(1) + a(1);


K           = [0.5, 2/3 ,1, 4/3];
Re          = R0*K;
altura_rayo = ((e(end)+a(end)-e(1)-a(1))/d)*d1 + e(1)+a(1);
R1          = sqrt(lambda*d1.*d2/d); 

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
% % -----------------------------------------------------------------------
d2=d-d1;

obstaculo_mayor          = max(e);
posicion_obstaculo_mayor = find(e==obstaculo_mayor);

numero_iteraciones    = size(Re);
columnas              = size(d1);
flecha_iterada        = zeros(numero_iteraciones(2),columnas(2));
despejamiento_iterado = zeros(numero_iteraciones(2),columnas(2));
uve_iterado           = zeros(numero_iteraciones(2),columnas(2));
Ldif_iterado          = zeros(numero_iteraciones(2),columnas(2));
Ldif_sd               = zeros(1,numero_iteraciones(2));
uve_obstaculo_principal_y_subvano            = zeros(numero_iteraciones(2),3);
posicion_uve_menos_negativo_inferior_subvano = zeros(numero_iteraciones(2),3);
%uve_iterado_relevante  = zeros(numero_iteraciones(2),6);
figure(1);title("Coeficiente de difracción por obstáculo");
for iteracion=1:numero_iteraciones(2)    
    flecha_iterada(iteracion,:)        = (d1.*d2)/(2*Re(iteracion));
    despejamiento_iterado(iteracion,:) =  e + flecha_iterada(iteracion,:) - altura_rayo;
    uve_iterado(iteracion,:)           = sqrt(2)*despejamiento_iterado(iteracion,:)./R1;

% find(uve_iterado(1,:) <-0.78)
%ans =    1     4     5     6
    
% uve_iterado(1,ans)
% ans =%  -1.3147   -5.4915   -3.2292   -1.4008

    uve_iterado_relevante(iteracion,:) = uve_iterado(iteracion,find(uve_iterado(iteracion,:) > -0.78));  
 
    Ldif_iterado(iteracion,:)          =  6.9 + 20*log10(sqrt((uve_iterado(iteracion,:)-0.1).^2 +1) + uve_iterado(iteracion,:)-0.1);
    
    uve_obstaculo_principal_y_subvano(iteracion,:)  = [uve_iterado(iteracion,posicion_obstaculo_mayor-1),uve_iterado(iteracion,posicion_obstaculo_mayor),uve_iterado(iteracion,posicion_obstaculo_mayor+1)];
    posicion_uve_menos_negativo_inferior_subvano    = find( (uve_iterado(iteracion,:))<(min(uve_obstaculo_principal_y_subvano(iteracion,:))), 1, 'last' );

    hold on
    plot(uve_iterado(iteracion,:))
    xticks(1:6);
    hold off
    
end
ylabel("Valor coeficiente");xlabel("Obstáculo");
legend("Difracción K = 1/2","Difracción K = 2/3","Difracción K = 1","Difracción K = 4/3");


figure(2);title("Ldiff de cada obstáculo por separado");
for iteracion=1:numero_iteraciones(2)
    hold on 
    plot(Ldif_iterado(iteracion,:));
    xticks(1:6);
    hold off
end
ylabel("Pérdidas en dB ");xlabel("Obstáculo");
legend("Difracción K = 1/2","Difracción K = 2/3","Difracción K = 1","Difracción K = 4/3");


d_izq   = d1(2);
d1_izq  = d1(1);
d2_izq  = d1(2)-d1(1);
h2_izq  = e(2);
h1_izq  = h1;
AlturaRayo_izq   = ((h2_izq-h1_izq)/d_izq)*d1_izq+h1_izq;
R1_izq           = sqrt(lambda*d1_izq*d2_izq/d_izq);

d_drch  = d2(2);
d1_drch = d1(3)-d1(2);
d2_drch = d2(3);
h2_drch = e(6);
h1_drch = e(2);
AlturaRayo_drch  = ((h2_drch-h1_drch)/d_drch)*d1_drch+h1_drch;
R1_drch          = sqrt(lambda*d1_drch*d2_drch/d_drch);

C =10+0.04*(d1(2)/1000+d2(2)/1000);

figure(5);title("Ldiff obstáculos con V > -0.78")
for iteracion=1:numero_iteraciones(2)

   %IZQUIERDA 
        Flecha_izquierda(iteracion,1)        = (d1_izq*d2_izq)/(2*Re(iteracion));
        Despejamiento_izquierda(iteracion,1) = Flecha_izquierda(iteracion,1) + e(1) - AlturaRayo_izq;        
        uve_izquiera(iteracion,1)            = sqrt(2)*(Despejamiento_izquierda(iteracion,1)/R1_izq);
        
        Lad_izquierda(iteracion,:) = 6.9 + 20*log10(sqrt((uve_izquiera(iteracion,:)-0.1).^2 +1) + uve_izquiera(iteracion,:)-0.1);
   %DERECHA
        Flecha_derecha(iteracion,:)        = (d1_drch*d2_drch)/(2*Re(iteracion));
        Despejamiento_derecha(iteracion,:) = Flecha_derecha(iteracion,1) + e(1) - AlturaRayo_drch;        
        uve_derecha(iteracion,:)            = sqrt(2)*(Despejamiento_derecha(iteracion,1)/R1_drch);
      
        Lad_derecha(iteracion,:) = 6.9 + 20*log10(sqrt((uve_derecha(iteracion,:)-0.1).^2 +1) + uve_derecha(iteracion,:)-0.1);
     
   T(iteracion,:) =1-exp(-(max(Ldif_iterado(iteracion,:)))/6);
   
   Ldiff_totales(iteracion,:) = max(Ldif_iterado(iteracion,:)) + T(iteracion,:)*(Lad_derecha(iteracion,:) + Lad_izquierda(iteracion,:) + C)

   
end
plot(K,Ldiff_totales)
ylabel("Pérdidas en dB ");xlabel("Valores de K");


figure(4);title("Ldiff totales en funcion de K");
plot(K,Ldif_iterado(:,posicion_obstaculo_mayor));
ylabel("Pérdidas en dB ");xlabel("Obstáculo");
legend("Difracción K = 1/2","Difracción K = 2/3","Difracción K = 1","Difracción K = 4/3");

