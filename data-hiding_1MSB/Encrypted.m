function [ encryptI ] = Encrypted( I )
%ENCRYPTED ��ͼ�����������  
%   �˴���ʾ��ϸ˵��
[m,n] = size(I);
encryptI = I;
rand('seed',1);s = round(rand(m,n)*255); %�������
for i = 1:m
    for j = 1: n
        encryptI(i,j) = bitxor(I(i,j),s(i,j));
    end
end
end

