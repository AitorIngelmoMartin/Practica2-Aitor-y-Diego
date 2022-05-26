% Se pretende cumplir el objetivo de indisponibilidad de tramo nacional de corto alcance
% en un radioenlace compuesto por un vano de 35km, dos vanos de 43km y tres 
% vanos de 24km. Teniendo en cuenta que sólo hay tres secciones de conmutación
% y que la indisponibilidad de cada equipo es MTTR*100/MTBF = 0,001%, determinar los objetivos
% % de lluvia en cada vano asumiendo un reparto proporcional a la distancia de cada uno.

clc;clear;

d = [35e3 43e3 24e3];
dtotal = (35+2*43+3*24)*1e3;
Uequipos = 0.001;
Uequipos_total = (1+2+2+1+1+1+1)*Uequipos;
U = 0.04;
qtotal = U - Uequipos_total;
q = qtotal*d/dtotal;