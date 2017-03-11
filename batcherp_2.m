function batcherp_2(numCons,sublist,FilteredForAccuracy,true_target,cat_filt,nfilename)
sprintf('Starting batcherp')
%all of the channels you would like to consider.
chans = [1:31];
samrate=500; %sampling rate
addpath 'data'
%the start of the ERP that is of interest, in the unit of seconds
timestart = -1;
%The end of the ERP that is of interest,in the unit of seconds
timestop = 2;
%number of time points that are included in the specified time window
erppoints = (timestop-timestart) * samrate;
%enter the prefix of your EEG files after they have been reformatted by
%EEGLab
% Expname = ExpName;
%here enter noisy channels that you would like removed, and their data
%interpolated from neighboring channels
%1    %2   %3   %4  %5    %6  %7    %8      %9   %10   %11   %12   %13  %14  %15  %16  %17  %18  %19  %20  %21    %22  %23  %24  %25  %26  %27  %28  %29  %30      %31        %32      %33      %34      %35         %36     %37    %38 %39   %40    %41
% badchans = {[20],[20],[20],[20],[20],[20],[20],[20,31],[20],[20],[20,31],[20],[20],[20],[20],[20],[20],[20],[20],[20],[20,28],[20],[20],[20],[20],[20],[20],[20],[20],[20],[13,20,26],[13,20,26],[20,31],[20,30,31],[18,20],[20,30],[14,20,28],[20],[20],[20,30],[20],[20],[20],[20],[20],[20],[20],[20]};  %38  %39    %40       %41    %42  %43  %44  %45  %46  %47  %48
% badchans = {[20],[20],[20],[20],[20],[20],[20],[20,31],[20],[20],[20,31],[20],[20],[20],[20],[20],[20],[20],[20],...
% [20],[20,28],[20,28],[20],[20],[20],[20],[20],[20],[20],[20,4,14,28],[13,20,26],[13,20,26,28],[20,31,14,28],[20,30,31,28],[18,20],[20,30],[11,14,20,28],[20],[20],[20,30],[1,2,3,20],[20],[20],[20],[20],[20],[20],[20]};
badchans = {[20],[20],[20],[20],[20],[20],[20],[20,31],[20],[20],[20,31],[20],[20],[20],[20],[20],[20],[20],[20],...
    [20],[20,28],[20],[20],[20],[20],[20],[20],[20],[20],[20],[13,20,26],[13,20,26],[20,31,14,28],[20,30,31,28],[18,20],[20,30],[14,20,28],[20],[20],[20,30],[20],[20],[20],[20],[20],[20],[20,31],[20]};
numsubs = 0;
subs_that_broke_it=[];
targEvents = [980:989;990:999];

for(sub = sublist)
    %     try
    skip_sub = 0;
    numsubs = numsubs + 1
    sprintf( 'Attempting epoch for subject #%d',sub)
    
    resamp_set = sprintf('sub_sets/imageEEGsub%d_250.set',sub);
    resampled = exist(resamp_set);
    
    if resampled == 0
        filename = sprintf('sub_sets/imageEEGsub%d_500.set',sub);
    else
        filename = sprintf('sub_sets/imageEEGsub%d_250.set',sub);
    end
    EEG = pop_loadset( 'filename', filename); %use EEGlab to load a file
    
    filename2 = sprintf('data/ExpSub_compact_%d_judged1',sub);%loads in behavioral data (not compact version)
    
    %         all_trials = 1;
    
    %resamples EEG for smaller data file
    if resampled == 0
        EEG = pop_resample(EEG,250);
                filename = sprintf('sub_sets/imageEEGsub%d_250.set',sub);
        EEG = pop_saveset(EEG,filename);
    end
    
    Heyechan = 30; % HEO
    Veyechan = 31; %VEO
    Hthresh = 20; %horizontal threshold
    Vthresh = 100; %vertical threshold
    
    %set events cycles through every trial and using behavioral
    %data will rename the triggers depending on whether they were
    %reported accurately
    
    EEG = setevents(EEG,FilteredForAccuracy,true_target,cat_filt,filename2);
    
    %%%%%%%%%%%%%%
    %     eliminate bad channels
    
    load chanlocs3 %sets the locations of the channels
    EEG.chanlocs = EEGchanlocs;
    %this interpolates the bad channels
    if isempty(badchans{sub}) == 0
        EEG = pop_interp(EEG,badchans{sub},'spherical');
    end
    
    for condition = 1:numCons
        for leftright = 1:2;
            if leftright == 1
                targevent = 980;
            else
                targevent = 990;
            end
            
            %next we create time windows around our new triggers, dependent
            %on parameters we set above
            try
                EEG_1con1side= pop_epoch( EEG, {targevent}, [-1  2], 'newname', 'tempname', 'epochinfo', 'yes');
            catch
                skip_sub = 1;
                %                     keyboard
            end
            if skip_sub == 0
                %this removes the baseline by making the average voltage
                %between -200ms and 0ms equal to zero
                EEG_1con1side = pop_rmbase(EEG_1con1side,[-200 0]);
                thisEEG = EEG_1con1side;
                
                if(isstruct(thisEEG) ~= 1)
                    masterdata{numsubs,condition,chan,leftright} = 0;
                else
                    %eliminate eye movement trials
                    thisEEG=EyeAR(thisEEG,Heyechan,Hthresh);
                    thisEEG=blinkAR(thisEEG,Veyechan,Vthresh,sub,0);
                    
                    if leftright == 1
                        lefteeg=thisEEG;
                    else
                        righteeg=thisEEG;
                    end
                    
                    for chan = chans
                        eegdata = squeeze(thisEEG.data(chan,:,:));
                        masterdata{numsubs,condition,chan,leftright} = eegdata;
                    end
                end
            end
        end
        
    end
    %     catch
    %         subs_that_broke_it = [subs_that_broke_it, sub];
    %         sprintf('SUB #%d BROKE IT',sub)
    %     end
    if skip_sub == 0
        pairleft = [2,12,11,13,18,19,24,26,25,27,29,14];
        pairright = [1,5,7,6,9,8,10,16,17,22,23,28];
        
        % swap the electrodes for the righteeg epoch file, and then glue them
        % together
        for trodepair = 1:length(pairleft)
            electrodea = pairleft(trodepair);
            electrodeb = pairright(trodepair);
            
            tempdata = righteeg.data(electrodea,:,:);
            righteeg.data(electrodea,:,:) = righteeg.data(electrodeb,:,:) - righteeg.data(electrodea,:,:);
            righteeg.data(electrodeb,:,:) = tempdata - righteeg.data(electrodeb,:,:);
            
            tempdata = lefteeg.data(electrodea,:,:);
            lefteeg.data(electrodea,:,:) = lefteeg.data(electrodeb,:,:) - lefteeg.data(electrodea,:,:);
            lefteeg.data(electrodeb,:,:) = tempdata - lefteeg.data(electrodeb,:,:);
            
        end
        
        ourALLEEG(1) = lefteeg;
        ourALLEEG(2) = righteeg;
        mergedEEG = pop_mergeset( ourALLEEG, [1  2], 0);
        
        load chanlocs3
        
        mergedEEG.chanlocs = EEGchanlocs;
        
        for j = 1:length(mergedEEG.epoch)
            for i= 1:length(mergedEEG.epoch(j).eventtype)
                mergedEEG.epoch(j).eventtype{i} = num2str(mergedEEG.epoch(j).eventtype{i});
            end
        end
        
        epoched_filename = sprintf('epoched_subs/epochedsub%d%s.set',sub,nfilename);
        pop_saveset(mergedEEG, epoched_filename);
        
        binned_filename = sprintf('binned_subs/binnedsub%d%s.set',sub,nfilename);
        bin_info2EEG(epoched_filename,'binned_subs/bin_descriptor.txt',binned_filename);
    end
end

%this saves all the data into a matlab file
% if FilteredForAccuracy == 1
%     fname = 'alldataUnfilteredFalseTargets';
% else
%     fname = 'alldatamultiNOFILTER';
% end
dir_filename = sprintf('masterdata/%s',nfilename);
try
    save(dir_filename,'masterdata','sublist','nfilename');
end

%for (sub = sublist)
%filename = sprintf('%s_sub%d.set',fname,sub);
%specificdata = masterdata(sub,:,:,:);
%save(filename,'specificdata');
%end



