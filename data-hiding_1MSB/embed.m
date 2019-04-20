function [ numData,emdData,stegoI,flag_mark,flag ] = embed( encryptI,Data,payload,error_location_map )
%EMBED 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n] = size(encryptI);
stegoI = encryptI;
numData = 0;
flag = zeros(m,n/8); %分块大小1*8
for i = 1:m  
    for j = 1:8:n
        sumblock = sum(error_location_map(i,j:j+7));
        if sumblock > 0
            flag(i,(j+7)/8) = 1;
        end
    end
end
%% 添加标记块 标记块也不能嵌入
flag_mark = flag;
for i = 1:m 
    for j = 1:n/8
        if flag(i,j) == 1
            if j == 1
                flag_mark(i,j+1) = 1;
            elseif j == n/8
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
    for j = 1:8:n
        if flag_mark(i,(j+7)/8) == 0
            if j == 1 %第一列不嵌入
                for o = j+1:j+7
                    if numData == payload
                        break;
                    end
                    stegoI(i,o) = Data(numData+1)*128 + mod(encryptI(i,o),128);%MSB嵌入
                    numData = numData +1;
                end
            else
                for o = j:j+7
                    if numData == payload
                        break;
                    end
                    stegoI(i,o) = Data(numData+1)*128 + mod(encryptI(i,o),128);%MSB嵌入
                    numData = numData +1;
                end
            end
        end
    end
end
%% 嵌入的数据
emdData = Data(1:numData);
end

