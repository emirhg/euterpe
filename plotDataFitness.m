function [fitnessFig, fitnessHistFig] = plotDataFitness(data)

fitness = fitnessData(data);

fitnessFig = figure();

title('Reconocimiento de las muestras en la base de conocimiento');
xlabel('Muestra');
ylabel('Certidumbre del estilo real');

stem(fitness)

fitnessHistFig = figure();

hist(fitness);

title('Distribucion de la certidumbre en el reconocimiento');
xlabel('Certidumbre del estilo real');
ylabel('Cantidad de muestras');

end


