function ft = STFT(data,fs,t)
%计算data中频率随时间的变换，只取峰值频率，相当于STFT
%t--每次FFT的处理间隔
    fb=[];
    fftnum=fs*t;
    N=length(data);
    
    p=[];
    for i=(1:fftnum:N)
        if(i+fftnum-1>N)
            break;
        end
        tmp=data(i:i+fftnum-1);
        tmp=tmp.*hamming(length(tmp))';
        tmp=[tmp,zeros(1,fs-length(tmp))];%保证实时性的同时，提高分辨率
        [f,A]=frequencyAnalysis(tmp,fs);
        W=abs(A).^2/fs;
        p=[p,W'];
        [~,index]=max(W);
        fb=[fb,f(index)];
    end
    ft=fb;
    t1=[0:t:(fix(N/fftnum)-1)*t];
    
    %figure;surf(t1,f,p,'edgecolor','none');axis tight;
    %view(0,90);
    %xlabel('Time (Seconds)'); ylabel('Hz');
end