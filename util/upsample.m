function [x,fs]=upsample(y,f,fs,n1)
%上采样，将采样率变为原来的(n1+1)倍
%新采样率
     fs=fs*(n1+1);
%方法1：按照原理来
    %step1：插值
    tmp=[];
    for i=[1:length(y)]
        tmp=[tmp,y(i),zeros(1,n1)];
    end
 
    %step2：低通滤波，使用fir滤波器
    fcuts=[f f+100];
    mags = [1 0];
    devs = [0.05 0.01];
    %[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fs);
    %b = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
    %x = filter(b,1,tmp);
    
    %step2：低通滤波，使用matlab自带的lowpass滤波器，效果比自己写的fir滤波器好，和resample效果差不多
    x=lowpass(tmp,f,fs);
    
%方法2：直接使用matlab自带的resample函数,效果比方法1好得多
    
    %x=resample(y,n1+1,1);
    
end