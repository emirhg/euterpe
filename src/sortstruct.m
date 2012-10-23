function [ Asorted ] = sortstruct( structure, field )
%SORTSTRUCT Sorts an structure given a field
%   Detailed explanation goes here

if nargin==1
    field = 1;
end
Afields = fieldnames(structure);
Acell = struct2cell(structure);
sz = size(Acell);
% Convert to a matrix
Acell = reshape(Acell, sz(1), []);      % Px(MxN)

% Make each field a column
Acell = Acell';                         % (MxN)xP

% Sort by first field "name"
Acell = sortrows(Acell, field);
% Put back into original cell array format
Acell = reshape(Acell', sz);

% Convert to Struct
Asorted = cell2struct(Acell, Afields, 1);
end

