function pos=align(f0,B,T,fs,filename)
%利用互相关进行对齐
    pos1=[];pos2=[];
    for i=[2,2.5,3]
        pos1=[pos1,align_min(f0,B,T,fs,filename,1,i)];
        pos2=[pos2,align_min(f0,B,T,fs,filename,2,i)];  
        
    end
    new=abs(pos1-pos2);
    [~,index]=min(new);
    pos=floor((pos1(index)+pos2(index))/2);
    %pos1
    %pos2
    
end