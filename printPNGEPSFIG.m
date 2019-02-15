function [anAnimation]=printPNGEPSFIG(fhandle,outputDirPlot,filename)
mkdirRobust(fileparts(outputDirPlot));
print(fhandle,[outputDirPlot  filename '.png'],'-dpng');
print(fhandle,[outputDirPlot  filename '.eps'],'-depsc');
print(fhandle,[outputDirPlot  filename '.svg'],'-dsvg');
print(fhandle,[outputDirPlot  filename '.pdf'],'-dpdf');
saveas(fhandle,[outputDirPlot  filename '.fig']);
anAnimation=[];
% anAnimation=ImAnimation([outputDirPlot  filename '.png'],1);


