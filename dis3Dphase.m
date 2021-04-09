function [xpos,ypos,zpos]=dis3Dphase(filename,line)
    f0=15.2e3;
    f1=15.4e3;
    f2=15.6e3;
    fs=48e3;
    
    dis0=vernier_phase(filename,line,f0,fs,4000);
    dis1=vernier_phase(filename,line,f1,fs,4000);
    dis2=vernier_phase(filename,line,f2,fs,4000);
    
    [xpos,ypos,zpos]=optimize_cal_pos(dis0,dis1,dis2,line);
    
end