
function [EEG] = blinkAR(EEG,chan,thresh,subnum,checkthresh) % if checkthresh=1, check the bumps distribution for every subject


%Define initial values
BT(1) = 0;
numbadtrials = 0;
numtrials = size(EEG.data,3); % the 3rd dimension of EEG.data

WindowLength = 25; % the time window duration (data points)

%Look for differences in microvolts between staggered parts of trial with
%length (user set) to find differences larger than threshold (user set)for
%each trial
for trinum = 1:numtrials
    alreadyflagged = 0;
    diffmax=0;
    windowSize = 8; %this windowsize is for 250hz samplingrate- smoothen the data point to the average of the 4 surrounding points
    pointset = EEG.data(chan,:,trinum);
    
    pointset = filter(ones(1,windowSize)/windowSize,1,pointset); % filter is a matlab func that smoothens the data, get rid of unusual spikes
    
    startpoint = 125; %-500 to 1200
    stoppoint=550;
    
    for stepper = startpoint:stoppoint % from the 10th data point to the end of the window
        first = pointset(stepper);  % in a window of 4 data points, to see what the magnitude of fluctuations is
        last = pointset(stepper+WindowLength);
        diff = abs(first - last);
        if diff>diffmax % every time there is a bump bigger than the previous one, replace the diffmax with diff
            diffmax=min(diff,300);% cap diff at 300;
        end
        if diff>thresh
            if(alreadyflagged ==0)
                numbadtrials = numbadtrials + 1; %counting the number of bad trials
                BT(numbadtrials) = trinum; %creating a list of bad trial numbers
                alreadyflagged =1;
            end
        end
    end
    diffmaxarray(trinum)=diffmax; % get the magnitude of bump for every trial
end

%Calculate ratio

%Report and store ratio in structure
sprintf('original trials %d good trials %d',numtrials,numtrials-numbadtrials)

%remove rejected trials and save
if( numbadtrials >0)
    if numbadtrials <numtrials
        
        EEG = pop_select( EEG,'notrial',BT); %throw away the bad trials, and create a new EEG
        
%     else
%         'REJECTED EVERYTHING!!!!!!!'
%         keyboard
        
    end
end
if(checkthresh)  %do we want to plot values for this subject?
    figure
    hist( diffmaxarray,30);
    title(sprintf('Sub %d_channel %d',subnum,chan));
    keyboard
    
end

