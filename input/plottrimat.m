
lon=ncread('ww3.194801.nc','longitude');
lat=ncread('ww3.194801.nc','latitude');
hs=ncread('ww3.194801.nc','hs');

h=size(hs);

for i= 1:h(3)
   hfig=figure('Color','w')
   axesm('eqaazim','MapLatLimit',[60 90])
   axis off
   framem on
   gridm on
   mlabel on
   plabel on;
   setm(gca,'MLabelParallel',0)
   pcolorm(double(lat),double(lon),hs(:,:,i)')
   filenamesave = sprintf('CDU10waveageS_%sB%03dT%03d%03d.png',fld,iB,T1,T2);
   saveas(hfig,filenamesave);
   close all 
end




