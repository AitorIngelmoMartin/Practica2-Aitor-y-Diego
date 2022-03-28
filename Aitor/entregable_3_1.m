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
uve                      = sqrt(2)*despejamiento./R1;
Ldif_iterado             = 6.9 + 20*log10(sqrt((uve-0.1).^2 +1) + uve-0.1);

altura_rayo(:,1) = [];
altura_rayo(:,end) = [];

flecha        = (d1.*d2)/(2*Re);
despejamiento =  e + flecha - altura_rayo;

for iteracion=1:numero_iteraciones(2)       
    uve_iterado(iteracion,:)   = sqrt(2)*despejamiento./R1(iteracion,:);   
end

figure(1);title("Parámetro de difracción en función de la f")
for iteracion=1:numero_iteraciones(2)
    hold on
    plot(uve(iteracion,:));
    xticks(1:7)
    hold off
end

frec = ["300","1300", "2300", "3300", "4300","7475","12650","17825","23000"];
ylabel("Parametro de difracción");xlabel("Obstáculo");
lgd = legend(frec);title(lgd,'Frecuencias en Mhz');
