function llapphasedis(filename,line,f,fs,pos)
%LLAP论文复现,使用相位
    %读取数据
    c=340;
    data=readfile(filename,line);
    data=data';
    data=firbandpass(f-100,f+100,data,fs);
    pos=find(data>0);
    pos=pos(1)+2;
    data=data(pos:end);
    
    %获得I分量和Q分量
    N=length(data);
    t=[0:1/fs:(N-1)/fs];
    sind=-1*sin(2*f*pi*t);
    cosd=cos(2*f*pi*t);
    I=data.*cosd;
    Q=data.*sind;
    I=firlowpass(150,I,fs);
    Q=firlowpass(150,Q,fs);
    
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
    windowsize=fs*0.01;%10ms
    for i=[2:windowsize:length(phase)]
        dis=[dis,-(phase(i)-phase(1))*c/(2*pi*f)];
    end
    dis=kalman_smooth(dis,1e-6,5e-5);
    figure;plot(dis);
end