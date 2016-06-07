%1 generacja ramki
%losuje 4 liczby od 0 do 1
clear all;
SNR=-100;
liczbapentli=input('Liczba pentli :');

for zmiena=1:200
SNR=SNR+1;
sl_ble=0;
liczba_poprawnych=0;
licznik_skorygowany=0;
licznik_nieskorygowany=0;
liczba_niepopeawnych=0;
for licz=1:liczbapentli
    
x=rand(1,4);
%zaokraglenie liczb
y=round(x);
%----Pentla renderuj�ca 10 czteero warto�ci losowych liczb
%for i=1:10
%x=round(rand(1,4))
%end;

s=mod(y,2);%s zamienia na wartosci jedynie na 0 i 1
sbez=s;

%--MODULACJA 
sig=sqrt(0.45); %sigma czyli pierwiastek mocy szumu
 %stosunek sygna� szum
szum=sig*randn(4,96);   %szum
A=sig*sqrt(2)*10^(SNR/20);  %amplituda

Tb=1/2;%czas prubkowania w ms
f=4;
t=[0:95]*Tb/96; %liczba pr�bek 
sm=A*cos(2*pi*f*t);
%plot(t,sm)
%----dla 2 giej czestotliwo�ci
Tb2=1/2;%czas pr�bkowania w ms
f2=6;
t2=[0:95]*Tb2/96; %liczba pr�bek 
sm2=A*cos(2*pi*f2*t2);
%plot(t,sm,'r',t2,sm2,'o--') %wykres 2-ch sygna��w no�nych 

 
%------modulacja BFSK-----
% sbeznot=abs(s(p)-1) %negacja z zera na 1 i z jeden na 0
for p=1:4
sBFSK(p,1:96)=sbez(p)*sm+abs(sbez(p)-1)*sm2;
end
%figure(2)
%plot(t,sBFSK)
%-------------WZMOCNIENIE SYGNA�U----------szym(sigma)=pierwiastek z 0.45[W]--------
%lub szum=sig*randn(7,96);
%figure(3)
%plot(t,sBFSK+szum)
szszum=sBFSK+szum;
sod1=szszum*sm';
sod2=szszum*sm2';
syg_odeb_bit=((sign(sod1-sod2)+1)/2)';

 %h transponowane
sygH=mod(syg_odeb_bit,2); %syndrom 
%korygowanie b�edu
 ramka_nadana=sbez;
 ramka_odebrana=syg_odeb_bit;
 %-----------------liczenie -----------------

 
 %--------------------------------------------------
 

 L_B=sum(abs(y-syg_odeb_bit));  %liczba b��d�w
 sl_ble=sl_ble+L_B;
 blendy(zmiena)=sl_ble;
 

%-------------------------------------------------------
end
 
 
end
 figure (11)
 plot((1:200)-100,blendy)
 figure(12)
 plot((1:200)-100,blendy/(4*liczbapentli))
  xlabel('SNR')
 ylabel('Bitowa stopa b��d�w')
