function ANOVAfor2ndN2pc(nfilename,pair)
%This will compare the AOC of the 2nd N2pc time window for each con and
%then run an ANOVA to compare them
%we go 150, 300, or 600ms (diff lags) after 250ms (first n2pc) and we
%baseline that at 100ms prior and take a mean amp from a 24ms window around
%the peak.
    plot_erp = 1;
    masterdata = sprintf('masterdata/%s',nfilename);
    load(masterdata)
    subpos = [1:length(sublist)];
    condition = 1; % this bit is to get all of the difference waves in a matrix
    if plot_erp
        check_sub_nums = 0;
        load_unfiltered = 0;
        load_ft = 0;
        plotERPs(nfilename,check_sub_nums,load_unfiltered,load_ft,sublist,pair,condition)
    end
    sprintf('=Condition #%d',condition)
    Contrasub = sprintf('NCI/Contrasub_%s',nfilename);
    load(Contrasub);
    Ipsisub = sprintf('NCI/Ipsisub_%s',nfilename);
    load(Ipsisub);
    actualsub = 0;
    for i = 1:length(sublist);
        thissubsContrasub = Contrasub{1,i};
        thissubsIpsisub = Ipsisub{1,i};
        
        if(length(thissubsContrasub > 0))
            actualsub=actualsub +1;
            AllConAllSubsN2pc(actualsub,1,:)=thissubsContrasub';
            AllConAllSubsN2pc(actualsub,2,:)=thissubsIpsisub';
        end
    end
    %to get time points for 2nd N2pcs    
    SecondN2pcChunk=[];
    AveragePeak=[];
    startwindow = floor((200+1000)/4);
    endwindow = floor((400+1000)/4);
    
    for sub = 1: size(AllConAllSubsN2pc,1)
        for side = 1:2
            SecondN2pcChunk(sub,side,:) = AllConAllSubsN2pc(sub,side,startwindow:endwindow);
            AveragePeak(sub,side) = mean(squeeze(SecondN2pcChunk(sub,side,:)));
        end
    end
    
    conds = 1;
    repmdata = 0;
    subcount = 0;
    rowcount = 0;
    for(sub = 1:size(SecondN2pcChunk,1))
        subcount = subcount + 1;
        condcount = 0;
        for cond = 1:2
            condcount = condcount + 1;
            rowcount = rowcount + 1;
            repmdata(rowcount,1) = AveragePeak(subcount,cond);
            repmdata(rowcount,2) = condcount;
            repmdata(rowcount,3) = subcount;
        end
    end
%end
RMAOV1(repmdata)
end