function [xpos,ypos,zpos]=disfor3Ddoppler(filename,line)
    f0=14e3;
    f1=14.6e3;
    f2=15.2e3;
    T=0.04;
    fs=48e3;
    pos=1920;
    n=3;
    
    v0=dopplerforn(f0,filename,T,fs,line,pos,n);
    v0=dopplern2one(v0,n);
    v1=dopplerforn(f1,filename,T,fs,line,pos,n);
    v1=dopplern2one(v1,n);
    v2=dopplerforn(f2,filename,T,fs,line,pos,n);
    v2=dopplern2one(v2,n);
    
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
    figure;
    num=0;
    for i=[1:length(v0)]
        D0=D0-v0(i)*T;
        D1=D1-v1(i)*T;
        D2=D2-v2(i)*T;
        y=(D0^2-D1^2+0.8^2)/(2*0.8);
        z=(D2^2-D1^2-0.65^2)/(2*0.65);
        x_2=D0^2-y^2-z^2;
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
        drawnow;
    end
    disp(num);
end