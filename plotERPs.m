function plotERPs(nfilename,load_unfiltered,load_ft,sublist,pair,condition)
global true_target FilteredForAccuracy which_cats cat_filt
[trueorfalse,cats_used,only_cat]=translate_parameters;
subpos=1:length(sublist);
md = sprintf('masterdata/%s',nfilename);
load(md)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%True Targets%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Unfiltered;
n_num = length(subpos);
condition = 1;
type = 1;
valid_subs = zeros(n_num,1);
for i = 1:length(masterdata(:,:,31,2))
    if length(masterdata{i,:,31,2})>0
        valid_subs(i) = 1;
    end
end
subpos=find(valid_subs==1);
subpos=subpos';
check_sub_nums = 0;
[tn tc ti pairname goodsubs trial_counts sum_counts] = plotmasterdata(masterdata,pair,condition,subpos,type,nfilename);
goodsubs = str2num(goodsubs);
nfilename=sprintf('n%d%s',goodsubs,nfilename(4:end));
%Translate x-axis to ms
x_axis = ((1:length(tn))*4)-1000;
%Calculate mean amplitude during 200ms-400ms window
mean_amp = mean(tn(300:350));
mean_amp = num2str(mean_amp);
%Plot data
figure
plot(x_axis,tn-5)
hold on
plot(x_axis,ti,'r')
plot(x_axis,tc,'c')
offset = 0;
axis([min(x_axis)+offset max(x_axis)-offset -8 8]);
if length(cat_filt)<1
fig_title = sprintf('%s - n%d - %d trials - pair %s - %s - mean amp: %s',trueorfalse,goodsubs,sum_counts,pairname,only_cat,mean_amp);
else
fig_title = sprintf('%s - n%d - %d trials - pair %s - %s - mean amp: %s',trueorfalse,goodsubs,sum_counts,pairname,cats_used,mean_amp);
end
title(fig_title)