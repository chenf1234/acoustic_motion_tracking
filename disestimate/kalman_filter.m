function data=kalman_filter(datafmcw,v,T)
%卡尔曼滤波结合多普勒和FMCW
    data=[];
    p=1;
    Q=5e-3;
    R=1e-3;
    tmpdata=0;
    for i=1:length(datafmcw)
        p=p+Q;
        k=p/(p+R);
        tmpdata=datafmcw(i)+k*(tmpdata+v(i)*T-datafmcw(i));
        p=(1-k)*p;
        data=[data,tmpdata];
    end
    
    
end