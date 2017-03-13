load alldataFilteredTargets
HEOL = [];
HEOR = [];
VEO = [];
for sub = 1:size(masterdata,1)
    for con = 1 % :size(masterdata,2)
        if size(masterdata{sub,con,30,1},1) == 750
            HEOL =[HEOL; masterdata{sub,con,30,1}'];
        else
            HEOL =[HEOL; masterdata{sub,con,30,1}];
        end
        
        if size(masterdata{sub,con,30,2},1)==750
            HEOR =[HEOR; masterdata{sub,con,30,2}'];
        else
            HEOR =[HEOR; masterdata{sub,con,30,2}];
        end
        
        if size(masterdata{sub,con,31,1},1) == 750
            VEO = [VEO; masterdata{sub,con,31,1}'];
         
        else
            VEO = [VEO; masterdata{sub,con,31,1}];
           
        end
        
        if size(masterdata{sub,con,31,2},1) == 750
            VEO = [VEO;masterdata{sub,con,31,2}'];
        else
            VEO = [VEO;masterdata{sub,con,31,2}];
        end
    end
end
x=[-1000:4:1996];
figure
title('HEO Channels over subs and cons')
plot(x,mean(HEOL))
hold on
plot(x,mean(HEOR))
ylim([-20 20])
legend('left','right')
hold off

figure
title('VEO Channels over subs and cons')
plot(x,mean(VEO),'b')