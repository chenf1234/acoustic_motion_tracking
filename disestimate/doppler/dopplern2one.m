function v1=dopplern2one(v,n)
%最大比合并MRC算法加权平均合并各路速度数据
%假设噪声服从高斯分布，先使用高斯滤波过滤，然后使用原数据减去滤波后的的数据，得到噪声
%最后使用噪声方差的倒数作为权重加权平均各路数据
    std1=[];
    for i=(1:n)
        v(i,:)=hampel(v(i,:));%在进行MRC之前，使用hampel滤波去除异常值
        tmp=v(i,:);
        gtmp=smoothdata(tmp,"gaussian",5);
        std1=[std1,1/var(tmp-gtmp)];    
    end
    %加权平均
    sum1=sum(std1);
    std1=std1'/sum1;
    v=v.*std1;
    v1=sum(v,1);
    v1=hampel(v1);
   
    %平滑
    v1=kalman_smooth(v1,1e-5,1e-3);
    v1=smoothdata(v1,'gaussian',5);
    figure;plot(v1,"r.-");ylabel("velocity(m/s)");title("velocity based on doppler");
end