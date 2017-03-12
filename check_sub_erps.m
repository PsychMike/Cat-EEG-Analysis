function check_sub_erps
for sub = [20:32,35,37:39,41:48]
    pair = 3;
    condition = 1;
    type = 1;
    num_of_subs = 1;
    FilteredForAccuracy = 1;
    true_target = FilteredForAccuracy;
    which_cats = 3;
    nfilename = sprintf('n%dacc%dtt%dcf%dsub%d',num_of_subs,FilteredForAccuracy,true_target,which_cats,sub);
    subpos=1;
    md = sprintf('masterdata/%s',nfilename);
    load(md)
    [tn tc ti pairname goodsubs trial_counts] = plotmasterdata(masterdata,pair,condition,subpos,type,nfilename);
    try
    x_axis = ((1:length(tn))*4)-1000;
    figure
    plot(x_axis,tn-5)
    hold on
    plot(x_axis,ti,'r')
    plot(x_axis,tc,'c')
    offset = 900;
    axis([min(x_axis)+offset max(x_axis)-offset -10 10]);
translate_parameters;
    fig_title = sprintf('Subject %d - %s - %s - %d trials',sub,which_cats,true_target,trial_counts);
    title(fig_title)
    input('press enter to continue')
    end
end