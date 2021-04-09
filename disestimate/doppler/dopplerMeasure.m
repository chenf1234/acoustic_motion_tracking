function v=dopplerMeasure(filename,T,fs,center_f,line,pos)
%测量多普勒频移
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
    
    figure;
    plot(ft,"r.-");
    
    %去除异常值,平滑
    ft=hampel(ft);
    ft=smoothdata(ft,"movmean",5);
    figure;
    plot(ft,"b.-");
    c=346;%声音传播速度
    v=ft*c/center_f;
    %figure;
    %plot(v,"r.-");
    %ylabel("velocity");
    
    
    
end