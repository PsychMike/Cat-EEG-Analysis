addpath StatsFunctions %this is to do the repeated measures ANOVA (if this is added to your path you don't need it)

%% N2pc latency analysis

%This compares the latency of each condition's N2pc. this will get the time point at which
%participants' difference waveforms are 50% to peak
nfilename = 'masterdata/n20_filt1truetarg1catfilt0';
load(nfilename); %load in YOUR data
type = 1;
pair = 3;
sublist = [20:35,37:39,41];
subpos = 1:length(sublist);

%this bit is just to organize your data so that you have a matrix that is
%sub X con X time of difference waves
condition = 1;
    plotmasterdata(masterdata,pair,condition,subpos,type,nfilename);
    load NCI/N2pcsub_n11_filt1truetarg1catfilt0
    thissubsn2pc = N2pcsub{1,1};
    actualsub=0;
    for i = 1:size(N2pcsub,2)
        thissubsn2pc = N2pcsub{1,i};
        if(length(thissubsn2pc > 0))
            actualsub=actualsub +1;
            AllConAllSubsN2pc(actualsub,condition,:)=thissubsn2pc';
        end
    end
%this is the time window that you are looking at
starttime = (0+1000)/4;
endtime = (400+1000)/4;

JKConditionMean=[];
NumSubsAnalyzed=size(AllConAllSubsN2pc,1);
JKConPeakLatency=[];
windowlength=5;
JKConOnset = [];
JKConOffset = [];
%%% now go through and remove one subject at a time and find the
%%% subsample's latencies
for condition = 1
    for i = 1:size(AllConAllSubsN2pc)
        JKAllConAllSubsN2pc = AllConAllSubsN2pc;
        JKAllConAllSubsN2pc(i,:,:)=[]; %empty one sub at a time
        try
        JKConditionMean = squeeze(mean(JKAllConAllSubsN2pc(:,condition,:)));%take mean of new subsample
        catch
            sca
            keyboard
        end
        JKminamp = min(JKConditionMean(starttime:endtime)); %find the minimum in a broad window of the N2pc
        JK50minamp = JKminamp/2; %this is the half amp
        %find the position of the lowest point
        mintimept = find(JKConditionMean==JKminamp);
        %find the position of the half amp
        min50timept = find(abs(JKConditionMean(mintimept-15:mintimept)-JK50minamp)==min(abs(JKConditionMean(mintimept-15:mintimept)-JK50minamp)));
        min50timept = min50timept + mintimept-15-1;
        %this bit just adds some variability
        ampJustbefore = JKConditionMean(min50timept-1);
        ampJustafter = JKConditionMean(min50timept+1);
        %stores the position into master matrix
        JKCon50PeakLatencyN2pc(i,condition) = min50timept-(ampJustafter/(JKminamp+ampJustafter))+(ampJustbefore/(JKminamp+ampJustbefore));
    end
end
%translates the latency points into time
JKCon50PeakLatencyN2pc = (JKCon50PeakLatencyN2pc.*4)-1000 %matrix of all of the peaks of subsamples

ConPeakLatency = mean(JKCon50PeakLatencyN2pc) %shows you the condition means for onset
for i = 1:size(JKCon50PeakLatencyN2pc,1)
    Devs(i,:) = (JKCon50PeakLatencyN2pc(i,:) - ConPeakLatency).^2;
end
Devs = sum(Devs);
ConPeakSTDERROR= sqrt(Devs .* ((size(JKCon50PeakLatencyN2pc,1)-1)/size(JKCon50PeakLatencyN2pc,1)))%std error of that measure

%%%%%%%%%%%%%%% ORGANIZING DATA FOR VARIOUS ANOVAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% conds = [1 2];
% rmdataoverall = 0;
% subcount = 0;
% 
% for sub = 1:size(JKCon50PeakLatencyN2pc,1)
%     
%     subcount = subcount + 1;
%     condcount = 0;
%     for cond = conds
%         condcount = condcount + 1;
%        
%         rmdataoverall((subcount -1)*length(conds) + condcount,1) = JKCon50PeakLatencyN2pc(sub,cond);
%         rmdataoverall((subcount -1)*length(conds) + condcount,2) = condcount;
%         rmdataoverall((subcount -1)*length(conds) + condcount,3) = subcount;
%     end
%     
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%% ANOVA FOR PEAK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sprintf('The following peak latency analysis is for the electrode pair: %d',pair)
% RMAOV1varcor(rmdataoverall)

