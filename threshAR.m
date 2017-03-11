function [EEG ] = threshAR(EEG,chan,thresh)


%Define initial values
BT(1) = 0;
numbadtrials = 0;
numtrials = size(EEG.data,3); % the 3ird diension of EEG.data

if IsOSX
    separator='/';
else
    separator='\\';
end

%scan the range from -500ms to + 800ms

startpoint =250;
stoppoint=startpoint + 250;

for trinum = 1:numtrials
    %alreadyflagged = 0;
    %windowSize = 4; %this windowsize is for 250hz samplingrate- smoothen the data point to the average of the 4 surrounding points

    pointset = EEG.data(chan,startpoint:stoppoint,trinum);
    
    if max(pointset)> thresh | min(pointset)< -thresh
        
        numbadtrials = numbadtrials + 1; %counting the number of bad trials
        BT(numbadtrials) = trinum; %creating a list of bad trial number
    end
end

%Calculate ratio
remainingtrials = numtrials-numbadtrials;

%Report and store ratio in structure

if(numbadtrials > 0 & remainingtrials > 0)
    
    
    
    EEG = pop_select( EEG,'notrial',BT); %throw away the bad trials, and create a new EEG
    
end
if remainingtrials  == 0
EEG = 0;
end


