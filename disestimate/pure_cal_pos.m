function [xpos,ypos,zpos]=pure_cal_pos(dis0,dis1,dis2,line)
%计算3D空间中的位置
    %初始位置
    speaker0=[0,0,0];
    speaker1=[0,0.8,0];
    speaker2=[0,0.8,-0.65];
    if line==1
        D2=0.6;
        D1=sqrt(D2^2+0.65^2);
        D0=sqrt(D1^2+0.8^2);
        micinit=[D2,0.8,-0.65];
    else
        D2=sqrt(0.6^2+0.16^2);
        D1=sqrt(0.6^2+(0.65-0.16)^2);
        D0=sqrt(D1^2+0.8^2);
        micinit=[0.6,0.8,-0.65+0.16];
    end
    mic=[micinit];
    N=min(length(dis0),min(length(dis1),length(dis2)));
    
    %单纯使用FMCW方法
    num=0;
    figure;
    for i=[1:N]
        curd0=dis0(i)+D0;
        curd1=dis1(i)+D1;
        curd2=dis2(i)+D2;
        y=(curd0^2-curd1^2+0.8^2)/(2*0.8);
        z=(curd2^2-curd1^2-0.65^2)/(2*0.65);
        x_2=curd0^2-y^2-z^2;
        if(x_2<0)
            mic=[mic;[NaN,y,z]];num=num+1;
        else
            mic1=[sqrt(x_2),y,z];
            mic2=[-sqrt(x_2),y,z];
            if(norm(mic1-micinit)>norm(mic2-micinit))
                micinit=mic2;
            else micinit=mic1;
            end
            mic=[mic;micinit];
        end
        xpos=mic(:,1)';
        ypos=mic(:,2)';
        zpos=mic(:,3)';
        plot3(xpos,ypos,zpos,"r.-");
        hold on;
        
        drawnow;
    end
end