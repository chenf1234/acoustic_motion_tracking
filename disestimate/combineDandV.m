function dis1=combineDandV(dis,v,T,B,f)
%FMCW考虑速度的影响
    initd=dis(1);
    N=length(dis);
    dis=dis-initd;
    dis=dis-(f+B)*T/B*v;
    dis1=dis;
end
