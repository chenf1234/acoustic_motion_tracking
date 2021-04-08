function yr=myhighpass(wp,y,fs)
%高通滤波器,采用切比雪夫I型
    rp=1;
    rs=30;
    ws=wp-200;
    [n,wn]=cheb1ord(wp/(fs/2),ws/(fs/2),rp,rs);
    [bz1,az1]=cheby1(n,rp,wp/(fs/2),"high");
    %查看设计滤波器的曲线
    %freqz(bz1,az1,256,fs);
    %[h,w]=freqz(bz1,az1,256,fs);
    %h=20*log10(abs(h));
    %figure;plot(w,h);title('所设计滤波器的通带曲线');grid on;
    yr=filter(bz1,az1,y);
end