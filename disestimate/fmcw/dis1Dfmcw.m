function dis=dis1Dfmcw(f0,B,T,fs,filename,line,pos)
%pos-对齐的位置
    f1=f0+B;%截止频率
  
    %读取接收数据
    
    yr=readfile(filename,line);%读取测试音频文件
    yr=yr';%对读取得到的文件进行转置，便于后续处理
    
    %利用pos对齐
    yr=firbandpass(f0,f1,yr,fs);
    
    yr=yr(pos:length(yr));
    
    %每一个chirp处理一次，即40ms处理一次
    c=340;%声音的传播速度
    
    fb=fmcwpeak(f0,B,T,fs,yr);
    %figure;plot(fb,"r.-");
    %计算距离,没有考虑速度的影响
    dis=fb*c*T/B;
  
    %使用卡尔曼滤波平滑
    dis=kalman_smooth(dis,1e-6,5e-5);
    dis=smoothdata(dis,"movmean",5);
    figure;plot(dis,"r.-");
    title("FMCW声波测距结果");

end