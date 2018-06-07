function plottingfunction(propertime, range, matrix, totype)

figure(1)
surface(propertime, range ,matrix)
ylabel('Altitude (km)')
title(totype)
ylim([min(range) max(range)]);
xlim([min(propertime) max(propertime)]);
colormap 
shading flat
colorbar
end





