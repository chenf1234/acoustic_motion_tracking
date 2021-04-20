function [xpos,ypos,zpos]=dis3Dphase(filename,line)
    f0=14e3;
    f1=14.6e3;
    f2=15.2e3;
    n=3;
    fs=48e3;
    
    dis0=[];
    dis1=[];
    dis2=[];
    for i=[0:n-1]
        f30=f0+i*200;
        f40=f1+i*200;
        f50=f2+i*200;
        dis0=[dis0;LLAP_phase(filename,line,f30,fs,0)];
        dis1=[dis1;LLAP_phase(filename,line,f40,fs,0)];
        dis2=[dis2;LLAP_phase(filename,line,f50,fs,0)];
    end
    dis0=sum(dis0,1)/n;
    dis1=sum(dis1,1)/n;
    dis2=sum(dis2,1)/n;
   % figure;plot(dis0p,"r.-");ylabel("distance variation(m)");title("取单频正弦波相位测距结果");
   % figure;plot(dis1p,"r.-");ylabel("distance variation(m)");title("取单频正弦波相位测距结果");
   % figure;plot(dis2p,"r.-");ylabel("distance variation(m)");title("取单频正弦波相位测距结果");
    
    [xpos,ypos,zpos]=optimize_cal_pos(dis0,dis1,dis2,line);
    title("phase");
    hold off;
    figure;plot(xpos,ypos,"r.-");title("X-Y平面坐标变化");xlabel("X轴");ylabel("Y轴");
    figure;plot(xpos,zpos,"r.-");title("X-Z平面坐标变化");xlabel("X轴");ylabel("Z轴");
    figure;plot(ypos,zpos,"r.-");title("Y-Z平面坐标变化");xlabel("Y轴");ylabel("Z轴");
end