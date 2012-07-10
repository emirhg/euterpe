function [data] = getFileNamesFromDir( FOLDER, FILTER )
%GETFILENAMESFROMDIR Recursive function. Gets a deeply directory listing
%   FILTER filters the listing by it's file type (extention)
    data = {};
    if nargin<1
        FOLDER = '.';
    end
    if nargin<2
        FILTER = '\.(\w+)$';
    end

    fprintf(1,'Listing: %s\n', FOLDER);
    FILES = dir(FOLDER);

    for (i=1:length(FILES))
        FILE = FILES(i);
        if (FILE.isdir && not(strcmp(FILE.name,'.')) && not(strcmp(FILE.name,'..')))
            dirFiles = getFileNamesFromDir(strcat(FOLDER,'/',FILE.name),FILTER);
            data = [data,dirFiles];
        else
            if not(isempty(regexp(FILE.name,FILTER,'ONCE')))
                fprintf(1,'\t%s\n',FILE.name);
                data(end+1) = {strcat(FOLDER,'/',FILE.name)};
            end
        end
    end
end

