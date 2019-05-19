close all
clear
clc
% 负载也要作为最低有效位嵌入，最大512*512,需要19位二进制存储    ！！为了方便就直接使用了
for payload=50000%:10000:512*512;
Data = round(rand(1,payload)*1);%随机产生01比特，作为嵌入的数据
I=imread('lena.tiff');
subplot(1,2,1)
imshow(I);
title('原始图像')
%% 嵌入
[I_stego]=embed(I,Data,payload);
subplot(1,2,2)
imshow(I_stego);
title('载密图像')
%% 提取
[Data_extra]=extract(I_stego,payload);
if Data == Data_extra;
    display('提取数据与秘密信息一致');
else
    display('提取数据与秘密信息不一致');
end
end