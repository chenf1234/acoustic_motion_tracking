function pos=align_min(f0,B,T,fs,filename,line,num)
%利用互相关进行对齐
    f1=f0+B;%截止频率
    %读取接收数据
    yr=readfile(filename,line);%读取测试音频文件
    yr=yr';%对读取得到的文件进行转置，便于后续处理
    yr=firbandpass(f0,f1,yr,fs);
    
    t=[0:1/fs:T-1/fs];
    phase=2*pi*(f0*t+B*(t.*t)/(2*T));%一个chirp的相位
    x=cos(phase);%一个chirp信号
    
    y=yr(1:num*fs*T);
    [c,lags]=xcorr(y,x);
    [~,index]=max(c);
    pos=lags(index);
end