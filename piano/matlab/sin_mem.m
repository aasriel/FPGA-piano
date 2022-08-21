%% sin_mem
close all,clc,clear
x=0:1:2047;
Y=zeros(1,2048);
p=[1 0.2 0.3 0.1];
for i=1:1:4
    Y=Y+p(i)*sin(2*pi*i*x/2048);
end
A=round(2048+(Y/1.135)*2047);
fid=fopen ('D:\sin_2048.mem','w');
fprintf (fid,'%X\r\n',A);
fclose (fid );
plot (x,A)