function [ error_location_map,preI ] = Predictor2( I )
%PREDICTOR1 ����ǰһ���غ��Ϸ����صľ�ֵ��ΪԤ��ֵ 
%   �˴���ʾ��ϸ˵��
error1 = I;
error2 = I;
preI = I;
[m,n] = size(I);
error_location_map = zeros(m,n);
for i = 2 : m
    for j = 2 : n
%         error1(i,j) = abs(round((I(i-1,j)+I(i,j-1))/2) - I(i,j));%Ԥ��ֵ��ԭʼֵ�Ĳ� 
%         error2(i,j) = abs(round((I(i-1,j)+I(i,j-1))/2) - mod(I(i,j)+128,256));%Ԥ��ֵ�뷴ֵ�Ĳ�
        %MEDԤ��
        if I(i-1,j-1) <= min(I(i-1,j),I(i,j-1))
            preI(i,j) = max(I(i-1,j),I(i,j-1));
        elseif I(i-1,j-1) >= max(I(i-1,j),I(i,j-1))
            preI(i,j) = min(I(i-1,j),I(i,j-1));
        else
            preI(i,j) = I(i-1,j)+I(i,j-1)-I(i-1,j-1);
        end

%         preI(i,j) = round((I(i-1,j)+I(i,j-1))/2);
        x = I(i,j) - mod(mod(I(i,j),128),64);
        y = preI(i,j) - mod(mod(preI(i,j),128),64);
        if x ~= y
            error_location_map(i,j) = 255;
        end
%         if error1(i,j) >= error2(i,j) %
%             error_location_map(i,j) = 1;
%         end
    end
end
end

