function [ Data_extra ] = extract( I_stego,payload)
num=0;%记录已经嵌入提取信息数
flag=0;
Data_extra = zeros(1,payload);
    for i=1:512;
        if(flag==1)
            break;%跳出外层循环
        end
        for j=1:512;
            Data_extra(num+1)=mod(I_stego(i,j),2);
            num=num+1;
            if num==payload;%达到嵌入容量
                flag=1;
                break;%跳出内层循环
            end
        end
    end
end

