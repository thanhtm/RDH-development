function [ I_stego ] = embed( I,Data,payload )
num=0;%��¼�Ѿ�Ƕ��������Ϣ��
flag=0;
    for i=1:512;
        if(flag==1)
            break;%�������ѭ��
        end
        for j=1:512;
            I(i,j)=I(i,j)-mod(I(i,j),2)+Data(num+1);
            num=num+1;
            if num==payload;%�ﵽǶ������
                flag=1;
                break;%�����ڲ�ѭ��
            end
        end
    end
    I_stego=I;
end

