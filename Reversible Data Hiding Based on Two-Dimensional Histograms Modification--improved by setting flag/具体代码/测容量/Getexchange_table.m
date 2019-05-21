function [exchange_table]=Getexchange_table(ori_blockdct)
%�������ܣ��õ�������Ϊһ��Ϊ32��һά����
%�������Ԫ��Ϊ0����ʾ(AC2i-2, AC2i-1)����ʽ�ɶԣ��������Ԫ��Ϊ1����ʾ(AC2i-1, AC2i-2)����ʽ�ɶ�
 exchange_table=zeros(1,32);
 count=1;
 store_C=zeros(32,2);

for i=1:2:63                             
    
    for r=1:64
        for c=1:64
            Z_dct=GetZigzag(ori_blockdct{r,c});
            x=Z_dct(1,i);
            y=Z_dct(1,i+1);
            
            %���(x,y)��C���͵�ϵ����
            if abs(x)>1 && abs(y)==1      
                store_C(count,1)=store_C(count,1)+1;
            end
            
            %���(y,x)��C���͵�ϵ����
            if abs(y)>1 && abs(x)==1
                store_C(count,2)=store_C(count,2)+1;
            end
            
        end
    end
    
    count=count+1;
end

%��k�ԣ������(y,x)�ɶԵ�C��������Ҫ������(x,y)�ɶԵ�C���������򽫽�����ĵ�k��Ԫ����1
for i=1:32
    if store_C(i,1)<store_C(i,2)
        exchange_table(1,i)=1;
    end
end

