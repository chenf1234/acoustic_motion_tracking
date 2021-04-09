function [xpos,ypos,zpos]=dis3Dfmcw_phase(filename,line)
%基本参数设置
    f0=16e3;
    f1=18.5e3;
    f2=21e3;
    f3=15.2e3;
    f4=15.4e3;
    f5=15.6e3;
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
    
    %根据相位求距离
    dis0p=vernier_phase(filename,line,f3,fs,pos0);
    dis1p=vernier_phase(filename,line,f4,fs,pos1);
    dis2p=vernier_phase(filename,line,f5,fs,pos2);
    
    [xpos,ypos,zpos]=optimize_cal_pos_v2(dis0f,dis1f,dis2f,dis0p,dis1p,dis2p,line);
end