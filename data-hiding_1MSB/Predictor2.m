function [ error_location_map ] = Predictor2( I )
% PREDICTOR1 采用前一像素和上方像素的均值作为预测值 
% 此处显示详细说明
error1 = I;
error2 = I;
[m,n] = size(I);
error_location_map = zeros(m,n);
for i = 2 : m
    for j = 2 : n
        error1(i,j) = abs(round((I(i-1,j)+I(i,j-1))/2) - I(i,j));%预测值与原始值的差 
        error2(i,j) = abs(round((I(i-1,j)+I(i,j-1))/2) - mod(I(i,j)+128,256));%预测值与反值的差

        if error1(i,j) >= error2(i,j) %对像素值进行调整,使其满足嵌入条件
            error_location_map(i,j) = 1;
        end
    end
end
end

