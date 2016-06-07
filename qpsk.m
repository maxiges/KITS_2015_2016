
clear all;
SNR=-100;
liczbapentli=input('Liczba pentli :');
for zmienna=1:200
    SNR=SNR+1;
    sl_ble=0;
    SER=0;
    licznik=0;
    licznik_1=0;
    liczba_bledow_2=0;
for licz=1:liczbapentli
 
 %1 generacja ramki
%losuje 4 liczby od 0 do 1
x=rand(2,1);
%zaokraglenie liczb
y=sign(round(x)-0.5);


%--MODULACJA 
sig=sqrt(0.45); %sigma czyli pierwiastek mocy szumu
 %stosunek sygna³ szum
szum=sig*randn(1,96);   %szum
A=sig*10^(SNR/20);  %amplituda

Tb=1/2;%czas prubkowania w ms
f=4;
t=[0:95]*Tb/96; %liczba próbek 

smcos=A*cos(2*pi*f*t);
smsin=A*sin(2*pi*f*t);

%figure(1)
%plot(t,smcos,t,smsin)
 
syg_wysl=y(1)*smcos+y(2)*smsin;
%figure(2)
%plot(t,syg_wysl)
%figure(4)
syg_odebra=syg_wysl+szum;
%plot(t,syg_odebra)


sod(1)=sign(syg_odebra*smcos');
sod(2)=sign(syg_odebra*smsin');




 
 L_B=sum(abs(y'-sod));%liczba b³êdów
 
 liczba_bledow_2=sign(sum(abs(y-(sod)')));
 licznik=licznik+L_B;
licznik_1=licznik_1+liczba_bledow_2;
 
end
bledy(1,zmienna)=SNR;
bledy(2,zmienna)=licznik/(liczbapentli*4);
bledy(3,zmienna)=licznik_1/liczbapentli;
end;

figure(1)
plot(bledy(1,:),bledy(2,:))
  xlabel('SNR')
 ylabel('Bitowa stopa b³êdów')
figure(2)
plot(bledy(1,:),bledy(3,:))
 
  xlabel('SNR')
 ylabel('Bitowa stopa b³êdów')

