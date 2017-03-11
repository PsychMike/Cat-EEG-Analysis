
function [ElectrodeData] = plotmasterdataCENTRALELECTRODES(masterdata,pair,condition,subpos)

electrode = [3 4 15 21];

trialcriterion = 8;

Checktrialscountacrosslocations = 0;
Checkeyes = 0;
ploteyes = 0;

ElectrodeData=[];

goodsubs = 0;

eyebad = 0;

reject_thresh = 100;

fp = fopen('trialcounts.csv','w');

for sub = subpos

    %eliminate all trials in which the threshold is exceeded on left
    %channel
    for(temppair = pair)
        loc = electrode(temppair);
        for( con  = 1:size(masterdata,2))
            goodtrials = 0;
            if(size(masterdata{sub,con,loc,1},1)==1)
                masterdata{sub,con,loc,1} = masterdata{sub,con,loc,1}';
            end
            for(trial = 1:size(masterdata{sub,con,loc,1},2))
                eegdatal = masterdata{sub,con,loc,1}(:,trial);
                if(max(abs(eegdatal(200:500,1))) >  reject_thresh)  %check voltage from -200 to + 1000 msec
                    goodtrials(trial) = 0;
                else
                    goodtrials(trial) = 1;
                end
            end
            goodtrials = find(goodtrials ==1);

            %cut out the bad trials from the left
            masterdata{sub,con,loc,1} = masterdata{sub,con,loc,1}(:,goodtrials);

            goodtrials = 0;
            if(size(masterdata{sub,con,loc,2},1)==1)
                masterdata{sub,con,loc,2} = masterdata{sub,con,loc,2}';
            end
            for(trial = 1:size(masterdata{sub,con,loc,2},2))
                eegdatal = masterdata{sub,con,loc,2}(:,trial);

                if(max(abs(eegdatal(200:500,1))) >  reject_thresh)
                    goodtrials(trial) = 0;
                else
                    goodtrials(trial) = 1;
                end
            end
            goodtrials = find(goodtrials ==1);
            %cut out the bad trials from the right
            masterdata{sub,con,loc,2} = masterdata{sub,con,loc,2}(:,goodtrials);
        end
    end

    %check to reject subjects for having too few trials

    checkconds  = 1:size(masterdata,2);

    if(Checktrialscountacrosslocations)  %check across all electrode pairs?
        loccount = 0;
        for(loc = electrode)
            %for(loc = [1,2,5,12])
            loccount = loccount + 1;
            for(con = checkconds)
                trialcounts(sub,con,loccount) = size(masterdata{sub,con,loc,1},2) + size(masterdata{sub,con,loc,2},2);
            end
        end
    else    %or are we just checking across the current pair?
        loc = electrode(pair);

        for(con = checkconds)
            trialcounts(sub,con) = size(masterdata{sub,con,loc,1},2) + size(masterdata{sub,con,loc,2},2);
        end

    end


    if(min(trialcounts(sub,checkconds)) >= trialcriterion & eyebad == 0)
        subjectgood = 1;
        goodsubs = goodsubs + 1
    else
        subjectgood = 0;
    end

    fprintf(fp,'%d,',min(min(trialcounts)));

    sprintf('trialcounts: %d',trialcounts)


    startpoint = 1;
    %endpoint = 750;
    endpoint = size(masterdata{1,1,1,1}(:,1),1);
    if(subjectgood)

        %compute the N2pc for this subject
        subdata{sub} = [masterdata{sub,condition,electrode(pair),1}(startpoint:endpoint,:),masterdata{sub,condition,electrode(pair),2}( startpoint:endpoint,:)];

        Datasub{sub}=mean(subdata{sub} ,2);

        if(size(ElectrodeData,1) ==0)
            ElectrodeData =  mean(subdata{sub},2) ;
        else
            ElectrodeData =  ElectrodeData +  mean(subdata{sub},2);
        end
        
        save('Datasub','Datasub','subdata');

    end

end

trialcounts

ElectrodeData = ElectrodeData/goodsubs;

save('ElectrodeData','ElectrodeData','trialcounts');

sprintf('Goodsubs: %d',goodsubs)

fprintf(fp,'\n')
fclose(fp);


end

