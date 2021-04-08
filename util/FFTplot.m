function FFTplot(f1,x)
    figure;
    %subplot(2,1,1);
    plot(f1,abs(x));
    xlabel('Frequency(Hz)');
    ylabel('Amplitude');
end