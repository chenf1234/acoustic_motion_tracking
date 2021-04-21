function [xpos,ypos,zpos]=dis3Dfmcw_phase(filename,line)
%基本参数设置
    f0=16e3;
    f1=18.5e3;
    f2=21e3;
    f3=14e3;
    f4=14.6e3;
    f5=15.2e3;
    n=3;
    B=2.5e3;
    T=0.04;
    fs=48e3;
    
    %互相关求对齐位置
    pos0=align(f0,B,T,fs,filename);
    pos1=align(f1,B,T,fs,filename);
    pos2=align(f2,B,T,fs,filename);
    
    %根据fmcw求距离
    dis0f=dis1Dfmcw(f0,B,T,fs,filename,line,pos0);
    dis1f=dis1Dfmcw(f1,B,T,fs,filename,line,pos1);
    dis2f=dis1Dfmcw(f2,B,T,fs,filename,line,pos2);
    dis0f=dis0f-dis0f(1);
    dis1f=dis1f-dis1f(1);
    dis2f=dis2f-dis2f(1);
   % figure;plot(dis0f,"r.-");ylabel("distance variation(m)");title("FMCW声波测距结果");
   % figure;plot(dis1f,"r.-");ylabel("distance variation(m)");title("FMCW声波测距结果");
   % figure;plot(dis2f,"r.-");ylabel("distance variation(m)");title("FMCW声波测距结果");
    %根据相位求距离
    dis0p=[];
    dis1p=[];
    dis2p=[];
    for i=[0:n-1]
        f30=f3+i*200;
        f40=f4+i*200;
        f50=f5+i*200;
        dis0p=[dis0p;LLAP_phase(filename,line,f30,fs,pos0)];
        dis1p=[dis1p;LLAP_phase(filename,line,f40,fs,pos1)];
        dis2p=[dis2p;LLAP_phase(filename,line,f50,fs,pos2)];
    end
    dis0p=sum(dis0p,1)/n;
    dis1p=sum(dis1p,1)/n;
    dis2p=sum(dis2p,1)/n;
   % figure;plot(dis0p,"r.-");ylabel("distance variation(m)");title("取单频正弦波相位测距结果");
   % figure;plot(dis1p,"r.-");ylabel("distance variation(m)");title("取单频正弦波相位测距结果");
   % figure;plot(dis2p,"r.-");ylabel("distance variation(m)");title("取单频正弦波相位测距结果");
    [xpos,ypos,zpos]=optimize_cal_pos_v2(dis0f,dis1f,dis2f,dis0p,dis1p,dis2p,line);
    title("FMCW+phase");
    hold off;
    figure;plot(xpos,ypos,"r.-");title("X-Y平面坐标变化");xlabel("X轴");ylabel("Y轴");axis equal;
    figure;plot(xpos,zpos,"r.-");title("X-Z平面坐标变化");xlabel("X轴");ylabel("Z轴");axis equal;
    figure;plot(ypos,zpos,"r.-");title("Y-Z平面坐标变化");xlabel("Y轴");ylabel("Z轴");axis equal;
end