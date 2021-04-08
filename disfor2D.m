function [xpos,ypos]=disfor2D(line)
    
    % 很有可能手在移动手机的过程中不平稳，造成垂直方向上的位移，因此引入了大误差
    % 只要保证严格2D平面运动，误差就很小，实验效果就很好，大约是2cm的误差
    
    %line=1;
    %基本参数
    f0=17e3;
    f1=20.5e3;
    B=3e3;
    T=0.04;
    fs=48e3;
    
    %设置输入文件名
    filename=input("请输入测试文件名：");
    filename=sprintf("./testfiles/%s.wav",filename);
    
    %测出手机到两个扬声器的距离变化
    disleft=distancefor1D(f0,B,T,fs,filename,line,fs*T);
    disright=distancefor1D(f1,B,T,fs,filename,line,fs*T);
    
    dis2mic=0.9;%两个扬声器之间相隔90cm
    lspeaker=[0,0];%左扬声器的位置
    rspeaker=[dis2mic,0];%右扬声器的位置
    
    %D1,D2分别为手机到左右两个扬声器的距离，通过解方程得到
    tmpl=mean(disleft(1:5));
    tmpr=mean(disright(1:5));
    syms D1 D2;
    
    [D1,D2]=solve([D1^2==dis2mic^2+D2^2 D1-D2==abs(tmpl-tmpr)],[D1 D2]);
    
    D1=double(D1);
    D2=double(D2);
    %最终得到手机的初始坐标
    phone=[dis2mic,D2];
    
    pos=[phone];
    
   
    %求实时位置
    N=length(disleft);
    for i=[6:N]
        %余弦定理
        tmpD1=D1+(disleft(i)-tmpl);
        tmpD2=D2+(disright(i)-tmpr);
 
        angle=abs(acos((tmpD1^2+dis2mic^2-tmpD2^2)/(2*dis2mic*tmpD1)));
        
        tmppos1=[tmpD1*cos(angle),tmpD1*sin(angle)];
        tmppos2=[tmpD1*cos(-1*angle),tmpD1*sin(-1*angle)];
        
        
        %求两点间的距离，选取距离更近的那个点
        if(norm(tmppos1-phone)>norm(tmppos2-phone))
            phone=tmppos2;
            
        else
            phone=tmppos1;
            
        end
        
        pos=[pos;phone];
       
    end
    
    xpos=pos(:,1)';
    ypos=pos(:,2)';
    
    
    figure;
    plot(xpos,ypos,"r.-"); 
    legend("手机运动轨迹2D");
    
end