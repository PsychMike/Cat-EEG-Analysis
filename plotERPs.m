function plotERPs(nfilename,check_sub_nums,load_unfiltered,load_ft,sublist,pair,condition)
sublist = [20:32,35,37:39,41:48];
subpos=1:length(sublist);
md = sprintf('masterdata/%s',nfilename);
load(md)
category_names = {'Art supply';'Bird';'Body part';'Dessert';'Dinner food';'Four-footed animal';'Fruit';'Furniture';'Kitchenware';'Musical instrument';'Office equipment';'Sports equipment';'Toy';'Vegetable';'Vehicle';'Weapon'};
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
if check_sub_nums
    input('press enter to continue')
end
goodsubs = str2num(goodsubs);
nfilename=sprintf('n%d%s',goodsubs,nfilename(4:end));
% cat_n2pc{cat_num} = tn;
% mean_amp(cat_num) = mean(cat_n2pc{cat_num}(300:325));
% tn=(tn+1000)/3;
% ti=(ti+1000)/3;
% tc=(tc+1000)/3;
x_axis = ((1:length(tn))*4)-1000;
figure
plot(x_axis,tn-5)
hold on
plot(x_axis,ti,'r')
plot(x_axis,tc,'c')
offset = 900;
axis([min(x_axis)+offset max(x_axis)-offset -8 8]);
fig_title = sprintf('%d trials - pair %s - %s',sum_counts,pairname,nfilename);
title(fig_title)
% input('press enter to continue')
end
% mean_amp

% figure
% plot(tn-5)
% hold on
% plot(ti,'r')
% plot(tc,'c')
% axis([0 800 -8 4]);
% fig_title = sprintf('Accurate Targets - %s, N=%s, incl_cat#d, excl_sub# %d',pairname,goodsubs,cat_num,sub_num);
% title(fig_title)
% input('press enter to continue')
% end
% % Category filtered
% load filt1truetarg1catfilt1
% type = 2;
% [tn tc ti pairname goodsubs] = plotmasterdata(masterdata,pair,condition,subpos,type,nfilename);
% if check_sub_nums
% input('press enter to continue')
% end
% figure
% plot(tn-5)
% hold on
% plot(ti,'r')
% plot(tc,'c')
% axis([0 800 -8 4]);
% type = sprintf('Accurate Targets (Cat Filt) %s, N=%s',pairname,goodsubs);
% title(type)
%
% %Item filtered
% load filt1truetarg1itemfilt1
% type = 3;
% [tn tc ti pairname goodsubs] = plotmasterdata(masterdata,pair,condition,subpos,type,nfilename);
% if check_sub_nums
% input('press enter to continue')
% end
% figure
% plot(tn-5)
% hold on
% plot(ti,'r')
% plot(tc,'c')
% type = sprintf('Accurate Targets (Item Filt) %s, N=%s',pairname,goodsubs);
% title(type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%False Targets%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if load_ft
%Unfiltered
% load 'masterdata/n25_excl_sub#0_filt1truetarg0catfilt0.mat';
% [ftn ftc fti] = plotmasterdata(masterdata,pair,condition,subpos,type,nfilename);
% if check_sub_nums
% input('press enter to continue')
% end
% figure
% plot(ftn-5)
% hold on
% plot(fti,'r')
% plot(ftc,'c')
% axis([0 800 -8 4]);
% type = sprintf('Accurate FT''s - %s, N=%s',pairname,goodsubs);
% title(type)

% %Category filtered
% load filt1truetarg0catfilt1
% [ftn ftc fti] = plotmasterdata(masterdata,pair,condition,subpos,type,nfilename);
% if check_sub_nums
% input('press enter to continue')
% end
% figure
% plot(ftn-5)
% hold on
% plot(fti,'r')
% plot(ftc,'c')
% axis([0 800 -8 4]);
% type = sprintf('Accurate FT''s (Cat Filt) %s, N=%s',pairname,goodsubs);
% title(type)

% %Item filtered
% load filt1truetarg0itemfilt1
% [ftn ftc fti] = plotmasterdata(masterdata,pair,condition,subpos,nfilename);
% if check_sub_nums
% input('press enter to continue')
% end
% figure
% plot(ftn-5)
% hold on
% plot(fti,'r')
% plot(ftc,'c')
% title 'Accurate False Targets (Item Filt)'
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Unfiltered for Accuracy%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if load_unfiltered
%     load alldataUnfilteredTargets
%     [utn utc uti] = plotmasterdata(masterdata,pair,condition,subpos,type,nfilename);
%     load alldataUnfilteredFalseTargets
%     [uftn uftc ufti] = plotmasterdata(masterdata,pair,condition,subpos,type,nfilename);
%     figure
%     plot(utn-5)
%     hold on
%     plot(uti,'r')
%     plot(utc,'c')
%     title 'Unfiltered Targets'
%     figure
%     plot(uftn-5)
%     hold on
%     plot(ufti,'r')
%     plot(uftc,'c')
%     title 'Unfiltered False Targets'
% end