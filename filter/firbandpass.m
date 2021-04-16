function x=firbandpass(f1,f2,y,fs)
%Kaiser窗FIR滤波器
    
    fcuts=[f1-50 f1 f2 f2+50];
    mags = [0 1 0];
    devs = [0.1 0.5 0.1];
    [n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fs);
    %disp(ftype);
    b = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
    %b = fir1(40,[f1 f2]/(fs/2),"bandpass");
    %freqz(b,1,1024,fs);
    %[h,w] = freqz(b,1,1024,fs);
    %h=20*log10(abs(h));
    %figure;plot(w,h);title('所设计滤波器的通带曲线');grid on;
    x=filter(b,1,y);
end