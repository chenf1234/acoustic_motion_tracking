function direction()
%判断手机朝向
    
    %设置输入文件名
    filename=input("请输入测试文件名：");
    filename=sprintf("./testfiles/%s.wav",filename);
    
    %[xpos1,ypos1,zpos1]=disfor3Dfmcw(filename,1);
    %[xpos2,ypos2,zpos2]=disfor3Dfmcw(filename,2);
    
    %[xpos1,ypos1,zpos1]=disfor3Ddoppler(filename,1);
    %[xpos2,ypos2,zpos2]=disfor3Ddoppler(filename,2);
    
    [xpos1,ypos1,zpos1]=dis3Dfmcw_phase(filename,1);
    [xpos2,ypos2,zpos2]=dis3Dfmcw_phase(filename,2);
    
    angle=[];
   % figure;
   % plot3([0],[0],[0],"ro");
   % hold on;
    for i=[1:length(xpos1)]
        if(~isnan(xpos1(i))&&~isnan(xpos2(i)))
            len=abs(norm([xpos1(i),ypos1(i),zpos1(i)]-[xpos2(i),ypos2(i),zpos2(i)]));
            xangle=acos((xpos2(i)-xpos1(i))/len);
            yangle=acos((ypos2(i)-ypos1(i))/len);
            zangle=acos((zpos2(i)-zpos1(i))/len);
          %  plot3([0,cos(xangle)],[0,cos(yangle)],[0,cos(zangle)],"r.-");
          %  z=(-(1-cos(xangle)/2)*cos(xangle)-(1-cos(yangle)/2)*cos(yangle))/cos(zangle)+cos(zangle)/2;
          %  quiver3(cos(xangle)/2,cos(yangle)/2,cos(zangle)/2,1,1,z,"b",'LineWidth',0.5);
           
          %  pause(0.01);
          %  drawnow;
            angle=[angle;[rad2deg(xangle),rad2deg(yangle),rad2deg(zangle)]];
        end

    end
    
    hold off;
    for i=(1:length(xpos1))
        disp("X轴夹角："+num2str(angle(i,1),"%08.4f")+"°，Y轴夹角："+num2str(angle(i,2),"%08.4f")+"°，Z轴夹角："+num2str(angle(i,3),"%08.4f")+"°");
    end
    %disp(angle);
        
end