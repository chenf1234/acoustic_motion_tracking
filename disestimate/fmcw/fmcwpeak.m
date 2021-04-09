function fb=fmcwpeak(f0,B,T,fs,yr)
%利用传统fmcw峰值的办法求频率差
    n=ceil(length(yr)/(T*fs));
    ys=createFMCW(f0,B,T,fs,n+1);
    ys=ys(fs*T/8:end);
    ys=ys(1:length(yr));
    ym=yr.*ys;
    N=length(ym);
    %滤除高频部分
    
    ym=firlowpass(B,ym,fs);
    fftNum=fs*T;
    fb=[];
    tmp=ym(1:10*fs*T);
    tmp=[tmp,zeros(1,fs-length(tmp))];
    [freq,ampl]=frequencyAnalysis(tmp,fs);%用10个chirp的数据估测第一个峰值
    [maxval,index]=max(abs(ampl));
    
    [pks,locs]=findpeaks(abs(ampl),"MinPeakHeight",0.6*maxval);
    fb=[freq(locs(1))];%还是得用第一个峰值
    
    for i=1:fftNum:N
        if(i+fftNum-1>N)
            break
        end
        
        tmp=ym(i:i+fftNum-1);
        tmp=[tmp,zeros(1,fs-length(tmp))];%在数据后面补0，提高分辨率
        
        %根据上一个chirp的峰值，当前chirp的峰值位于[fp(i-1)-5,fp(i-1)+5]的范围内
        %使用带通滤波器保留该范围的频率，提高峰值预测的准确度
        
        flow1=fb(end)-5;
        flow2=fb(end)+5;
        if(flow1<51)
            flow1=51;
            flow2=61;
        end
        
        tmp=firbandpass(flow1,flow2,tmp,fs);
        tmp=firbandpass(flow1,flow2,tmp,fs);
        
        [freq,ampl]=frequencyAnalysis(tmp,fs);
        
        [maxval,index]=max(abs(ampl));
        [pks,locs]=findpeaks(abs(ampl),"MinPeakHeight",0.4*maxval);

        fb1=freq(locs(1));%使用第一个峰值而不是最大值
        fb=[fb,fb1];
 
    end
    
    fb=fb(2:end);
    
end