function [ encryptI ] = Encrypted( I )
%ENCRYPTED ��ͼ�����������  
%   �˴���ʾ��ϸ˵��
[m,n] = size(I);
% preI = uint8(preI);
encryptI = I;
rand('seed',1);s = round(rand(m,n)*255); %�������
for i = 1:m
    for j = 1: n
        encryptI(i,j) = bitxor(I(i,j),s(i,j));
    end
end

% encryptI = double(encryptI);
% imshow(uint8(encryptI));
end

