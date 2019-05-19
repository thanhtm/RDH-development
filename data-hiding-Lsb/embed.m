function [ I_stego ] = embed( I,Data,payload )
num=0;%记录已经嵌入秘密信息数
flag=0;
    for i=1:512;
        if(flag==1)
            break;%跳出外层循环
        end
        for j=1:512;
            I(i,j)=I(i,j)-mod(I(i,j),2)+Data(num+1);
            num=num+1;
            if num==payload;%达到嵌入容量
                flag=1;
                break;%跳出内层循环
            end
        end
    end
    I_stego=I;
end

