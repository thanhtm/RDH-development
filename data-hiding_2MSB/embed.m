function [ numData,emdData,stegoI,flag_mark,flag ] = embed( encryptI,Data,payload,error_location_map )
%EMBED 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n] = size(encryptI);
stegoI = encryptI;
numData = 0;
flag = zeros(m,n/4);
for i = 1:m  %统计不能嵌入的块
    for j = 1:4:n
        sumblock = sum(error_location_map(i,j:j+3));
        if sumblock > 0
            flag(i,(j+3)/4) = 1;
        end
    end
end
%添加标记块 标记块也不能嵌入
flag_mark = flag;
for i = 1:m 
    for j = 1:n/4
        if flag(i,j) == 1
            if j == 1
                flag_mark(i,j+1) = 1;
            elseif j == n/4
                flag_mark(i,j-1) = 1;
            else
                flag_mark(i,j+1) = 1;
                flag_mark(i,j-1) = 1;
            end     
        end
    end
end

%% 嵌入 第一行第一列不嵌入
for i = 2:m  
    for j = 1:4:n
        if flag_mark(i,(j+3)/4) == 0
            if j == 1 %第一列不嵌入
                for o = j+1:j+3
                    if numData == payload
                        break;
                    end
                    stegoI(i,o) = Data(numData+1)*128 + mod(encryptI(i,o),128);%MSB嵌入
                    numData = numData +1;
                    stegoI(i,o) = Data(numData+1)*64 + mod(stegoI(i,o),64)+fix(stegoI(i,o)/128)*128;%次MSB嵌入
                    numData = numData +1;
                end
            else
                for o = j:j+3
                    if numData == payload
                        break;
                    end
                    stegoI(i,o) = Data(numData+1)*128 + mod(encryptI(i,o),128);%MSB嵌入
                    numData = numData +1;
                    stegoI(i,o) = Data(numData+1)*64 + mod(stegoI(i,o),64)+fix(stegoI(i,o)/128)*128;%次MSB嵌入
                    numData = numData +1;
                end
            end
        end
    end
end
emdData = Data(1:numData);%嵌入的数据
% imshow(uint8(stegoI));
end

