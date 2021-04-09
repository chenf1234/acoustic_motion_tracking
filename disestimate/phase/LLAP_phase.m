function dis=LLAP_phase(filename,line,f,fs,pos)
%LLAP论文复现,使用相位,距离远时,效果比vernier好
%LLAP受多径的干扰没有vernier严重
    %读取数据
    c=340;
    data=readfile(filename,line);
    data=data';
    data=firbandpass(f-100,f+100,data,fs);
    if(pos==0)
        pos=find(data>0);
        pos=pos(1)+2;
    end
    data=data(pos:end);
    
    %获得I分量和Q分量
    N=length(data);
    t=[0:1/fs:(N-1)/fs];
    sind=-1*sin(2*f*pi*t);
    cosd=cos(2*f*pi*t);
    I=data.*cosd;
    Q=data.*sind;
    %滤波时的通带截止频率得好好选择
    wp=fix(f/c);
    %wp=30;
    I=firlowpass(wp,I,fs);
    Q=firlowpass(wp,Q,fs);
    
    %计算相位
    N=length(I);
    phase=zeros(1,N);
    num=0;
    for i=[1:N]
        
            if(I(i)>0)%第一象限和x正半轴和第三象限
                phase(i)=atan(Q(i)/I(i));
            elseif(I(i)<0)%第二象限和x负半轴和第四象限
                phase(i)=atan(Q(i)/I(i))+pi;
            elseif(I(i)==0&&Q(i)>0)%y轴正半轴
                phase(i)=pi/2;
            elseif(I(i)==0&&Q(i)<0)%y轴负半轴
                phase(i)=3*pi/2;
            else
                phase(i)=0;
            end
        if(i>1)
            num=fix(phase(i-1)/2/pi);
            phase(i)=phase(i)+2*num*pi;
            if(phase(i)-phase(i-1)<-pi)
                phase(i)=phase(i)+2*pi;
            elseif(phase(i)-phase(i-1)>pi)
                phase(i)=phase(i)-2*pi;
            end
        end

    end
    dis=[];
    windowsize=fs*0.04;%40ms
    for i=[windowsize/2:windowsize:length(phase)]
        dis=[dis,-(phase(i)-phase(1))*c/(2*pi*f)];
    end
    dis=kalman_smooth(dis,1e-6,5e-5);
    dis=dis-dis(1);
    figure;plot(dis);
end