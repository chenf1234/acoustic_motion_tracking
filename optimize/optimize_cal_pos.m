function [xpos,ypos,zpos]=optimize_cal_pos(dis0,dis1,dis2,line)
    %初始位置
    speaker0=[0,0,0];
    speaker1=[0.8,0,0];
    speaker2=[0.8,0,-0.65];
    if line==1
        D2=0.6;
        D1=sqrt(D2^2+0.65^2);
        D0=sqrt(D1^2+0.8^2);
        micinit=[0.8,D2,-0.65];
    else
        D2=sqrt(0.6^2+0.16^2);
        D1=sqrt(0.6^2+(0.65-0.16)^2);
        D0=sqrt(D1^2+0.8^2);
        micinit=[0.8,0.6,-0.65+0.16];
    end
    mic=[micinit];
    N=min(length(dis0),min(length(dis1),length(dis2)));
    
    %带优化框架
    n=10;
    initdis=[D0,D1,D2];
    initpos=[speaker0;speaker1;speaker2];
    figure;
    for i=[1:n:N]
        
        lastpos=mic(end,:);
        dfmcw=[];
        if(i+n-1<=N)
            endpos=i+n-1;
        else endpos=N;end
        for j=i:endpos
            dfmcw=[dfmcw,dis0(j),dis1(j),dis2(j)];
        end
        xopt=optimize_in_pos(lastpos,dfmcw,initdis,initpos);
        for j=[1:3:length(xopt)]
            mic=[mic;[xopt(j),xopt(j+1),xopt(j+2)]];
        end
        xpos=mic(:,1)';
        ypos=mic(:,2)';
        zpos=mic(:,3)';
        plot3(xpos,ypos,zpos,"r.-");
        hold on;
        drawnow;
    end
    legend("手机麦克风运动轨迹",'Location','northoutside','fontsize',10);
end