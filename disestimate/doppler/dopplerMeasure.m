function v=dopplerMeasure(filename,T,fs,center_f,line,pos)
%测量一个频率对应的多普勒频移
%center_f:中心频率
    data=readfile(filename,line);
    data=data';
    %带通滤波
    data=firbandpass(center_f-100,center_f+100,data,fs);
    data=data(pos:end);
    
    %[f,a]=frequencyAnalysis(data,fs);
    %FFTplot(f,a);
    %利用STFT求出频率随时间的变化
    ft=STFT(data,fs,T);
    
    %计算多普勒频移
    ft=ft-center_f;
    
    %去除异常值,平滑
    ft=hampel(ft);
    ft=kalman_smooth(ft,1e-5,1e-3);
    ft=smoothdata(ft,"gaussian",5);
    
    c=340;%声音传播速度
    v=ft*c/center_f;
    figure;
    plot(v,"r.-");
    
    ylabel("velocity(m/s)");title("velocity based on doppler");
end