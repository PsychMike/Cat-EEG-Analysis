function batchresults = batchanalysis_blank()

%Image RSVP batchanalysis script written by Michael Hess, May '16

% %This code compensates for your operation systems preferences when accessing data files.
% if IsOSX    %On a Mac or PC, choose the right data directory
%     datadir='data/';
% else
    datadir='data\';
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Define data to be analyzed

%Add in the subject numbers of the data files that you wish to analyze:
    subnumlist = [20:32,35,37:39,41:48];
numsubs = length(subnumlist);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Begin Analysis

%Rater number
rater = 1;
correct_count = 1; %count of correct trials
total_count = 1; %count of all trials
%Loops through all of the subjects' data files
for sub_length = 1:numsubs
    sprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    sub = subnumlist(sub_length);
    subject = sub %outputs subject number
    
    datafilename = sprintf('%sExpSub_compact_%d_judged%d.mat',datadir,sub,rater);
    
    Userdata = load(datafilename);
    Userdata = Userdata.Userdata;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Block #1 Analysis
    
    %Analysis of block #1  (there is only one block in this data file
    block = 1;
    
    numtrials = length(Userdata.Blocks(block).Trials)-3;
    
    correct_trials = 0; %reset correct trial count for each subject
    
    trial_count = 0; %counts # of single target trials
    
    %Loop through all of the trials in this block
    for trial = 4:numtrials
        
        trial_count = trial_count + 1;
        
        %Importing rater responses
        user_review_item = Userdata.Blocks.Trials(trial).Trial_Export.review_item;
        
        %Importing which target category
        target_category = Userdata.Blocks.Trials(trial).Trial_Export.which_targ_category;
        
        %Importing which target
        target = Userdata.Blocks.Trials(trial).Trial_Export.which_targ;
        
        if strcmp(user_review_item,'y')
            correct_trials = correct_trials + 1;
            
            category_array(correct_count) = target_category;
            
            correct_target_count(correct_count,target_category) = target;
            
            correct_count = correct_count + 1;
        end
        
        category_count(total_count) = target_category;
        
        total_target_count(total_count,target_category) = target;
        
        total_count = total_count + 1;
        
        if trial == numtrials
            correct_trials %outputs number of correct trials
        end
    end
    subject_accuracy = (correct_trials/(trial_count))*100
    total_accuracy(sub_length) = subject_accuracy;
    if subject == subnumlist(numsubs);
        if trial == numtrials
            sprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
            %             average_accuracy = sum(total_accuracy)/numsubs %outputs average accuracy of all subs
            %             min_accuracy = min(total_accuracy) %outputs min accuracy
            %             max_accuracy = max(total_accuracy) %outputs max accuracy
            %             x = size(correct) %check size of correct trial output
            %             csvwrite('sub_correct_trials',correct)
            %             save('correct_trials','correct');
        end
    end
end
for i = 1:16
    accurate(i) = sum(category_array(:)==i);
    total(i) = sum(category_count(:)==i);
end
    category_names = {'Art supply';'Bird';'Body part';'Dessert';'Dinner food';'Four-footed animal';'Fruit';'Furniture';'Kitchenware';'Musical instrument';'Office equipment';'Sports equipment';'Toy';'Vegetable';'Vehicle';'Weapon'};
    reshape(category_names,[1,16])
category_accuracy = accurate./total
c = 0;
for i = 1:16
    median_cat_accuracy = median(category_accuracy);
    if category_accuracy(i) >= median_cat_accuracy
        c = c + 1;
        top_cats(c) = i;
    end
end
for i = 1:length(top_cats)
    switch top_cats(i)
        case(1)
            best_cats{i} = 'Art supply';
        case(2)
            best_cats{i} = 'Bird';
        case(3)
            best_cats{i} = 'Body part';
        case(4)
            best_cats{i} = 'Dessert';
        case(5)
            best_cats{i} = 'Dinner food';
        case(6)
            best_cats{i} = 'Four-footed animal';
        case(7)
            best_cats{i} = 'Fruit';
        case(8)
            best_cats{i} = 'Furniture';
        case(9)
            best_cats{i} = 'Kitchenware';
        case(10)
            best_cats{i} = 'Musical instrument';
        case(11)
            best_cats{i} = 'Office equipment';
        case(12)
            best_cats{i} = 'Sports equipment';
        case(13)
            best_cats{i} = 'Toy';
        case(14)
            best_cats{i} = 'Vegetable';
        case(15)
            best_cats{i} = 'Vehicle';
        case(16)
            best_cats{i} = 'Weapon';
    end
end
best_cats
% save top_cats
median_sub_accuracy = median(total_accuracy)
for i=1:length(category_accuracy)
a=category_accuracy(i)-(median_sub_accuracy*.01);
b=abs(a);
close(i) = b;
closer = sort(close);
closest = closer(1:8);
end
category_accuracy_graph = bar(category_accuracy)
title('Category Accuracy');

for t = 1:24
    for i = 1:16
        
        target_correct_column = (correct_target_count(:,i));
        target_correct_column = num2str(target_correct_column);
        target_correct_column = cellstr(target_correct_column);
        target_correct_column = target_correct_column(~cellfun('isempty',target_correct_column));
        target_correct_column = cell2mat(target_correct_column);
        target_correct_column = str2num(target_correct_column);
        
        target_count_column = (total_target_count(:,i));
        target_count_column = num2str(target_count_column);
        target_count_column = cellstr(target_count_column);
        target_count_column = target_count_column(~cellfun('isempty',target_count_column));
        target_count_column = cell2mat(target_count_column);
        target_count_column = str2num(target_count_column);
        
        target_count(t,i) = sum(target_count_column==1);
        
        target_correct(t,i) = sum(target_correct_column==1);
        
        target_accuracy(t,i) = (target_correct(t,i))/(target_count(t,i));
    end
end
targ_scores = target_accuracy
target_accuracy_mean = mean(mean(targ_scores))
half_mean = target_accuracy_mean/2;

for i = 1:64
    if targ_scores(i) >= target_accuracy_mean
        top_targs(i) = 1;
        bottom_targs(i) = 0;
    else
        top_targs(i) = 0;
        bottom_targs(i) = 1;
    end
    if targ_scores(i) >= half_mean
        very_bottom_targs(i) = 0;
    else
        very_bottom_targs(i) = 1;
    end
end
cd ..

category_names = {'Art supply';'Bird';'Body part';'Dessert';'Dinner food';'Four-footed animal';'Fruit';'Furniture';'Kitchenware';'Musical instrument';'Office equipment';'Sports equipment';'Toy';'Vegetable';'Vehicle';'Weapon'};

%Targets
for targ_set = 1:length(category_names);
    for x = 1 : 24
        cat = category_names{targ_set};
        stim_dir = dir(sprintf('Stimuli/%s',cat));
        targets{x} = sprintf('%s/%s',cat,stim_dir(x+2).name);
    end
end

which_targs = 1; %1 = top_targs, 2 = bottom_targs, 3 = very_bottom_targs

targ_count = 0;
if which_targs == 1
    for i = 1:length(targets)
        if top_targs(i) == 1
            targ_count = targ_count + 1;
            best_targs{targ_count} = targets{i};
        end
    end
    best_targs
    %= reshape(top_targs,8,24)
%     save top_targs
elseif which_targs == 2
    for i = 1:length(targets)
        if bottom_targs(i) == 1
            targ_count = targ_count + 1;
            worst_targs{targ_count} = targets{i};
        end
    end
    worst_targs
    %= reshape(bottom_targs,8,24)
else
    for i = 1:length(targets)
        if very_bottom_targs(i) == 1
            targ_count = targ_count + 1;
            very_worst_targs{targ_count} = targets{i};
        end
    end
    very_worst_targs
    %= reshape(very_bottom_targs,8,24)
end
cat_accuracy_worst2best = sort(category_accuracy)
cd Analysis