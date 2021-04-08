function yr=mylowpass(wp,y,fs)
%低通滤波器,采用巴特沃斯模拟滤波器设计
%ws:阻带截止频率
%wp:通带截止频率
%rp:通道波纹
%rs:阻带衰减

    ws=wp+200;
    rp=1;
    rs=20;
    [n,wn]=buttord(wp/(fs/2),ws/(fs/2),rp,rs);
    [b,a]=butter(n,wn);
    yr=filter(b,a,y);
    %freqz(b,a,256,fs);%做出H(z)的幅频、相频图
    %[h,w]=freqz(b,a,512,fs);%做出H(z)的幅频、相频图
    %h=20*log10(abs(h));
    %figure;plot(w,h);title('所设计滤波器的通带曲线');grid on;
end