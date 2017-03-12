function EEG = setevents(EEG,FilteredForAccuracy,true_target,cat_filt,Userdata)

these_events = EEG.event;
numevents = 0;

for(i = 1: length(these_events))
    
    if(ischar( these_events(i).type))
        
        if (these_events(i).type > 47 && these_events(i).type < 58)
            
            numevents = numevents + 1;
            types(numevents) = eval(these_events(i).type);
            latency(numevents) = these_events(i).latency;
            urevent(numevents) = these_events(i).urevent;
            
        else  %when we get those boundary events
            numevents = numevents + 1;
            types(numevents) = 0;
            latency(numevents) = 0;
            urevent(numevents) = 0;
        end
    else
        numevents = numevents + 1;
        types(numevents) = these_events(i).type;
        latency(numevents) = these_events(i).latency;
        urevent(numevents) = these_events(i).urevent;
    end
end

hits = 0;
thisevent = 1;

while (thisevent < length(types))
    
    if(types(thisevent) == 13)
        findend = thisevent;
        try
            while types(findend+1) ~= 13
                findend=findend+1;
            end
        catch
            findend=length(types(thisevent:end));
        end
        endtrialevent = findend - thisevent - 1;
        %start of a trial!
        actualtrialnum3 = types(thisevent+1)-22;
        actualtrialnum2 = types(thisevent+3)-22;
        actualtrialnum1 = types(thisevent+5)-22;
        actualtrialnum = actualtrialnum3*100+actualtrialnum2*10+actualtrialnum1*1;
        
        trial = actualtrialnum;
        if trial > 3
            if FilteredForAccuracy
                try
                    if strcmp(Userdata.Blocks.Trials(trial).Trial_Export.review_item,'y')
                        skip = 0;
                    else
                        skip = 1;
                    end
                catch
                    skip = 1;
                end
            else
                skip = 0;
            end
            if skip == 0
                %                 firstpossibleevent = 16;
                firstpossibleevent = 1;
                
                truecategoryevent = 7;
                
                true_cat_trigger = types(thisevent+truecategoryevent) - 66;
                
                trueitemevent = 13;
                
                falsecategoryevent = 14;
                
                false_cat_trigger = types(thisevent+falsecategoryevent) - 116;
                
                falseitemevent = 6;
                
                %Category Filter
                truecat_present =  sum(cat_filt==true_cat_trigger);
                falsecat_present =  sum(cat_filt==false_cat_trigger);
                
                try
                    for evadd = firstpossibleevent: firstpossibleevent + endtrialevent
                        if true_target && truecat_present
                            %True Targets
                            if (types(thisevent+evadd) == 104)
                                types(thisevent+evadd) = 980; %left
                            elseif (types(thisevent+evadd) == 103)
                                types(thisevent+evadd) = 990; %right
                            end
                            hits = hits +1;
                        elseif true_target == 0 && falsecat_present
                            %False Targets
                            if (types(thisevent+evadd) == 102)
                                types(thisevent+evadd) = 980; %left
                            elseif (types(thisevent+evadd) == 101)
                                types(thisevent+evadd) = 990; %right
                            end
                            hits = hits +1;
                        end
                    end
                end
            end
        end
    end
    thisevent = thisevent + 1;
end

for i = 1:length(these_events)
    these_events(i).type = types(i);
end
hits
EEG.event = these_events;

