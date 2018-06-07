function plottingfunction(propertime, range, matrix)

figure(1)
surface(propertime, range ,matrix)
ylabel('Altitude (km)')
ylim([min(range) max(range)]);
xlim([min(propertime) max(propertime)]);
colormap 
shading flat
colorbar
end





