function midi = truncateMIDI(midi, max_dur)
	i=1;
	while i<=length(midi)
		if midi(i,6) > max_dur
			midi(i,:)=[];
		else
			i = i+1;
		end
	end
end
