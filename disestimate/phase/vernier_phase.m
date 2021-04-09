function dis=vernier_phase(filename,line,f,fs,pos)
%复现了vernier论文中的方法，3个扬声器，距离手机最近的那个最准，
%其他两个差很多，猜测原因是，论文没考虑多径的情况，当扬声器距离手机远时，
%一些多径对最终结果和影响和直接路径的影响差不多，
%因此这些路径传播来的声波接收后叠加起来将一些极值模糊了，变成了非极值，造成结果不准，
%并且，参考论文中的实验环境是比较空旷的，所以应该就是未考虑多径
    c=346;
    windownum=fs*0.01;
    data=readfile(filename,line);
    data=data';
    data=firbandpass(f-100,f+100,data,fs);
    data=data(pos:end);
   
    localmaxnum=zeros(1,length(data));
   
    for i=2:windownum
        if(data(i)>=data(i-1)&&data(i)>data(i+1))
            localmaxnum(i)=localmaxnum(i-1)+1;
        else localmaxnum(i)=localmaxnum(i-1);
        end
    end
    baseN=sum(localmaxnum);
    preN=baseN;
    dis=[];
    for i=[windownum+1:length(data)-1]
        if(data(i)>=data(i-1)&&data(i)>data(i+1))
            localmaxnum(i)=localmaxnum(i-1)+1;
        else localmaxnum(i)=localmaxnum(i-1);
        end
        curN=preN+localmaxnum(i)-localmaxnum(i-windownum);
        preN=curN;
        phi=(curN-baseN)*2*pi/windownum;
        dis=[dis,c*phi/(2*pi*f)-c*(i-windownum)/fs];
    end
    disnew=[];
    for i=1:windownum:length(dis)
        disnew=[disnew,dis(i)];
    end
    dis=-1*disnew;
    dis=kalman_smooth(dis,1e-6,5e-5);
    
    figure;plot(dis,"r.-");
end