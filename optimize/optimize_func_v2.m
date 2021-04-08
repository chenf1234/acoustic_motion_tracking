function [val,gradient]=optimize_func_v2(x,dfmcw,dphase,initdis,initpos)
    val=0;
    N=length(dfmcw);
    gradient=zeros(1,N);
    for i=[1:3:N]
        pos=[x(i),x(i+1),x(i+2)];
        for j=[1:3]
            val=val+(norm(pos-initpos(j,:))-initdis(j)-dfmcw(i+j-1))^2+(norm(pos-initpos(j,:))-initdis(j)-dphase(i+j-1))^2;
        end
        if(nargout > 1)
            for k=[i:i+2]
                for j=[1:3]
                    gradient(k)=gradient(k)+(norm(pos-initpos(j,:))-initdis(j)-dfmcw(i+j-1))*2*(x(k)-initpos(j,mod(k-1,3)+1))/norm(pos-initpos(j,:));
                    gradient(k)=gradient(k)+(norm(pos-initpos(j,:))-initdis(j)-dphase(i+j-1))*2*(x(k)-initpos(j,mod(k-1,3)+1))/norm(pos-initpos(j,:));
                end
            end
        end
    end
end