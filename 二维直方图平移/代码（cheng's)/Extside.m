function [payload,Cv,Th]=Extside(side)
%�������ܣ��ӱ���Ϣ����ȡpayload,Cv,Th

a=side(1:18);
a=num2str(a);
payload=bin2dec(a);

b=side(19:24);
b=num2str(b);
Cv=bin2dec(b);

c=side(25:30);
c=num2str(c);
Th=bin2dec(c);


