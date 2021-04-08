function y = createSinWav(fl,fs,T)
    t=[0:1/fs:T-1/fs];
    x=zeros(1,length(t));
    for i=[0:4]
        f=fl+i*200;
        x=x+cos(2*pi*f*t);
    end
    y=mapminmax(x);
end