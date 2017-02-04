function [labelsDist] = labelsDistribution(data)


    [uniqueC, ~, idx ]= unique({data(:).label}');
    
    
	counts = accumarray(idx(:),1,[],@sum);
    countCell = num2cell(counts);
    
    %tmp = [uniqueC,countCell]
    %unique_count = tmp{:}
    
    
    pie(counts, uniqueC);
    title('Knowledge Style Distribution');
    
    %[uniqueC; num2str(counts)]
    %counts
end