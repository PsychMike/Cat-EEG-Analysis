function [all_tns]=plotERPs(nfilename,load_unfiltered,load_ft,sublist,pair,condition,cat_filt,all_tns)
global true_target FilteredForAccuracy which_cats cat_filt mean_amp
% [trueorfalse,cats_used,only_cat]=translate_parameters;
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
if goodsubs > 0
    %     try
    nfilename=sprintf('n%d%s',goodsubs,nfilename(4:end));
    %Translate x-axis to ms
    x_axis = ((1:length(tn))*4)-1000;
    %Calculate mean amplitude during 200ms-300ms window
    %         mean_amp(cat_filt) = mean(tn(300:325));
    %         if cat_filt == 16
    %             save('cat_mean_amps_FTs','mean_amp');
    %         end
    %         mean_amp = num2str(mean_amp);
    csv_filename = sprintf('csv_outs/%s.csv',nfilename);
    try
        all_tns(:,cat_filt)=tn;
    catch
        keyboard
    end
    if cat_filt == 16
        csvwrite('all_n2pcs.csv',all_tns);
    end
    try
        %Plot data
        figure
        plot(x_axis,tn-5)
        hold on
        plot(x_axis,ti,'r')
        plot(x_axis,tc,'c')
        offset = 0;
        axis([min(x_axis)+offset max(x_axis)-offset -8 8]);
        %         if cat_filt>0
        %             fig_title = sprintf('%s - n%d - %d trials - pair %s - %s - mean amp: %s',trueorfalse,goodsubs,sum_counts,pairname,only_cat,mean_amp);
        %         else
        %             fig_title = sprintf('%s - n%d - %d trials - pair %s - %s - mean amp: %s',trueorfalse,goodsubs,sum_counts,pairname,cats_used,mean_amp);
        %         end
        fig_title = sprintf('%s',nfilename);
        title(fig_title)
        %     fig_folder = sprintf('figures/%s',nfilename);
        %     savefig(fig_folder);
        %     end
    catch
        keyboard
    end
end