%1 generacja ramki
%losuje 4 liczby od 0 do 1
clear all;
close all;
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
%----Pentla renderuj¹ca 10 czteero wartoœci losowych liczb
%for i=1:10
%x=round(rand(1,4))
%end;
G=[1 1 0 1 0 0 0 ;0 1 1 0 1 0 0; 1 1 1 0 0  1 0 ; 1 0 1 0 0 0 1];
s=y*G;
s=mod(y*G,2);%s zamienia na wartosci jedynie na 0 i 1
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
%plot(t,sm)
%----dla 2 giej czestotliwoœci
Tb2=1/2;%czas próbkowania w ms
f2=6;
t2=[0:95]*Tb2/96; %liczba próbek 
sm2=A*cos(2*pi*f2*t2);
%plot(t,sm,'r',t2,sm2,'o--') %wykres 2-ch sygna³ów noœnych 

 
%------modulacja BFSK-----
% sbeznot=abs(s(p)-1) %negacja z zera na 1 i z jeden na 0
for p=1:7
sBFSK(p,1:96)=sbez(p)*sm+abs(sbez(p)-1)*sm2;
end
%figure(2)
%plot(t,sBFSK)
%-------------WZMOCNIENIE SYGNA£U----------szym(sigma)=pierwiastek z 0.45[W]--------
%lub szum=sig*randn(7,96);
%figure(3)
%plot(t,sBFSK+szum)
szszum=sBFSK+szum;
sod1=szszum*sm';
sod2=szszum*sm2';
syg_odeb_bit=((sign(sod1-sod2)+1)/2)';

H=[1 0 0 1 0 1 1; 0 1 0 1 1 1 0; 0 0 1 0 1 1 1];
Htrans=H'; %h transponowane
sygH=mod(syg_odeb_bit*H',2); %syndrom 
%korygowanie b³edu
 ramka_nadana=sbez;
 ramka_odebrana=syg_odeb_bit;
 %-----------------liczenie -----------------

 if (s==syg_odeb_bit)
liczba_poprawnych=liczba_poprawnych+1;
 else
 liczba_niepopeawnych=liczba_niepopeawnych+1;
 end
 
 
 %--------------------------------------------------
 
for k=1:7
  if sygH==Htrans(k,1:3)
    syg_odeb_bit(k)=abs(syg_odeb_bit(k)-1); %korugowanie 1 bitu
  end
end

 if (sygH~=[0 0 0])
    if (s==syg_odeb_bit)
licznik_skorygowany=licznik_skorygowany+1;
    else
       licznik_nieskorygowany=licznik_nieskorygowany+1;  
    end
 else
      if (s==syg_odeb_bit)
          
    else
       licznik_nieskorygowany=licznik_nieskorygowany+1;  
      end
 end



 L_B=sum(abs(y-syg_odeb_bit(4:7)));  %liczba b³êdów
 sl_ble=sl_ble+L_B;
 blendy(zmiena)=sl_ble;
 
%------------------------------------------------------ 
liczba_poprawnych0(zmiena)=liczba_poprawnych;
licznik_skorygowany0(zmiena)=licznik_skorygowany;
licznik_nieskorygowany0(zmiena)=licznik_nieskorygowany;
liczba_niepopeawnych0(zmiena)=liczba_niepopeawnych;
%-------------------------------------------------------
end
 
 
end
 figure (11)
 plot(1:200,blendy)
 figure(12)
 plot((1:200)-100,blendy/(4*liczbapentli))
  xlabel('SNR')
 ylabel('Bitowa stopa b³êdów')
 
  figure (13)
 plot((1:200)-100,liczba_poprawnych0/liczbapentli)
  figure (14)
 plot((1:200)-100,licznik_skorygowany0/liczbapentli)
  figure (15)
 plot((1:200)-100,licznik_nieskorygowany0/liczbapentli)
  figure (16)
 plot((1:200)-100,liczba_niepopeawnych0/liczbapentli)
 figure(17)
 plot(1:200,liczba_poprawnych0,1:200,licznik_skorygowany0,1:200,licznik_nieskorygowany0,1:200,liczba_niepopeawnych0)
  figure(18)
  hold on
  
 plot((1:200)-100,liczba_niepopeawnych0/liczbapentli,'r')
 plot((1:200)-100,licznik_nieskorygowany0/liczbapentli,'g')
 plot((1:200)-100,licznik_skorygowany0/liczbapentli,'b')
 plot((1:200)-100,liczba_poprawnych0/liczbapentli,'y')
  xlabel('SNR')
 ylabel('Stopa b³êdów 1=100%')
 
%-poprawnoœæ kodu hamminga
%ramka przes³ana bezb³êdnie (kod hamminga)
%if (ramka_nadana==ramka_odebrana)
%liczba_poprawnych=licznik_poprawnych+1;

%2.ramka skorygowana
%warunek ten sam po odebraniu syndromu i korelacji
%3.b³¹d nie skorygowany
%4. 
%if (ramka_nadana~=ramka_odebrana)
%
%Po korekcji
%if(ramka_nadana==ramka_odebrana)
%licznik_skorygowany=licznik+_skorygowany+1
%else
%licznik_nieskorygowany=licznik_nieskorygowanych+1
%end;
%


