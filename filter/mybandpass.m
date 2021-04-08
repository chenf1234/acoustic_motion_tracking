function yr=mybandpass(f1,f2,y,fs)
%带通滤波器,采用巴特沃斯模拟滤波器设计
    rp=5;
    rs=7;
    wp=[f1 f2]/(fs/2);
    ws=[f1-50 f2+50]/(fs/2);
    [n,wp]=cheb2ord(wp,ws,rp,rs);
    [b,a]=cheby1(n,rp,wp,'bandpass');
    %
    %freqz(b,a,256,fs);
    % [h,w]=freqz(b,a,256,fs);
    % h=20*log10(abs(h));
    % figure;plot(w,h);title('所设计滤波器的通带曲线');grid on;
    yr=filter(b,a,y);
end