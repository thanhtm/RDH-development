function [payload,Cv,exchange_table]=Extside(side)
%�������ܣ��ӱ���Ϣ����ȡpayload,Cv,exchange_table

a=side(1:18);
a=num2str(a);
payload=bin2dec(a);

b=side(19:24);
b=num2str(b);
Cv=bin2dec(b);

exchange_table=side(25:56);


