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
    %[xpos,ypos,zpos]=pure_cal_pos(dis0,dis1,dis2,line);
    
    
end