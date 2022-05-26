Flujo = e^2/120*pi = PIRE/(4*pi*d^2)*1/Lad; %Vector de poynting
Seff = lambda^2*g/4*pi;
Prx = Flujo*Seff;
Prad = Flujo*4*pi*R^2;
e = flujo/(120*pi);

flujo = pire/(4*pi*R^2*lad);

Prx > Umbral para que se de el servicio.


Prx_CMD = Lb + Fq; %En condiciones maximas de desvanecimiento.
%Llueve el q% del año. Protegido F = 10dB.
%q = indisponibilidad
%Fq desvanecimiento. atenuacion excedida en q% del tiempo.

%Campo parásito: Antes de pasar por la antena:
E_PV = PIRE/(4*pi*d^2*Lad*Fq);
E_parasita_PH_PV = E_PV_PH - XPD_lluvia;


        EespacioLibre = sqrt(10^(Flujo_dBW/10)*120*pi);
        
        EespacioLibre_dBu = 20*log10(EespacioLibre/1e-6);
        
        E_CMD_dBu = EespacioLibre_dBu - MD_CAG_dB;
        
        Eparasito_total_dBu = E_CMD_dBu - XPD_ll;




Prx_PV = E_PV^2*lambda^2*G/(120*pi*4*pi);
Prx_parasita_PH = E_parasita_PH_PV^2*lambda^2*G/(120*pi*4*pi*XPD_antena);

Potencia de ruido: Pn = 10*log10(K*T*bn)


Thx_dBW = CNR_dB + 10*log10(Boltzman*T_antes_dispositivo*Bn)+degradacion
Bn = Rb_tx/log2(M); %(1+roll-off)*Rb/log2M;

Eb_N0_mintot = U/(KTRb)
U = eb_no_mintot*K*T*Rb;
Eb_N0_mintotal = Eb_No_min + Ux %deltafiltro

Umbral_real = umbral_ideal + Ux;


