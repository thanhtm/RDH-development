function [ num1,num2 ] = comp( I,preI )
%CAMP �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
num1 = 0;
num2 = 0;
error1 = I;
error2 = I;
[m,n] = size(I);
for i = 2:m
    for j = 2:n
        error1(i,j) = abs(round((I(i-1,j)+I(i,j-1))/2) - I(i,j));%Ԥ��ֵ��ԭʼֵ�Ĳ� 
        error2(i,j) = abs(round((I(i-1,j)+I(i,j-1))/2) - mod(I(i,j)+128,256));%Ԥ��ֵ�뷴ֵ�Ĳ�
        if error1(i,j) >= error2(i,j) %������ֵ���е���,ʹ������Ƕ������
            num2 = num2 + 1;
        end
        
        x = I(i,j) - mod(mod(I(i,j),128),64);
        y = preI(i,j) - mod(mod(preI(i,j),128),64);
        if x ~= y
            num1 = num1 + 1;
        end
    end
end

end

