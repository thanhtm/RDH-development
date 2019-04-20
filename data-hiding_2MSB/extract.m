function [ numData2,extData,recoI ] = extract( stegoI,payload,flag_mark,error_location_map )
%EXTRACT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[m,n] = size(stegoI);
recoI = stegoI;

rand('seed',1);s = round(rand(m,n)*255);%�ٴ���� �ָ�ÿ�����غ�7λ
numData2 = 0;
extData = zeros();

for i = 2:m  
    for j = 1:4:n
        if flag_mark(i,(j+3)/4) == 0
            if j == 1 
                for o = j+1:j+3
                    if numData2 == payload
                        break;
                    end
                    extData(numData2+1) = fix(stegoI(i,o)/128);%MSB��ȡ
                    numData2 = numData2 +1;
                    extData(numData2+1) = fix(mod(stegoI(i,o),128)/64);%��MSB��ȡ
                    numData2 = numData2 +1;
                end
            else
                for o = j:j+3
                    if numData2 == payload
                        break;
                    end
                    extData(numData2+1) = fix(stegoI(i,o)/128);
                    numData2 = numData2 +1;
                    extData(numData2+1) = fix(mod(stegoI(i,o),128)/64);%��MSB��ȡ
                    numData2 = numData2 +1;
                end
            end
        end
    end
end

%% ͼ���ع� 
for i = 1:m
    for j = 1:n
        recoI(i,j) = bitxor(stegoI(i,j),s(i,j));
    end
end
error1 = recoI;
error2 = recoI;

%Ԥ��MSB
for i = 2:m  
    for j = 2:n
        %MEDԤ��
        if recoI(i-1,j-1) <= min(recoI(i-1,j),recoI(i,j-1))
            preI = max(recoI(i-1,j),recoI(i,j-1));
        elseif recoI(i-1,j-1) >= max(recoI(i-1,j),recoI(i,j-1))
            preI = min(recoI(i-1,j),recoI(i,j-1));
        else
            preI = recoI(i-1,j)+recoI(i,j-1)-recoI(i-1,j-1);
        end
        
%         preI = round((recoI(i-1,j)+recoI(i,j-1))/2);
        
        y = preI - mod(mod(preI,128),64);%�����λ
        
        if error_location_map(i,j) == 0
            recoI(i,j) = y + mod(mod(recoI(i,j),128),64);
%             if error1(i,j) >= error2(i,j)
%                 recoI(i,j) = mod(recoI(i,j)+128,256);
%             else
%                 recoI(i,j) = recoI(i,j);
%             end
%         elseif error_location_map(i,j) == 1
%             if error1(i,j) >= error2(i,j)
%                 recoI(i,j) = recoI(i,j);
%             else
%                 recoI(i,j) = mod(recoI(i,j)+128,256);
%             end
        end       
    end
end

end

