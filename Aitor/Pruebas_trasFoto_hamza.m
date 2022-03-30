clear;close all;clc;

f      = 2.3e9;
c      = 3e8;
lambda = c/f;

% Alturas, distancia y radio en metros

d  = 20.09e3; %en Km
R0 = 6370e3;

e  = [796 800 803 799 735 760 788 805];
a  = [10 0 0 0 0 0 0 8];
d1 = [0 0.806e3 1.910e3 3.721e3 7.831e3 10.955e3 14.965e3 d];
d2 = d - d1;


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
% -----------------------------------------------------------------------
d2=d-d1;

numero_iteraciones    = size(Re);
columnas              = size(d1);
flecha_iterada        = zeros(numero_iteraciones(2),columnas(2));
despejamiento_iterado = zeros(numero_iteraciones(2),columnas(2));
uve_iterado           = zeros(numero_iteraciones(2),columnas(2));
Ldif_iterado          = zeros(numero_iteraciones(2),columnas(2));



d_izq   = d1(2);
d1_izq  = d1(1);
d2_izq  = d1(2)-d1(1);
h2_izq  = e(2);
h1_izq  = 796+10;
AlturaRayo_izq   = ((h2_izq-h1_izq)/d_izq)*d1_izq+h1_izq;

Flecha_izquierda        = (d1_izq*d2_izq)/(2*Re(4));
Despejamiento_izquierda = Flecha_izquierda + h1_izq - AlturaRayo_izq;      
        
d_drch  = d2(2);
d1_drch = d1(3)-d1(2);
d2_drch = d2(3);
h2_drch = 805+8;
h1_drch = e(2);
AlturaRayo_drch  = ((h2_drch-h1_drch)/d_drch)*d1_drch+h1_drch;

Flecha_derecha        = (d1_drch*d2_drch)/(2*Re(4));
Despejamiento_derecha = Flecha_derecha + e(1) - AlturaRayo_drch;   


for iteracion=1:numero_iteraciones(2)

   %IZQUIERDA 
        R1_izq        = sqrt(lambda*d1_izq*d2_izq/d_izq);
  
        uve_izquiera  = sqrt(2)*(Despejamiento_izquierda/R1_izq);
        %DERECHA
     
        uve_derecha(iteracion,:)  = sqrt(2)*(Despejamiento_derecha/R1(3));
   
end