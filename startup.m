%% Inicialización
addpath(genpath('src'));
addpath(genpath('experimentos'));
javaclasspath('/home/shanti/Desarrollo/src/midi_lib/KaraokeMidiJava.jar');

%% Continua procesando la última sesión
load 28-May-2012;
lastsave= tic;
for i=1:length(Knowledge)
	Knowledge(i) = processdata(Knowledge(i),20);
    Knowledge(i).label = findLabel(data(i).name);

	if toc(lastsave) > 4*60*60
		save(date);
		lastsave=tic;
	end
end
