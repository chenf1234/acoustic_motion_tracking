function wav=createFMCWfor2mic(f0, f1 , B, T, fs, n)

    left=createFMCW(f0,B,T,fs,n);
    right=createFMCW(f1,B,T,fs,n);
    wav=[left',right'];
    
end