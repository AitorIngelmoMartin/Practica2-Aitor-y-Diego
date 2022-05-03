clc;clear;

% I1 = [1 2 3 4 5 6 7 8 9 10 11];
% I2 = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22]
% V1 = [2.84 3 3.12 3.24 3.35 3.47 3.57 3.67 3.76 3.86 3.97]
% V2 = [1.88 	2 	2.08 	2.17	2.26 	2.35 	2.42 	2.48 	2.61 	2.67 	2.75 
% 2.82 	2.9 	2.99 	3.08 	3.16 	3.24 	3.29 	3.39 	3.44 	3.54 	3.62 ]
% 
% figure(1)
% plot(V1,I2)
% 
% plot(V2,I2)
% xlabel('Tensión (V)')
% ylabel('Intensidad de corriente (mA)')
% grid on;
% title('Comparación de corriente/tension de FOTOEMISOR Nº1 y Nº5')
% 
% figure(2)
% d = [0 	0.5 	1.0 	1.5 	2.0 	2.5 	3.0 	3.5 ]
% at = [0 0.34  1  1.35  2.5 3.1 4.4 5.2]
% 
% plot(d,at),title('Desalineamiento longitudinal')
% xlabel('Distancia (mm)')
% ylabel('Atenuación (dB)')

angulo = [0 2 4 6 8 10 12 14 16 18 20 25 30 35 40 ]
at = [0 0.01 0.02 0.04 0.1 0.22 0.3 0.36 0.39 0.4 0.47 0.53 0.54 1 1.04]
plot(angulo,at),title('Desalineamiento angular');
xlabel('Ángulo (º)')
ylabel('Atenuación (dB)')