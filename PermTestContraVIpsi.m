%This code first permutes the difference wave to find out where it is
%significant. Here you are finding where there are significant differences
%between the CONTRA and IPSI waveform. Godspeed.
close all
clear all
loading_data = {'n20_filt1truetarg1catfilt0'};
nfilename = loading_data;
% loading_data = {'filt1truetarg1catfilt0','filt1truetarg1catfilt1','filt1truetarg0catfilt0','filt1truetarg0catfilt1'};
%load in your .m file that contains masterdata here
for loading = 1:length(loading_data)
    cd masterdata
    L = loading_data(loading);
    load(L{1})
    cd ..
subpos = [1:length(sublist)];
pair = 3;
condition = 1;
type = 1;
%you're not going to build a null distribution for every time point because
%it would be really noisy. Instead you're going to set some window size and
%average the values within that window. Remember that if you've down
%sampled your data to 250Hz, each time point is 4ms so calculate windows
%accordingly
windowsize = 5;%20ms window size
%additionally you're going to want to show that you have multiple windows
%in a row where ipisi and contra are all sig different from one another to
%show there's an actual component. Here I've chosen 80ms as the min since
%it's roughly the duration of the N2pc
siginarowcriteria = 20/windowsize; %80ms width

pvalues=0;
sigvalues=0;

%this bit is going to build you a matrix with the mean contra, ipsi and
%difference waves for all the conditions (that part is mostly for graphing later).
%It's also going to organize a matrix of each sub's difference wave for
%each con. This is what will be used in the permutation
N2pcContraIpsiWaves=zeros(4,3,750);
    sprintf('Condition #%d',condition)
    %N2pcContraIpsiWaves will contain the mean waveforms for each con
    [N2pcContraIpsiWaves(condition,1,:),N2pcContraIpsiWaves(condition,2,:),N2pcContraIpsiWaves(condition,3,:)]=plotmasterdata(masterdata,pair,condition,subpos,type,nfilename);
    load N2pcsub
    thissubsN2pc = N2pcsub{1,1};
    actualsub=0;
    for i = 1:size(N2pcsub,2)
        thissubsN2pc = N2pcsub{1,i};
        if(length(thissubsN2pc > 0))
            actualsub=actualsub +1;
            %AllConAllSubsN2pc will have individual subs diff waveforms for
            %each con
            AllConAllSubsN2pc(actualsub,condition,:)=thissubsN2pc';
        end
    end

%now that the data is organized, this next part does the permuting
AllTheDiffs= 0;
AllTheRealDiffs=0;
windowsdiff = [];
subdiff = [];
window =1;
trial=1;
permutations = 1000; %set how many permutations you want to do
sprintf('Beginning permutation')
    for(p = 1:permutations)
        if(p/100 == ceil(p/100))
            sprintf('Permutation %d',p)
        end  
        window = 1;
        windowsdiff = [];
        windowcount = 1;
        %shuffle the subs around
        shuffledsubs = shuffle(1:size(AllConAllSubsN2pc,1));
        PermuteSubDiffs =[];
        %this part is going through each subject and if they are an even
        %number (index) then they are ipsi - contra, otherwise they're
        %contra-ipsi. Again, everytime you run a permutation, the subjects
        %are scrambled and get a different index
        for sub = 1:size(AllConAllSubsN2pc,1)
            if mod(shuffledsubs(sub),2) == 0 %if it's in the first half
                PermuteSubDiffs(sub,:) = AllConAllSubsN2pc(sub,condition,:)*-1;
            else
                PermuteSubDiffs(sub,:) = AllConAllSubsN2pc(sub,condition,:);
            end
            %this part stores the real data (you obviously only need to do
            %this the once
            if p == permutations 
                RealSubDiffs(sub,:) = AllConAllSubsN2pc(sub,condition,:);
            end
        end
        windowcount = 1;
        %now goes through and takes the avg of each time window, then averages across subs
        while window <= size(PermuteSubDiffs,2)-windowsize+1 
            windowavgs_permuted(condition,windowcount,p) = mean(mean(PermuteSubDiffs(:,window:window+windowsize-1),2),1);
            %at the last cycle we take the window avg of the real values
            if p == permutations 
                windowavgs_real(condition,windowcount) = mean(mean(RealSubDiffs(:,window:window+windowsize-1),2),1);
            end
            window = window+windowsize;
            windowcount = windowcount + 1;
        end
    end
%OK, now the permuting is done. This next chunk will go through each
%timestep (talking windows here now) and compare the real value with all of
%the permuted values that you generated and give you the probability of
%selecting a value from the permuted collection that is smaller than your
%your real value (i.e. what are the chances of getting this by chance)
sprintf('calculating p-values')
    sigvalues=[];
    pvalues=[];
    for windowcount = 1:size(windowavgs_real,2)
        %here we're finding out how many permuted values are less than the
        %real one
        numberlesser = sum((windowavgs_permuted(condition,windowcount,:) < windowavgs_real(condition,windowcount)));
        %here we're turning that into a probability
        pvalues(windowcount) = numberlesser/permutations;
        
        sigvalues(windowcount)  = NaN;
        %this part is checking to see how many significant windows there
        %are in a row
        if windowcount> siginarowcriteria
            if sum(pvalues(windowcount-(siginarowcriteria-1):windowcount) < .05) >=  siginarowcriteria || sum(pvalues(windowcount-(siginarowcriteria-1):windowcount) > .95) >=  siginarowcriteria
                sigvalues(windowcount)  = pvalues(windowcount);
            end
        end
        
    end
    Allsigvalues(condition,:)=sigvalues;
    Allpvalues(condition,:)=pvalues;

%Now onto the graphing...

x=[-1000:4:1996];
midline=zeros(1,750);
line250=[250,250];
y_upper = 4;
y_lower = -8;
y=[y_lower,y_upper];
DiffOffset = 6;
lineColor = [.5 .5 .5];


    %this part is going to plot the p-values for every window across the
    %epoch. The red dots mark where there are enough significant windows in
    %a row
    h=figure('Color',[1 1 1])
    title(sprintf('p-value of diff, con 1 V con %d',condition+1))
    time = ([1:length(Allpvalues(condition,:))]*(windowsize*4))-1000-(windowsize*4);
    plot(time,Allpvalues(condition,:),'LineWidth',1.5,'Color',[.7 .2 .7]);
    hold on
    scatter(time,Allsigvalues(condition,:),50,'filled');
    x=ones(1,size(Allpvalues(condition,:),2)).*.05;
    plot(time,x,'r');
    x=ones(1,size(Allpvalues(condition,:),2)).*.95;
    plot(time,x,'r');
    plot(line250,y,'Color',[.5 .5 .5])
    set(gca,'TickLength',[.025 .025])
    title(sprintf('%s',L{1}))
    ylim([0 1])
    xlim([-200 1000])
    box off
    
    filename = sprintf('PermResults_ContraIpsi_%s.pdf',L{1})
    saveas(h,filename)
    %this bit is going to plot the contra, ipsi and difference waves so
    %that you can look at where the windows are on the actual waveform
    midline=zeros(1,750);
    h=figure('Color',[1 1 1])
    title(sprintf('N2pcContraIpsi_%s',L{1}))
    x=[-1000:4:1996];
    plot(x,squeeze(N2pcContraIpsiWaves(condition,2,:)),'b','LineWidth',2)
    hold on
    plot(x,squeeze(N2pcContraIpsiWaves(condition,3,:)),'r','LineWidth',2)
    plot(x,(squeeze(N2pcContraIpsiWaves(condition,1,:))*2)-20,'g','LineWidth',2)
    plot(x,midline,'Color',[.5 .5 .5],'LineWidth',1.5)
    plot(x,midline-20,'Color',[.5 .5 .5],'LineWidth',1.5)
 xlim([-200 1000])
box off
filename = sprintf('N2pcContraIpsi_%s.pdf',L{1})
    saveas(h,filename)
end
