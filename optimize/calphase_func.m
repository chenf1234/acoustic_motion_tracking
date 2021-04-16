function [val,gradient]=calphase_func(x,initphase,f0,B,T,D)
   % syms td 
   % td=solve(2*pi*(f0*td-B/2/T*td^2)==initphase+2*x*pi,td);
   % td1=double(td(1));
   % td2=double(td(2));
    a=-pi*B/T;
    b=2*pi*f0;
    c=-(initphase+2*x*pi);
    td1=(-b+sqrt(b^2-4*a*c))/2/a;
    td2=(-b-sqrt(b^2-4*a*c))/2/a;
    if(td1>=0&&td1<=T)dis=340*td1;
    else dis=340*td2;end
    val=abs(dis-D);
end