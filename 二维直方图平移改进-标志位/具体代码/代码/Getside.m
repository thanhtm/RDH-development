function [side]=Getside(payload,Cv,exchange_table)  
%�������ܣ���������Ϣ��Ϊ����������

side=zeros(1,56);
%data = num2bin(face);%����Ƕ������ת���ɶ�������ʽ
%data = strcat(char(data)', '');%����ת�����ַ�����
% data = cellstr(data)';
%data = str2num(data(:));%����ת������������
% Cv>=1 && Cv<=32

a = num2bin(quantizer([19 0]),payload);    %paylaod���غɣ���18λ���������б�ʾ
a=strcat(char(a)','');     
a=str2num(a(:));
side(1:18)=a(2:19);

b= num2bin(quantizer([7 0]),Cv);     %Cv����6λ���������б�ʾ
b=strcat(char(b)','');     
b=str2num(b(:));
side(19:24)=b(2:7);

side(25:56)=exchange_table;

end
