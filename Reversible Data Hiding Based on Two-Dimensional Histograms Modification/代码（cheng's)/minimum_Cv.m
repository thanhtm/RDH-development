function [min_Cv]=minimum_Cv(stego_blockdct,data,zeronum)   
%�������ܣ��ҵ�������Ƕ����������СCv

pos=0;
count=1;
payload=length(data);
stego_blockdct_2=stego_blockdct;
flag=0;

%Cv��С�������ģ��Ƕ�룬���������Ƕ������������ѭ��
for min_Cv=2:32         
    while pos<payload && count<=4096
    [stego_blockdct_2,pos]=embed(stego_blockdct_2,data,pos,zeronum(count,1),zeronum(count,2),min_Cv);     %Ƕ�룬����ֵstego_blockdct_2ΪǶ����dct���󣬷���ֵpos��ʾ��Ƕ���������
    count=count+1;
    end
    if pos>=payload && count<=4097                   %�������㣬����ѭ��
        flag=1;
        break
    end
    stego_blockdct_2=stego_blockdct;
    pos=0;
    count=1;
end

if flag==0
    fprintf("����������\n");
end

end
