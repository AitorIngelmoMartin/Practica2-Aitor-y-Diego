clear,clc
% 
Difracc_O1 = 0.131728301669471;
Difracc_O2 = 0.0508827993268303;
% [-0.0721037777593453,-0.219077450469380];
% [-0.275935857188161,-0.489037700265591];
% [-0.377851896902578,-0.624017825163703]

if( ( (Difracc_O1<0) ||(Difracc_O2<0) ) && (abs(Difracc_O1 -Difracc_O2)<0.5) )
        "Método uno"
        
end

if( ( (Difracc_O1>0) && (Difracc_O2>0) ) && (abs(Difracc_O1 -Difracc_O2)>0.5) )
        "Método dos"
end