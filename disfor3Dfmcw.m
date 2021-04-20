function [xpos,ypos,zpos]=disfor3Dfmcw(filename,line)
%基本参数设置
    f0=16e3;
    f1=18.5e3;
    f2=21e3;
   
    B=2.5e3;
    T=0.04;
    fs=48e3;
   
    
    %互相关求对齐位置
    pos0=align(f0,B,T,fs,filename);
    %pos0
    pos1=align(f1,B,T,fs,filename);
    pos2=align(f2,B,T,fs,filename);
    
    %根据fmcw求距离
    dis0=dis1Dfmcw(f0,B,T,fs,filename,line,pos0);
    dis1=dis1Dfmcw(f1,B,T,fs,filename,line,pos1);
    dis2=dis1Dfmcw(f2,B,T,fs,filename,line,pos2);
    dis0=dis0-dis0(1);
    dis1=dis1-dis1(1);
    dis2=dis2-dis2(1);
    %figure;plot(dis0,"r.-");figure;plot(dis1,"r.-");figure;plot(dis2,"r.-");
    [xpos,ypos,zpos]=optimize_cal_pos(dis0,dis1,dis2,line);
    title("FMCW");
    %[xpos,ypos,zpos]=pure_cal_pos(dis0,dis1,dis2,line);
    hold off;
    figure;plot(xpos,ypos,"r.-");title("X-Y平面坐标变化");xlabel("X轴");ylabel("Y轴");
    figure;plot(xpos,zpos,"r.-");title("X-Z平面坐标变化");xlabel("X轴");ylabel("Z轴");
    figure;plot(ypos,zpos,"r.-");title("Y-Z平面坐标变化");xlabel("Y轴");ylabel("Z轴");
    
end