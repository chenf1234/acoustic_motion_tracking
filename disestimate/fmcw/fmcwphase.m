function dis=fmcwphase(filename,line,f0,fs,B,T)
%使用fmcw的相位,millisonic复现
%最后结论，论文不详细，源码没注释看不懂，复现不出来

    %读取数据并滤波
    f1=f0+B;%截止频率
    yr=readfile(filename,line);
    yr=yr';
    yr=firbandpass(f0,f1,yr,fs);
    %自相关获取接收端chirp开始的位置
    pos=align(f0,B,T,fs,filename);
    %yr=yr(pos:end);
    
    %获取I和Q分量
    n=ceil(length(yr)/(T*fs))+1;
    t=[0:1/fs:T-1/fs];
    phase1=2*pi*(f0*t+B*(t.*t)/(2*T));%一个chirp的相位
    cosd=cos(phase1); 
    sind=sin(phase1);
    
    I=[];
    Q=[];
    for i=(1:n)
        I=[I,cosd];
        Q=[Q,sind];
    end
    %I=I(fs*T/8:end);
    %Q=Q(fs*T/8:end);
    I=I(1:length(yr));
    Q=Q(1:length(yr));
    I=yr.*I;
    Q=yr.*Q;
    I=firlowpass(B,I,fs);
    Q=firlowpass(B,Q,fs);
   % I=I(pos:end);
   % Q=Q(pos:end);
    
    %计算前10个chirp的峰值，提高准确率,因为刚开始是静止的，所以前10个chirp的峰值可以作为第1个chirp的峰值
    tmp=I(1:10*fs*T);
    tmp=[tmp,zeros(1,fs-length(tmp))];
    [freq,ampl]=frequencyAnalysis(tmp,fs);%用10个chirp的数据估测第一个峰值
    [maxval,index]=max(abs(ampl));
    [pks,locs]=findpeaks(abs(ampl),"MinPeakHeight",0.6*maxval);
    fpeak=freq(locs(1));
    
    
    %计算相位并进一步计算距离
    dis=[];
    
    %第1个chirp的峰值已经求出，需要去除
    I=I(fs*T+1:end);
    Q=Q(fs*T+1:end);
    
    N=length(I);
    phase=[];
    windowsize=fs*0.001;%1ms
    chirpNum=fs*T;%40ms
   
    for i=[1:chirpNum:N]
        if(i+chirpNum-1>N)break;end
        %计算每个chirp开始的初相位
        tmpI=I(i:i+7/8*chirpNum-1);
        tmpQ=Q(i:i+7/8*chirpNum-1);
        %使用带通滤波器滤除大部分多径
        tmpI=firbandpass(fpeak-1,fpeak+1,tmpI,fs);
        tmpQ=firbandpass(fpeak-1,fpeak+1,tmpQ,fs);
       % tmpI=bandpass(tmpI,[fpeak-1 fpeak+1],fs);
       % tmpQ=bandpass(tmpQ,[fpeak-1 fpeak+1],fs);
        phase=zeros(1,7/8*chirpNum);
        
            D=fpeak*340*T/B;
            initphase=0;
            if(tmpI(1)>0&&tmpQ(1)>=0)
                initphase=atan(tmpQ(1)/tmpI(1));
            elseif(tmpI(1)>0&&tmpQ(1)<0)
                initphase=atan(tmpQ(1)/tmpI(1))+2*pi;
            elseif(tmpI(1)<0)
                initphase=atan(tmpQ(1)/tmpI(1))+pi;
            elseif(tmpI(1)==0&&tmpQ(1)>0)
                initphase=pi/2;
            elseif(tmpI(1)==0&&tmpQ(1)<0)
                initphase=3*pi/2;
            else initphase=0;
            end
            n1=calphase(initphase,f0,B,T,D);%计算初始2Npi的偏移
            n1=fix(n1);
            phase(1)=initphase+2*n1*pi;%得到每个chirp开始的初相位
        
        %计算一个chirp中，每个点的相位
        for j=2:7/8*chirpNum
            if(tmpI(j)>0&&tmpQ(j)>=0)%第一象限和x正半轴
                phase(j)=atan(tmpQ(j)/tmpI(j));
            elseif(tmpI(j)>0&&tmpQ(j)<0)%第四象限
                phase(j)=atan(tmpQ(j)/tmpI(j))+2*pi;
            elseif(tmpI(j)<0)%第二象限和x负半轴和第三象限
                phase(j)=atan(tmpQ(j)/tmpI(j))+pi;
            elseif(tmpI(j)==0&&tmpQ(j)>0)%y轴正半轴
                phase(j)=pi/2;
            elseif(tmpI(j)==0&&tmpQ(j)<0)%y轴负半轴
                phase(j)=3*pi/2;
            else
                phase(j)=0;
            end
                
            num=floor(phase(j-1)/2/pi);
            phase(j)=phase(j)+2*num*pi;
            if(phase(j)-phase(j-1)<-pi)
                phase(j)=phase(j)+2*pi;
            elseif(phase(j)-phase(j-1)>pi)
                phase(j)=phase(j)-2*pi;
            end
        end
        %计算距离
        
        for j=1:windowsize:7/8*chirpNum
            curphase=phase(j);
            time=j/fs;
            %syms td;
            %td=solve(2*pi*(B/T*time*td+f0*td-B/2/T*td^2)==curphase,td);
            %td1=double(td(1));
            %td2=double(td(2));
            a1=-B*pi/T;
            b1=2*pi*(B*time/T+f0);
            c1=-curphase;
            td1=(-b1+sqrt(b1^2-4*a1*c1))/2/a1;
            td2=(-b1-sqrt(b1^2-4*a1*c1))/21/a1;
            if(td1>=0&&td1<=T)dis=[dis,td1*340];
            elseif(td2>=0&&td2<=T) dis=[dis,td2*340];
            else dis=[dis,dis(end)];
            end;
            
        end
        %最小二乘拟合法拟合最后10ms的数据求速度
        myt=[0:0.001:0.009];
        mydis=dis(length(dis)-9:end);
        coefficient=polyfit(myt,mydis,1); 
        %利用速度计算出在chirp末的位置
        dis=[dis,dis(end)+coefficient(1)*0.005];
        fpeak=dis(end)*B/340/T;
    end
    
    newdis=[];
    for i=[1:10:length(dis)]
        newdis=[newdis,dis(i)];
    end
    dis=newdis;
    %平滑数据
    dis=kalman_smooth(dis,1e-6,5e-5);
    figure;plot(dis,"r.-");
    %figure;plot(phase,"b.-");
end