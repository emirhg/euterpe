function [Y,FS,NBITS,encoding_info,tag_info,out] = mp3read(FILE)
%MP3READ Read MP3 (".mp3") sound file.
%    Y = MP3READ(FILE) reads a MP3 file specified by the string FILE,
%    returning the sampled data in Y. Amplitude values are in the range [-1,+1].
% 
%    [Y,FS,NBITS,encoding_info,ID3v1_tag_info] = MP3READ(FILE) returns the sample rate (FS) in Hertz
%    and the number of bits per sample (NBITS) used to encode the
%    data in the file.
%
%    'encoding_info' is a string containing information about the mp3
%    encoding used
%
%    'ID3v1_tag_info' is a string containing the tag information of the file
%    (only ID3v1 tag supported in this version)
%
% 
%    Supports two channel or mono encoded data, with up to 16 bits per sample.
% 
%    See also MP3WRITE, WAVWRITE, AUREAD, AUWRITE.
a = length(FILE);
if a >= 4
    exten = FILE(a-3:a);
    if exten ~= '.mp3'
        FILE = strcat(FILE,'.mp3');
    end
end
if a <= 3
    FILE = strcat(FILE,'.mp3');
end
if exist(FILE) ~= 2
    error('File not Found')
end
%%%%Temporary file%%%%%%
tmpfile = ['temp.wav'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Data Decoding  using "mpg123.exe"%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[stat,raw_info] = dos(['mpg123', ' -w ', tmpfile, ' ', '"',FILE,'"']);
data_init = findstr(raw_info,'MPEG');
blocks = findstr(raw_info,'[0:');
if raw_info(blocks+3) == '0'
    error('Error while decoding file. File may be corrupted')
end



fid=fopen(tmpfile,'r');
fseek(fid,24,'bof'); % Saut de 24 octets depuis le début du fichier
FS=fread(fid,1,'*uint32') * 2;

fseek(fid,34,'bof'); % Saut de 24 octets depuis le début du fichier
NBITS=fread(fid,1,'*uint16');

fseek(fid,40,'bof'); % Saut de 24 octets depuis le début du fichier
count=fread(fid,1,'*uint32');

fseek(fid, 44, 'bof');
Y = fread(fid, (count-44), ['bit' int2str(NBITS)]);
Y = Y/ max(Y);
fclose(fid);


%[Y,FS,NBITS] = wavread(tmpfile);    % Load the data and delete temporary file
%delete(tmpfile);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tag_info_start = strfind(raw_info,'Title');
tag_info_end = (strfind(raw_info,'Playing MPEG'))-1;
tag_info = raw_info(tag_info_start:tag_info_end);
encoding_info = raw_info(data_init(3):data_init(3)+53);