function [ error_location_map ] = Predictor2( I )
% PREDICTOR1 ����ǰһ���غ��Ϸ����صľ�ֵ��ΪԤ��ֵ 
% �˴���ʾ��ϸ˵��
error1 = I;
error2 = I;
[m,n] = size(I);
error_location_map = zeros(m,n);
for i = 2 : m
    for j = 2 : n
        error1(i,j) = abs(round((I(i-1,j)+I(i,j-1))/2) - I(i,j));%Ԥ��ֵ��ԭʼֵ�Ĳ� 
        error2(i,j) = abs(round((I(i-1,j)+I(i,j-1))/2) - mod(I(i,j)+128,256));%Ԥ��ֵ�뷴ֵ�Ĳ�

        if error1(i,j) >= error2(i,j) %������ֵ���е���,ʹ������Ƕ������
            error_location_map(i,j) = 1;
        end
    end
end
end

