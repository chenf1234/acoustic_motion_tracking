function x=firlowpass(f0,y,fs)
    fcuts=[f0 f0+50];
    mags = [1 0];
    devs = [0.5 0.1];
    [n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fs);
    
    b = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
    %b =fir1(48,f0/(fs/2),"low");
    %freqz(b,1,1024,fs);
    %[h,w] = freqz(b,1,1024,fs);
    %h=20*log10(abs(h));
    %figure;plot(w,h);title('所设计滤波器的通带曲线');grid on;
    x=filter(b,1,y);
    %x=filtfilt(b,1,y);
end