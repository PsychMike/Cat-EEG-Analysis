function FirstStepAnalysis(sublist,checking_subs,excluded_sub)
%ENTER SUBJECTS YOU WANT TO LOOK AT
sublist = [20:32,35,37:39,41:48];
    num_of_subs = length(sublist);
    %Enter the electrode pair you want to look at:
    %1 = O1O2, 2 = P3P4, 3 = P7P8, 4 = CP3CP4, 5 = TP7TP8, 6 = C3C4, 7 = T7T8, 8 = FC3FC4, 9 = FT7FT8, 10 = F3F4, 11 = F7F8, 12 = FP1FP2
    pair = 3;
    %Only one condition
    condition = 1;
    %Set to 1 if you want to check how many subs made it through filtering per condition
    check_sub_nums = 0;
    %This loads in the data that have been all nicely organized by batcherp. It comes either filtered for accuracy or not depending on whether load_unfiltered is set to 0 or 1.
    load_unfiltered = 0;
    %Load false targets?
    load_ft = 0;
    %Generate GND?
    gnd = 0;
    %Plot ERP's?
    plot_erp = 0;
    %Run permutation analysis?
    perm = 0;
    %Run ANOVA?
    anova = 0;
    %Which pair of electrodes?
    pair = 3;
    %Organize EEG data. Set run_batcherp to 1 to run batcherp (takes awhile), 0
    %if already ran.
    run_batcherp = 1;
    %True targs = 1, False targs = 0
    for true_target = 1
        %Filter for accuracy?
        FilteredForAccuracy = true_target;
        %Filter by which category?...
        for which_cats = 1:3 %1 = best, 2 = worst, 3 = specify
            if which_cats
                cat_filt = [2,3,4,5,6,7,10,15]; %best
            elseif which_cats == 2
                cat_filt = [1,8,9,11,12,13,14,16]; %worst
            else
                cat_filt = [1:16]; %any cats you want to include
            end
            %Builds filename
            nfilename = sprintf('n%dacc%dtt%dcf%dsub%d',num_of_subs,FilteredForAccuracy,true_target,which_cats,sublist);
            if run_batcherp
                batcherp_2(1,sublist,FilteredForAccuracy,true_target,cat_filt,nfilename)
            else
                message = 'Not running batcherp'
            end
            if gnd
                %Creates CSV file with set names
                binned_names = {};
                for i = 1:length(sublist)
                    sub = sublist(i);
                    cond = 1;
                    binned_names{i,cond} = sprintf('binned_subs/binnedsub%d%s.set',sub,nfilename);
                end
                GND = sets2GND(binned_names,'exclude_chans',{'M1','HEO','VEO'},'out_fname',nfilename);
            end
            if plot_erp
                plotERPs(nfilename,check_sub_nums,load_unfiltered,load_ft,sublist,pair,condition)
            end
        end
    end
    if perm
        PermTestContraVIpsi
    end
    if anova
        ANOVAfor2ndN2pc(nfilename,pair)
    end