function [ error_location_map,preI ] = Predictor2( I )
%PREDICTOR1 采用前一像素和上方像素的均值作为预测值 
%   此处显示详细说明
error1 = I;
error2 = I;
preI = I;
[m,n] = size(I);
error_location_map = zeros(m,n);
for i = 2 : m
    for j = 2 : n
%         error1(i,j) = abs(round((I(i-1,j)+I(i,j-1))/2) - I(i,j));%预测值与原始值的差 
%         error2(i,j) = abs(round((I(i-1,j)+I(i,j-1))/2) - mod(I(i,j)+128,256));%预测值与反值的差
        %MED预测
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

