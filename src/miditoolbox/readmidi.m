function nmat = readmidi(fn)% Conversion of MIDI file to notematrix% nmat = readmidi(fn);%% Input argument:%	FN = name of the MIDI file (string)%% Output:%	NMAT = notematrix%% Change History :% Date		Time	Prog	Note% 11.8.2002	18:36	PT	Created under MATLAB 5.3 (Macintosh)% 2.1.2003	13:12	TE	Created under MATLAB 5.3 (PC)%� Part of the MIDI Toolbox, Copyright � 2004, University of Jyvaskyla, Finland% See License.txtnmat=[];%disp(fn);if strcmp(computer,'MAC2')	currdir = cd;	currdir = char(bitand(double(currdir),255)); % remove high bytes that occasionally occur in the path	toolboxpath = which('readmidi');	toolboxpath=toolboxpath(1:end-11); % remove ':readmidi.m'	cd(toolboxpath);	fid = fopen('mf2t.param','wt');    	ifile = [currdir ':' fn];	fprintf(fid, '%s\n', ifile);	ofile = [toolboxpath ':mf2t.out']; 	fprintf(fid, '%s\n', ofile);	fclose(fid);	! mf2tmac	delete mf2t.param	nmat = mftxt2nmat(ofile);	cd(currdir);elseif strcmp(computer,'PCWIN') || strcmp(computer, 'PCWIN64')	midi2text(fn, 'MF2T.OUT'); % uusin mex konvertteri [2. tammikuuta 2003] 	nmat = mftxt2nmat('MF2T.OUT');	delete mf2t.out	clear mex    elseif strcmp(computer,'GLNX86')	midi2textlinux(fn,'mf2t.out');    nmat = mftxt2nmat('mf2t.out')	delete mf2t.out	clear mexelseif isunix	%midi2textunix(fn,'mf2t.out'); % made for MAC OS X, might work on Unix	%nmat = mftxt2nmat('MF2T.OUT');	%delete mf2t.out    	%%Patch Emir 17/3/2014    nmat = readmidi_java(fn);clear mexelse	disp('This function works only on Macintosh (OS X), Windows and Linux!');	return;end