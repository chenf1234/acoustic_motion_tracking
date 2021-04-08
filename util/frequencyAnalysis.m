function [freq,amplitude]=frequencyAnalysis(y,fs)
%y--时域信号
%fs--采样率
    x=fft(y);%对声音信号进行快速傅里叶变换
    N=length(y);
    x=x/N;%幅值修正
    f1=[0:(fs/N):fs/2-fs/N];%转换横坐标以Hz为单位
    x=x(1:length(f1));%选取前半部分，因为fft之后为对称的双边谱
    x(2:end)=2*x(2:end);
    amplitude=x;
    freq=f1;
    %画图
    %figure;subplot(2,1,1);
    %plot(f1,abs(x));xlabel('Frequency(Hz)');
    %subplot(2,1,2);
    %plot([0:length(y)-1]/fs,y);xlabel('Time(s)');
end