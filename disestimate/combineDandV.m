function dis1=combineDandV(dis,v,T,B,f)
%FMCW考虑速度的影响,速度可以由多普勒求出，这里的dis是距离变化，不能是绝对距离
    initd=dis(1);
    N=length(dis);
    dis=dis-initd;
    dis=dis-(f+B)*T/B*v;
    dis1=dis;
end
