function [ numData2,extData,recoI ] = extract( stegoI,payload,flag_mark,error_location_map )
%EXTRACT 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n] = size(stegoI);
recoI = stegoI;

rand('seed',1);s = round(rand(m,n)*255);%再次异或 恢复每个像素后7位
numData2 = 0;
extData = zeros();

for i = 2:m  
    for j = 1:8:n
        if flag_mark(i,(j+7)/8) == 0
            if j == 1 
                for o = j+1:j+7
                    if numData2 == payload
                        break;
                    end
                    extData(numData2+1) = fix(stegoI(i,o)/128);
                    numData2 = numData2 +1;
                end
            else
                for o = j:j+7
                    if numData2 == payload
                        break;
                    end
                    extData(numData2+1) = fix(stegoI(i,o)/128);
                    numData2 = numData2 +1;
                end
            end
        end
    end
end

%% 图像重构 
for i = 1:m
    for j = 1:n
        recoI(i,j) = bitxor(stegoI(i,j),s(i,j));
    end
end
error1 = recoI;
error2 = recoI;

%预测MSB
for i = 2:m  
    for j = 2:n
        error1(i,j) = abs(round((recoI(i-1,j)+recoI(i,j-1))/2) - recoI(i,j));
        error2(i,j) = abs(round((recoI(i-1,j)+recoI(i,j-1))/2) - mod(recoI(i,j)+128,256));
        
        if error_location_map(i,j) == 0
            if error1(i,j) >= error2(i,j)
                recoI(i,j) = mod(recoI(i,j)+128,256);
            else
                recoI(i,j) = recoI(i,j);
            end
        elseif error_location_map(i,j) == 1
            if error1(i,j) >= error2(i,j)
                recoI(i,j) = recoI(i,j);
            else
                recoI(i,j) = mod(recoI(i,j)+128,256);
            end
        end       
    end
end

end

