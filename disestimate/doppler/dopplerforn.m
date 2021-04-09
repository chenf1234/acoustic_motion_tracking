function v=dopplerforn(fbegin,filename,T,fs,line,pos,n)
%n-doppler的频率个数
    v=[];
    data=readfile(filename,line);
    data=data';
    data=data(pos:end);
    fftNum=fs*T;
    N=length(data);
    for i=[1:fftNum:N]
        if(i+fftNum-1>N)
            break;
        end
        vtmp=[];
        for j=1:n
            tmp=data(i:i+fftNum-1);
            center=fbegin+(j-1)*200;
            tmp=firbandpass(center-100,center+100,tmp,fs);
            tmp=tmp.*hanning(length(tmp))';
            tmp=[tmp,zeros(1,fs-length(tmp))];
            [f,A]=frequencyAnalysis(tmp,fs);
            index=center-100;
            %在[center-100:center+100]的范围内查找峰值频率
            for k=[center-100:center+100]
                if(abs(A(k))>abs(A(index)))
                    index=k;
                end
            end
            vtmp=[vtmp,(f(index)-center)*340/center];
        end
        v=[v;vtmp];  
    end
    v=v';

end