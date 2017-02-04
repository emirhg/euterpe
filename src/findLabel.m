function [ label ] = findLabel( string )
%FINDLABEL Summary of this function goes here
%   Detailed explanation goes here
    label = string(regexp(string, '[^/]+/[^/]+\.'):regexp(string, '/[^/]+\.')-1);
end

