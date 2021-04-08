function data1=kalman_smooth(data,Q,R)
%通过卡尔曼滤波算法平滑数据
    data1=[];
    p=1;
   % Q=1e-4;
   % R=9e-3;
    N=length(data);
    x=data(1);
    for i=[1:N]
       p=p+Q;
       k=p/(p+R);
       x=x+k*(data(i)-x);
       p=(1-k)*p;
       data1=[data1,x];
    end
end