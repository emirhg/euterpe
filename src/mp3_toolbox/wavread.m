%% -*- texinfo -*-
%% @deftypefn {Function File} {@var{y} =} wavread (@var{filename})
%% Load the RIFF/WAVE sound file @var{filename}, and return the samples
%% in vector @var{y}.  If the file contains multichannel data, then
%% @var{y} is a matrix with the channels represented as columns.
%%
%% @deftypefnx {Function File} {[@var{y}, @var{Fs}, @var{bits}] =} wavread (@var{filename})
%% Additionally return the sample rate (@var{fs}) in Hz and the number of bits
%% per sample (@var{bits}).
%%
%% @deftypefnx {Function File} {[@dots{}] =} wavread (@var{filename}, @var{n})
%% Read only the first @var{n} samples from each channel.
%%
%% @deftypefnx {Function File} {[@dots{}] =} wavread (@var{filename},[@var{n1} @var{n2}])
%% Read only samples @var{n1} through @var{n2} from each channel.
%%
%% @deftypefnx {Function File} {[@var{samples}, @var{channels}] =} wavread (@var{filename}, 'size')
%% Return the number of samples (@var{n}) and channels (@var{ch})
%% instead of the audio data.
%% @seealso{wavwrite}
%% @end deftypefn

%% Author: Michael Zeising <michael@michaels-website.de>
%% Created: 06 December 2005

function [y, samples_per_sec, bits_per_sample] = wavread (filename, param)

  FORMAT_PCM        = hex2dec('0001');   % PCM (8/16/32 bit)
  FORMAT_IEEE_FLOAT = hex2dec('0003');   % IEEE float (32/64 bit)
  BYTEORDER         = 'ieee-le';

  if (nargin < 1 || nargin > 2)
    print_usage ();
  end

  if (~ischar (filename))
    error ('wavwrite: expecting filename to be a character string');
  end

  % Open file for binary reading.
  [fid, msg] = fopen (filename, 'rb');
  if (fid < 0)
    error ('wavread: %s', msg);
  end

  %% Get file size.
  fseek (fid, 0, 'eof');
  file_size = ftell (fid);
  fseek (fid, 0, 'bof');

  %% Find RIFF chunk.
  riff_size = find_chunk (fid, 'RIFF', file_size);
  riff_pos = ftell (fid);
  if (riff_size == -1)
    fclose (fid);
    error ('wavread: file contains no RIFF chunk');
  end

  riff_type = char (fread (fid, 4))';
  if(~strcmp (riff_type, 'WAVE'))
    fclose (fid);
    error ('wavread: file contains no WAVE signature');
  end
  riff_pos = riff_pos + 4;
  riff_size = riff_size - 4;

  %% Find format chunk inside the RIFF chunk.
  fseek (fid, riff_pos, 'bof');
  fmt_size = find_chunk (fid, 'fmt ', riff_size);
  fmt_pos = ftell(fid);
  if (fmt_size == -1)
    fclose (fid);
    error ('wavread: file contains no format chunk');
  end
 
  %% Find data chunk inside the RIFF chunk.
  %% We don't assume that it comes after the format chunk.
  fseek (fid, riff_pos, 'bof');
  data_size = find_chunk (fid, 'data', riff_size);
  data_pos = ftell (fid);
  if (data_size == -1)
    fclose (fid);
    error ('wavread: file contains no data chunk');
  end
 
  %%% Read format chunk.
  fseek (fid, fmt_pos, 'bof');
 
  %% Sample format code.
  format_tag = fread (fid, 1, 'uint16', 0, BYTEORDER);
  if (format_tag ~= FORMAT_PCM && format_tag ~= FORMAT_IEEE_FLOAT)
    fclose (fid);
    error ('wavread: sample format %%x is not supported', format_tag);
  end

  %% Number of interleaved channels.
  channels = fread (fid, 1, 'uint16', 0, BYTEORDER);

  %% Sample rate.
  samples_per_sec = fread (fid, 1, 'uint32', 0, BYTEORDER);

  %% Bits per sample.
  fseek (fid, 6, 'cof');
  bits_per_sample = fread (fid, 1, 'uint16', 0, BYTEORDER);

  %%% Read data chunk.
  fseek (fid, data_pos, 'bof');
 
  %% Determine sample data type.
  if (format_tag == FORMAT_PCM)
    switch (bits_per_sample)
      case 8
        format = 'uint8';
      case 16
        format = 'int16';
      case 24
        format = 'uint8';
      case 32
        format = 'int32';
      otherwise
        fclose (fid);
        error ('wavread: %d bits sample resolution is not supported with PCM', bits_per_sample);
    end
  else
    switch (bits_per_sample)
      case 32
        format = 'float32';
      case 64
        format = 'float64';
      otherwise
        fclose (fid);
        error ('wavread: %d bits sample resolution is not supported with IEEE float', bits_per_sample);
    end
  end
 
  %% Parse arguments.
  if (nargin == 1)
    length1 = 8 * data_size / bits_per_sample;
  else
    if (size (param, 2) == 1)
      %% Number of samples is given.
      length1 = param * channels;
    elseif (size (param, 2) == 2)
      %% Sample range is given.
      if (fseek (fid, (param(1)-1) * channels * (bits_per_sample/8), 'cof') < 0)
        warning ('wavread: seeking failed');
      end
      length1 = (param(2)-param(1)+1) * channels;
    elseif (size (param, 2) == 4 && char (param) == 'size')
      %% Size of the file is requested.
      fclose (fid);
      y = [data_size/channels/(bits_per_sample/8), channels];
      return
    else
      fclose (fid);
      error ('wavread: invalid argument 2');
      end
    end

  %% Read samples and close file.
  if (bits_per_sample == 24)
    length1 = length1*3;
  end
  [yi, n] = fread (fid, length1, format, 0, BYTEORDER);
  fclose (fid);

  %% Check data.
  if (mod (numel (yi), channels) ~= 0)
    error ('wavread: data in %s doesnt match the number of channels', filename);
  end

  if (bits_per_sample == 24)
    yi = reshape (yi, 3, rows(yi)/3)';
    yi(yi(:,3) >= 128, 3) = yi(yi(:,3) >= 128, 3) - 256;
    yi = yi * [1; 256; 65536];
  end

  if (format_tag == FORMAT_PCM)
    %% Normalize samples.
    switch (bits_per_sample)
      case 8
        yi = (yi - 128)/127;
      case 16
        yi = yi/32767;
      case 24
        yi = yi/8388607;
      case 32
        yi = yi/2147483647;
    end
  end
 
  %% Deinterleave.
  nr = numel (yi) / channels;
  y = reshape (yi, channels, nr)';
 
end

%% Given a chunk_id, scan through chunks from the current file position
%% though at most size bytes.  Return the size of the found chunk, with
%% file position pointing to the start of the chunk data.  Return -1 for
%% size if chunk is not found.

function chunk_size = find_chunk (fid, chunk_id, size)
  id = '';
  offset = 8;
  chunk_size = 0;

  while (~strcmp (id, chunk_id) && (offset < size))
    fseek (fid, chunk_size, 'cof');
    id = char (fread (fid, 4))';
    chunk_size = fread (fid, 1, 'uint32', 0, 'ieee-le');
    offset = offset + 8 + chunk_size;
  end
  if (~strcmp (id, chunk_id))
    chunk_size = -1;
  end
end