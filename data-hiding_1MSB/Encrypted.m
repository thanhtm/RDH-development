function [ encryptI ] = Encrypted( I )
%ENCRYPTED 对图像进行异或加密  
%   此处显示详细说明
[m,n] = size(I);
encryptI = I;
rand('seed',1);s = round(rand(m,n)*255); %随机生成
for i = 1:m
    for j = 1: n
        encryptI(i,j) = bitxor(I(i,j),s(i,j));
    end
end
end

