clear;clc;close all;
K      = 4/3;
c      = 3e8;
f      = [300,1300, 2300, 3300, 4300,7475,12650, 17825, 23000].*1e6;
lambda = c./f;
d      = 20.09e3;
R0     = 6370e3;
Re     = R0*K;
h1     = 807;
h2     = 813;
e  = [797 800 815 799 735 760 788 805];
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
e(:,1) = [];
e(:,end) = [];

d2=d-d1;

uve           = sqrt(2)*despejamiento./R1;
Ldif_iterado  = 6.9 + 20*log10(sqrt((uve-0.1).^2 +1) + uve-0.1);

altura_rayo(:,1) = [];
altura_rayo(:,end) = [];

flecha        = (d1.*d2)/(2*Re);
despejamiento =  e + flecha - altura_rayo;
for iteracion=1:numero_iteraciones(2)       
    uve_iterado(iteracion,:)   = sqrt(2)*despejamiento./R1(iteracion,:);   
end

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
h2_drch = h2;
h1_drch = e(2);
AlturaRayo_drch  = ((h2_drch-h1_drch)/d_drch)*d1_drch+h1_drch;

Flecha_derecha        = (d1_drch*d2_drch)/(2*Re);
Despejamiento_derecha = Flecha_derecha + e(3) - AlturaRayo_drch;   

C =10+0.04*(d1(2)/1000+d2(2)/1000);

figure(1);title("Ldiff totales")
for iteracion=1:numero_iteraciones(2)

   %IZQUIERDA 
        R1_izq(iteracion,:)        = sqrt(lambda(1,iteracion)*d1_izq*d2_izq/d_izq);  
       
        uve_izquiera(iteracion,:)  = sqrt(2)*(Despejamiento_izquierda/R1_izq(iteracion,:));
        
        if(uve_izquiera(iteracion,:)<-0.78)
          Lad_izquierda(iteracion,:) =0;
        else         
          Lad_izquierda(iteracion,:) = 6.9 + 20*log10(sqrt((uve_izquiera(iteracion,:)-0.1).^2 +1) + uve_izquiera(iteracion,:)-0.1)
        end
      
   %DERECHA
     
        R1_drch(iteracion,:)     = sqrt(lambda(1,iteracion)*d1_drch*d2_drch/d_drch);
        
        uve_derecha(iteracion,:) = sqrt(2)*(Despejamiento_derecha/R1_drch(iteracion,:));
        
        if(uve_derecha(iteracion,:)<-0.78)
          Lad_derecha(iteracion,:) =0;
        else
          Lad_derecha(iteracion,:)  = 6.9 + 20*log10(sqrt((uve_derecha(iteracion,:)-0.1).^2 +1) + uve_derecha(iteracion,:)-0.1)
        end
        
        T(iteracion,:) =1-exp(-(max(Ldif_iterado(iteracion,:)))/6);
   
   Ldiff_totales(iteracion,:) = max(Ldif_iterado(iteracion,2)) + T(iteracion,:)*(Lad_derecha(iteracion,:) + Lad_izquierda(iteracion,:) + C)

   
end
plot(f,Ldiff_totales);title("Ldiff totales [dB]");
ylabel("Pérdidas [dB] ");xlabel("Valores de f");


Peridas = [Lad_izquierda(:,1) Ldiff_totales(:,1) Lad_derecha(:,1)]