%1 generacja ramki
%losuje 4 liczby od 0 do 1

%----------------MODULACJA BPSK-------------
clear all;
close all;
sl_ble=0;
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
G=[1 1 0 1 0 0 0 ;0 1 1 0 1 0 0; 1 1 1 0 0  1 0 ; 1 0 1 0 0 0 1]; %kod hanninga
s=y*G;
s=mod(y*G,2);%s zamienia na wartosci jedynie na 0 i 1
sbez=s;
%NRTZ-kod bez powrotu do zera
sNZ=s*2-1;
s=sNZ;
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
%
%-----modylacja BPSK----


for p=1:7
    sBPSK1(p,1:96)=sNZ(p)*sm; %macierz 7x96 mno¿enie macierzy sygna³ zmodulowany
    sBPSK2((p-1)*96+1:p*96)=sNZ(p)*sm;           %   smx((p-1)*N+1:p*N)=s(p)*p      macierz zmodulowana[1,7xN]
end
 
%figure (2)   %dobre ale mnie denerwuje
%plot(t,sBPSK1)
%figure(3);     %dobre ale mnie denerwuje
%plot(sBPSK2); %sposób nr2
%lub szum=sig*randn(7,96);
%figure(3)
%plot(t,sBPSK1+szum)

%----------------------odbiornik----------------
%figure(4)
szszum=sBPSK1+szum; %sygna³ z szumem
sodebr=szszum*sm';  %sygna³ odebrany pomno¿ony przez noœn¹ sm'
sygnapo=(sign(sodebr))' ;  %to co jest - to ma wynik -1 a to co + to 1
syg01=(sygnapo+1)/2; %zamiana z kodu NRZ na RZ
H=[1 0 0 1 0 1 1; 0 1 0 1 1 1 0; 0 0 1 0 1 1 1];
Htrans=H'; %h transponowane
sygH=mod(syg01*H',2); %syndrom 
%-----------------liczenie -----------------

 if (sbez==syg01)
liczba_poprawnych=liczba_poprawnych+1;
 else
 liczba_niepopeawnych=liczba_niepopeawnych+1;
 end

 
 
%korygowanie b³edu
for k=1:7
  if sygH==Htrans(k,1:3)
    syg01(k)=abs(syg01(k)-1);
  end
end
 

if (sygH~=[0 0 0])
    if (sbez==syg01)
licznik_skorygowany=licznik_skorygowany+1;
    else
       licznik_nieskorygowany=licznik_nieskorygowany+1;  
    end
 else
      if (sbez==syg01)
          
    else
       licznik_nieskorygowany=licznik_nieskorygowany+1;  
      end
 end
     
 
 L_B=sum(abs(y-syg01(4:7)));  %liczba b³êdów
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
 figure (1)
 plot(1:200,blendy)
 figure(2)
 plot((1:200)-100,blendy/(4*liczbapentli));
 xlabel('SNR')
 ylabel('Bitowa stopa b³êdów')
 
 figure(3)
 hold on
 plot((1:200)-100,liczba_niepopeawnych0/liczbapentli,'r')
 plot((1:200)-100,licznik_nieskorygowany0/liczbapentli,'g')
 plot((1:200)-100,licznik_skorygowany0/liczbapentli,'b')
 plot((1:200)-100,liczba_poprawnych0/liczbapentli,'y')
 
 xlabel('SNR')
 ylabel('Waroœæ wyskalowana 1=100%')
