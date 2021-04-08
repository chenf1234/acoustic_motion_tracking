function dis=v2d(v,T)
%对速度积分
    dis=[];
    path=0;
    for i=[1:length(v)]
        path=path+v(i)*T;
        dis=[dis,path];
    end
end