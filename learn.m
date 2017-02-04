function [data, frame,lastEMTree] = learn( varargin )
    okargs =   {'knowledge', 'training','checkpoint','back'};
    defaults = {'data/MIDI', 25, 10, 0};
    [~,~,knowledge_path, iter, saveAtIter, backInDays] = getargs(okargs,defaults,varargin{:});
    
    
    
    if ~exist('sessionName','var')
        sessionName = date;
        j=1;
        data = readDir(knowledge_path);
        if (length(fields(data))>0)
            data=audioStructArrayDWT(data, 'compression', 32);
            frame(1) =getframe;
            close;
            i = randi(length(data), 1);
            h = daubcqf(6);
            L = log2(length(data(i).wave));
            wavwrite(Iidwt([data(i).dwt zeros(1, length(data(i).wave)-length(data(i).dwt))],h,L), data(i).fs, ['sample_' int2str(i) '.wav']);
            fprintf(1, 'sample_%d.wav saved\n\n', i );
        else
            fprintf(2,'ERROR: No se encontraron datos para procesar en la ruta: %s\n', knowledge_path);
            iter=0;
        end
    else
        sessionName = datestr(datenum(date)-backInDays);
        i=[];
        load(sessionName);
        j=i;
        clear('i');
    end


    for i=j:iter
        [data]=processData(data, 'iter', i);
        fig = figure();
        if exist('lastEMTree', 'var')
            lastEMTree = plotEMTreeData(data, lastEMTree);
        else
            lastEMTree = plotEMTreeData(data);
        end
        frame(end+1)=getframe(fig);
        close;
        if mod(i,saveAtIter) == 0
            save(sessionName, 'data', 'frame', 'lastEMTree','i', '-v7.3');
        end
    end
    
    if (exist('data','var') && exist('frame','var') && exist('lastEMTree','var') && exist('i','var'))
        save(sessionName, 'data', 'frame', 'lastEMTree','i', '-v7.3');
    end
end