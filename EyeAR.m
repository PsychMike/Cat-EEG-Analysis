function [EEG ] = threshAR(EEG,chan,thresh);


%Define initial values
BT(1) = 0;
numbadtrials = 0;
numtrials = size(EEG.data,3); % the 3ird diension of EEG.data

%scan the range from 0ms to + 800ms
startpoint = 250;
stoppoint=startpoint + 200;
windowlength = 8;
for trinum = 1:numtrials
    %alreadyflagged = 0;
    try
    pointset = EEG.data(chan,startpoint:stoppoint,trinum);
    thisbadtrial = 0;
    catch
        keyboard
    end
    for(datapoint = 1+windowlength:length(pointset))
        currentdatapoint = mean(pointset(datapoint - windowlength:datapoint));
        
        
        if currentdatapoint> thresh || currentdatapoint< -thresh
            thisbadtrial = 1;
        end
        
    end
    if(thisbadtrial)
        numbadtrials = numbadtrials + 1; %counting the number of bad trials
        BT(numbadtrials) = trinum; %creating a list of bad trial number
    end
end

%Calculate ratio
rejectedtrials = numtrials-numbadtrials;

%Report and store ratio in structure

if(numbadtrials > 0)
     
    EEG = pop_select( EEG,'notrial',BT); %throw away the bad trials, and create a new EEG
    
end
    

