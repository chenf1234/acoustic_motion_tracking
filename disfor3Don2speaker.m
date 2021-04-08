function a=disfor3Don2speaker(f0,f1)
%利用两个扬声器进行3D追踪并一步判断手机朝向
%手机直立摆放

    %基本参数
    dis2speaker=0.9;%两个扬声器之间的距离90cm
    dis2mic=0.16;%两个麦克风之间的距离16cm
    
    %f0=17e3;
    %f1=20.5e3;
    B=3e3;
    T=0.04;
    fs=48e3;
    
    %设置输入文件名
    filename=input("请输入测试文件名：");
    filename=sprintf("./testfiles/%s.wav",filename);
    
    lspeaker=[0,0,0];%左扬声器的位置
    rspeaker=[0,dis2speaker,0];%右扬声器的位置
    
    %寻找对齐的位置
    p1=align(f0,B,T,fs,filename);
    p2=align(f1,B,T,fs,filename);
    
    %手机下方麦克风,主麦克风
    disleft_mic1=distancefor1D(f0,B,T,fs,filename,1,p1);
    disright_mic1=distancefor1D(f1,B,T,fs,filename,1,p2);
    
    %手机上方麦克风
    disleft_mic2=distancefor1D(f0,B,T,fs,filename,2,p1);
    disright_mic2=distancefor1D(f1,B,T,fs,filename,2,p2);
    
    %两个麦克风的坐标，暂时固定
    mic1=[0.55,dis2speaker,0];
    mic2=[0.55,dis2speaker,dis2mic];
    
    posmic1=[mic1];
    posmic2=[mic2];
    
    %两个麦克风到左右两个扬声器的距离
    D12=0.55;D11=sqrt(D12^2+dis2speaker^2);
    D22=sqrt(D12^2+dis2mic^2);D21=sqrt(D11^2+dis2mic^2);
    
    %分布式FMCW只能测出相对距离变化
    baseD11=disleft_mic1(1);baseD12=disright_mic1(1);
    baseD21=disleft_mic2(1);baseD22=disright_mic2(1);
    
    N=length(disleft_mic1);
    ansy=[];
    for i=[2:N]
        %余弦定理，求出固定的y坐标，因为求出的mic1和mic2的y坐标有微小的差异，因此取平均值
        %tmpdown1=D11+disleft_mic1(i)-baseD11;
        %tmpdown2=D12+disright_mic1(i)-baseD12;
        %angledown=abs(acos((tmpdown1^2+dis2speaker^2-tmpdown2^2)/(2*dis2speaker*tmpdown1)));
        %r1=tmpdown1*sin(angledown);
        %y1=tmpdown1*cos(angledown);
        
        %tmpup1=D21+disleft_mic2(i)-baseD21;
        %tmpup2=D22+disright_mic2(i)-baseD22;
        %angleup=abs(acos((tmpup1^2+dis2speaker^2-tmpup2^2)/(2*dis2speaker*tmpup1)));
        %r2=tmpup1*sin(angleup);
        %y2=tmpup1*cos(angleup);
        
        %y=(y1+y2)/2;
       
        %得到y坐标后，因为手机垂直摆放，所以mic1和mic2的z坐标关系固定，并且mic1与mic2的x与y坐标相同
        %因此x、z坐标满足等式eq1，eq2关系,即满足圆的关系
        %最后解方程得到x与z的坐标，有两组解，取与上一个位置最近的那个解作为下一个位置
        %syms x z;
        %eq1=x^2+z^2==r1^2;
        %eq2=x^2+(z+dis2mic)^2==r2^2;
        %[x,z]=solve([eq1,eq2],[x,z]);
        %x=double(x);
        %z=double(z);
        %tmppos1=[x(1),y,z(1)];
        %tmppos2=[x(2),y,z(2)];
        %上述注释部分计算量大，不需要使用
        
        tmpdown1=D11+disleft_mic1(i)-baseD11;
        tmpdown2=D12+disright_mic1(i)-baseD12;
        angledown=abs(acos((tmpdown1^2+dis2speaker^2-tmpdown2^2)/(2*dis2speaker*tmpdown1)));
        y1=(tmpdown1^2-tmpdown2^2+dis2speaker^2)/(2*dis2speaker);
        
        tmpup1=D21+disleft_mic2(i)-baseD21;
        tmpup2=D22+disright_mic2(i)-baseD22;
        angleup=abs(acos((tmpup1^2+dis2speaker^2-tmpup2^2)/(2*dis2speaker*tmpup1)));
        y2=(tmpup1^2-tmpup2^2+dis2speaker^2)/(2*dis2speaker);
        y=(y1+y2)/2;
        if(abs(y1-y2)>0.2)
            ansy=[ansy,1];
        else
            ansy=[ansy,0];
        end
       
        %因为新得到的y值与y1和y2可能不同，所以需要修正一下tmpdown1和tmpup1
        tmpdown1=sqrt(tmpdown1*sin(angledown)^2+y^2);
        tmpup1=sqrt(tmpup1*sin(angleup)^2+y^2);
        
        z=(tmpup1^2-tmpdown1^2-dis2mic^2)/(2*dis2mic);
        x2=tmpdown1^2-y^2-z^2;
        if(x2>=0)
            tmppos1=[sqrt(x2),y,z];
            tmppos2=[-sqrt(x2),y,z];
            if(norm(tmppos1-mic1)>norm(tmppos2-mic1))
                mic1=tmppos2;
                mic2=[-sqrt(x2),y,z+dis2mic];
            else
                mic1=tmppos1;
                mic2=[sqrt(x2),y,z+dis2mic];
            end
            posmic1=[posmic1;mic1];
            posmic2=[posmic2;mic2];
        end
    end
    xmic1=posmic1(:,1);
    ymic1=posmic1(:,2);
    zmic1=posmic1(:,3);
    figure;
    plot3(xmic1',ymic1',zmic1',"r.-");
    a=ansy;
    
end