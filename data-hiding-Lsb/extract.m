function [ Data_extra ] = extract( I_stego,payload)
num=0;%��¼�Ѿ�Ƕ����ȡ��Ϣ��
flag=0;
Data_extra = zeros(1,payload);
    for i=1:512;
        if(flag==1)
            break;%�������ѭ��
        end
        for j=1:512;
            Data_extra(num+1)=mod(I_stego(i,j),2);
            num=num+1;
            if num==payload;%�ﵽǶ������
                flag=1;
                break;%�����ڲ�ѭ��
            end
        end
    end
end

