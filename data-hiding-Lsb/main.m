close all
clear
clc
% ����ҲҪ��Ϊ�����ЧλǶ�룬���512*512,��Ҫ19λ�����ƴ洢    ����Ϊ�˷����ֱ��ʹ����
for payload=50000%:10000:512*512;
Data = round(rand(1,payload)*1);%�������01���أ���ΪǶ�������
I=imread('lena.tiff');
subplot(1,2,1)
imshow(I);
title('ԭʼͼ��')
%% Ƕ��
[I_stego]=embed(I,Data,payload);
subplot(1,2,2)
imshow(I_stego);
title('����ͼ��')
%% ��ȡ
[Data_extra]=extract(I_stego,payload);
if Data == Data_extra;
    display('��ȡ������������Ϣһ��');
else
    display('��ȡ������������Ϣ��һ��');
end
end