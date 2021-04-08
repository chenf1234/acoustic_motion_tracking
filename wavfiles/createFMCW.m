function res = createFMCW(f0, B, T, fs, n)
%f0--最小频率
%B--带宽
%fs--采样率
%T--周期
%n--chirp个数
    t=[0:1/fs:T-1/fs];
    phase=2*pi*(f0*t+B*(t.*t)/(2*T));%一个chirp的相位
    x=cos(phase);%一个chirp信号
    N=length(x);
    x=x.*hanning(N)';
    y=[];
    for i=1:n
        y=[y,x];
    end
    %画图
    %figure;
    %t1=[0:1/fs:n*T-1/fs];
    %subplot(2,1,1);
    %plot(t1,y);
    %subplot(2,1,2);
    %spectrogram(y,256,250,256,fs); 
    %title('FMCW');
    res=y;
    
end
