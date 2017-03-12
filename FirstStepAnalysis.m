function FirstStepAnalysis(sublist,checking_subs,excluded_sub)
global pair condition load_unfiltered load_ft gnd plot_erp perm anova true_target FilteredForAccuracy which_cats cat_filt category_names
category_names = {'Art supply';'Bird';'Body part';'Dessert';'Dinner food';'Four-footed animal';'Fruit';'Furniture';'Kitchenware';'Musical instrument';'Office equipment';'Sports equipment';'Toy';'Vegetable';'Vehicle';'Weapon'};
%ENTER SUBJECTS YOU WANT TO LOOK AT
sublist = [20:32,35,37:39,41:48];
num_of_subs = length(sublist);
%Organize EEG data. Set run_batcherp to 1 to run batcherp, 0
%if already ran.
run_batcherp = 0;
%Enter the electrode pair you want to look at:
%1 = O1O2, 2 = P3P4, 3 = P7P8, 4 = CP3CP4, 5 = TP7TP8, 6 = C3C4, 7 = T7T8, 8 = FC3FC4, 9 = FT7FT8, 10 = F3F4, 11 = F7F8, 12 = FP1FP2
pair = 3;
%Plot ERP's?
plot_erp = 0;
%Only one condition
condition = 1;
%Generate GND?; %Run permutation analysis?; %Run ANOVA?
gnd = 1;perm = 0;anova = 0;
%Which pair of electrodes?
pair = 2;
%True targs = 1, False targs = 0
for true_target = 1;
    %Filter for accuracy?
    for FilteredForAccuracy = true_target;
        %Filter by which category?...
        for which_cats = 3; %1 = best, 2 = worst, 3 = all, 4 = specify
            if which_cats == 1
                cat_filt = [2,3,4,5,6,7,10,15]; %best
            elseif which_cats == 2
                cat_filt = [1,8,9,11,12,13,14,16]; %worst
            elseif which_cats == 3
                cat_filt = [1:16]; %all cats
            else
                cat_filt = [1,2,4:16]; %any cats you want to include
            end
            %Builds filename
            if num_of_subs == 1
                nfilename = sprintf('n%dacc%dtt%dcf%dsub%d',num_of_subs,FilteredForAccuracy,true_target,which_cats,sublist);
            else
                nfilename = sprintf('n%dacc%dtt%dcf%dsub%d',num_of_subs,FilteredForAccuracy,true_target,which_cats,0);
            end
            real_file = sprintf('masterdata/%s',nfilename);
            %         if exist(real_file)>0
            %             proceed=input('Batcherp was already ran with these parameters. Press "1" if you intend to overwrite the existing file.')
            %             if proceed~=1
            %                 error('Stopped batcherp to avoid overwrite.')
            %             end
            %         end
            if run_batcherp
                batcherp_2(sublist,FilteredForAccuracy,true_target,cat_filt,nfilename)
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
                plotERPs(nfilename,load_unfiltered,load_ft,sublist,pair,condition)
            end
            if perm
                PermTestContraVIpsi
            end
            if anova
                ANOVAfor2ndN2pc(nfilename,pair)
            end
        end
    end
%     input('enter');
end