function [ chromosome_mutated ] = mutate( chromosome, p, gen_index )

    chromosome_mutated = chromosome;
    
    if nargin == 3
        start_index = gen_index;
        end_index = gen_index;
    else
        start_index = 2;
        end_index = length(chromosome);
    end
    
    for i=start_index:end_index
        Afields = fieldnames(chromosome{i});
        Acell = struct2cell(chromosome{i});
        sz = size(Acell);
        % Convert to a matrix
        Acell = reshape(Acell, sz(1), []);      % Px(MxN)

        % Make each field a column
        Acell = Acell';                         % (MxN)xP

        
        %El último campo corresponde al canal y este debe ser constante
        for j=1:length(Acell)-1
            N = length(Acell{j});
            for k=1:N
                if (rand()<p)
                    Acell{j}(k)= dec2bin(strcmp(Acell{j}(k),'0'));
                end            
            end
        end


        % Put back into original cell array format
        Acell = reshape(Acell', sz);

        % Convert to Struct
        chromosome_mutated{i} = cell2struct(Acell, Afields, 1);
    end
end

