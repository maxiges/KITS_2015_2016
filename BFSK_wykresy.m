%1 generacja ramki
%losuje 4 liczby od 0 do 1
clear all;
SNR=15;

    
x=rand(1,4);
%zaokraglenie liczb
y=round(x);
%----Pentla renderuj¹ca 10 czteero wartoœci losowych liczb
%for i=1:10
%x=round(rand(1,4))
%end;
G=[1 1 0 1 0 0 0 ;0 1 1 0 1 0 0; 1 1 1 0 0  1 0 ; 1 0 1 0 0 0 1];
s=y*G;
s=mod(y*G,2)%s zamienia na wartosci jedynie na 0 i 1
sbez=s;

%--MODULACJA 
sig=sqrt(0.45); %sigma czyli pierwiastek mocy szumu
 %stosunek sygna³ szum
szum=sig*randn(7,96);   %szum
A=sig*sqrt(2)*10^(SNR/20);  %amplituda

Tb=1/2;%czas prubkowania w ms
f=4;
t=[0:95]*Tb/96; %liczba próbek 
sm=A*cos(2*pi*f*t);
plot(t,sm)
title('Sygna³ moduluj¹cy');
%----dla 2 giej czestotliwoœci
Tb2=1/2;%czas próbkowania w ms
f2=6;
t2=[0:95]*Tb2/96; %liczba próbek 
sm2=A*cos(2*pi*f2*t2);
plot(t,sm,'r',t2,sm2,'o--') %wykres 2-ch sygna³ów noœnych 
title('wykres 2-ch sygna³ów noœnych');
 
%------modulacja BFSK-----
% sbeznot=abs(s(p)-1) %negacja z zera na 1 i z jeden na 0
for p=1:7
sBFSK(p,1:96)=sbez(p)*sm+abs(sbez(p)-1)*sm2;
end
figure(2)
plot(t,sBFSK)
title('Wygl¹d sygna³y zmodulowanego');
%-------------WZMOCNIENIE SYGNA£U----------szym(sigma)=pierwiastek z 0.45[W]--------
%lub szum=sig*randn(7,96);
figure(3)
plot(t,sBFSK+szum)
title('Wygl¹d sygna³y odulowanego z szumem');
szszum=sBFSK+szum;
sod1=szszum*sm';
sod2=szszum*sm2';
syg_odeb_bit=((sign(sod1-sod2)+1)/2)';

H=[1 0 0 1 0 1 1; 0 1 0 1 1 1 0; 0 0 1 0 1 1 1];
Htrans=H'; %h transponowane
sygH=mod(syg_odeb_bit*H',2); %syndrom 
%korygowanie b³edu
figure(4)
plot(syg_odeb_bit)

for k=1:7
  if sygH==Htrans(k,1:3)
    syg_odeb_bit(k)=abs(syg_odeb_bit(k)-1);
  end
end

 
 L_B=sum(abs(y-syg_odeb_bit(4:7)));  %liczba b³êdów

 
 

%
%Bitowa stopa b³edu snr
%3 wykresy dotycz¹ce kodu hamminga na 1 wykresie
 

 
 
 
 


