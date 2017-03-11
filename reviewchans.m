%This program will allow you to scroll through each channel of each subject
%to determine bad channels

% rmpath C:\Users\callahac\Documents\eeglab12_0_2_5b\eeglab12_0_2_5b\functions\octavefunc\signal
addpath CatFeatExpDATA
chans = [1:31];
%     sublist = [20:32,35,37:39,41:48];
        sublist = [43];
%On a Mac or PC, choose the right data directory
if IsOSX
    separator='/';
else
    separator='\\';
end
addpath 'data'
Expname = 'imageEEG';
numsubs = 0;
histgraph = figure;
linegraph = figure;
for(sub = sublist)
    numsubs = numsubs + 1;
    sprintf( 'loading data for subject #%d',sub)
    filename = sprintf('sub_sets/imageEEGsub%d_500.set',sub);
    EEG = pop_loadset( 'filename', filename); %use EEGlab to load a file
    for (chan = chans)
        figure(histgraph)
        title(sprintf('line plot of chan %d of sub %d',chan,sub))
        plot(EEG.data(chan,:))
        figure(linegraph)
        hist(EEG.data(chan,:),1000);
        title(sprintf('histogram of chan %d of sub %d',chan,sub))
        enter = input('any key to continue')
    end
end
close(linegraph)
close(histgraph)