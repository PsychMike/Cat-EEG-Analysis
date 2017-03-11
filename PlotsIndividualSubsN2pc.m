
%this plots all of the subs N2pcs
load alldataFilteredTargets

pair = 2; 

subpos = [1:size(masterdata,1)];

% conditions = [1:6];

AllConAllSubsN2pc=[];
actualsub=0;
sprintf('Organizing Data')
%This pulls out all the subs n2pc data for each condition and organizes it
%into a tidy matrix

con =1;
for (condition = 1)
    sprintf('Condition #%d',condition)
    plotmasterdata(masterdata,pair,condition,subpos);
    load N2pcsub
    thissubsn2pc = N2pcsub{1,1};
    actualsub=0;
    for i = 1:size(N2pcsub,2)
        thissubsn2pc = N2pcsub{1,i};
        if(length(thissubsn2pc > 0))
            actualsub=actualsub +1;
            AllConAllSubsN2pc(actualsub,con,:)=thissubsn2pc';
        end
    end
    con=con+1;
end

x=[-1000:4:1996];
figure
for i = 1:size(AllConAllSubsN2pc,1)
    subplot_tight(4,8,i,.02)
    thissubsN2pc = squeeze(AllConAllSubsN2pc(i,1,:));
    plot(x,thissubsN2pc)
    hold on
%     plot(x,thissubsdigit)
    title(sprintf('%d',i))
    xlim([0 1000])
    ylim([-15 15])
    line250=[250,250];
    y=[-20,20];
    plot(line250,y)
end

    
 %enter = input('any key to continue')



