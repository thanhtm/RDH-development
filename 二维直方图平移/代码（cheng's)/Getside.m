function [side]=Getside(payload,Cv,Th)  
%�������ܣ���������Ϣ��Ϊ����������

side=zeros(1,30);
%data = num2bin(face);%����Ƕ������ת���ɶ�������ʽ
%data = strcat(char(data)', '');%����ת�����ַ�����
% data = cellstr(data)';
%data = str2num(data(:));%����ת������������
% Cv>=2 && Cv<=32
% Th>=0 && Th<=62

a = num2bin(quantizer([19 0]),payload);    %paylaod���غɣ���18λ���������б�ʾ
a=strcat(char(a)','');     
a=str2num(a(:));
side(1:18)=a(2:19);

b= num2bin(quantizer([7 0]),Cv);     %Cv����6λ���������б�ʾ
b=strcat(char(b)','');     
b=str2num(b(:));
side(19:24)=b(2:7);

c = num2bin(quantizer([7 0]),Th);    %Th����6λ���������б�ʾ
c=strcat(char(c)','');     
c=str2num(c(:));
side(25:30)=c(2:7);

end
