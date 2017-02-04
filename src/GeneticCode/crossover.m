function [ son ] = crossover( father, mother, p )
%CROSSOVER Summary of this function goes here
%   Detailed explanation goes here

    son = father;
    copy_mother = true;
    
    
    for i=2:min(length(mother), length(son))
        Afields = fieldnames(mother{i});
        Mothercell = struct2cell(mother{i});
        Soncell = struct2cell(son{i});
        sz = size(Mothercell);
        sz_son = size(Mothercell);
        % Convert to a matrix
        Mothercell = reshape(Mothercell, sz(1), []);      % Px(MxN)
        Soncell = reshape(Soncell, sz_son(1), []);      % Px(MxN)
        % Make each field a column
        Mothercell = Mothercell';                         % (MxN)xP
        Soncell = Soncell';
        
       % M = length(Acell);

        for j=1:4
            N = min(length(Mothercell{j}),length(Soncell{j}));
            for k=1:N
                if (rand()<p)
                    copy_mother = not(copy_mother);
                end
                
                if (copy_mother)
                    Soncell{j}(k)= Mothercell{j}(k);
                end                           
            end
            
            if length(Mothercell{j}) > length(Soncell{j}) && copy_mother
                Soncell{j} = [Soncell{j}, Mothercell{j}(k+1:end)];
            end
            
            if length(Mothercell{j}) < length(Soncell{j}) && copy_mother
                Soncell{j}(k+1:end) = '';
            end
        end


        % Put back into original cell array format
        Soncell = reshape(Soncell', sz_son);

        % Convert to Struct
        son{i} = cell2struct(Soncell, Afields, 1);
    end

end

