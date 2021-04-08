function res=readfile(filename,col)
%filename--文件名
%对于双声道音频数据，选择一列
    [data,Fs]=audioread(filename);
    [a,b]=size(data);
    if(b>1)
        data=data(:,col);
    else 
        data=data(:,1);
    end;
    res=data;
end