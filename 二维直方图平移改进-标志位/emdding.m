function [jpeg_info_stego,E0,E1]=emdding(Data,dct_coef,jpeg_info,payload,lsb_bit)
%% ��ȡÿ���ӿ����ACϵ����lsb,����F1
lsb_num=0;
[m,n]=size(dct_coef);
F1=zeros(1,lsb_bit)-1;
 for i = 9:8:m-15
    for j = 9:8:n-15
        if lsb_num==lsb_bit
            break;
        end
        [F,num]=construc_F(dct_coef,i,j);
        if num>0
            a=1;
            while F(a)~=-1&&lsb_num~=lsb_bit
                F1(lsb_num+1)=F(a);
                lsb_num=lsb_num+1;
                a=a+1;
            end         
        end
    end
 end
%% ��LSB����
dct_coef2=dct_coef;
for i = 9:m-8
    for j = 9:n-8
        if (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %ȥ��dcϵ��
            if dct_coef2(i,j) ~= -1 && dct_coef2(i,j) ~= 0 && dct_coef2(i,j) ~= 1 %�ų�Ϊ-1��0 ��1��acϵ��
                if  dct_coef2(i,j)>0
                dct_coef2(i,j)=2*(floor(dct_coef2(i,j)/2));
                else
                dct_coef2(i,j)=2*(ceil(dct_coef2(i,j)/2));
                end
            end
        end
    end
end
%% ���п�Ԥ��
sum=0;
for i=9:8:m-15
    for j=9:8:n-15
        [all_location,k]=location(dct_coef2,i,j);
        all_choice=choice(k);
        sum=sum+k;
        dct_coef2=bolck_xiaoyin(dct_coef2,all_choice,all_location,k,i,j);
        if sum>=lsb_bit
            break;
        end
    end
    if sum>=lsb_bit
            break;
     end
end
%% ��ȡԤ��LSB������F2
lsb_num=0;
F2=zeros(1,lsb_bit)-1;
for i = 9:8:m-15
    for j = 9:8:n-15
        if lsb_num==lsb_bit
            break;
        end
        [F,num]=construc_F(dct_coef2,i,j);
        if num>0
            a=1;
            while F(a)~=-1&&lsb_num~=lsb_bit
                F2(lsb_num+1)=F(a);
                lsb_num=lsb_num+1;
                a=a+1;
            end         
        end
    end
end
%% ����F2,��F1���࣬�õ�E0��E1
E0=zeros(1,lsb_num)-1;
E1=zeros(1,lsb_num)-1;
i=0;
j=0;
for k=1:lsb_num
    if F2(k)==0
        E0(i+1)=F1(k);
        i=i+1;
    else
        E1(j+1)=F1(k);
        j=j+1;
    end
end
E0=E0(1:i);
E1=E1(1:j);
TestArith_me(E0); %ѹ��E0����bits
TestArith_me(E1);
%% Ƕ������,��Ӧ�ý��������ݺ�E0,E1��Ƕ��ģ�������дѹ�����룬����ֻǶ������������
dct_coef3=dct_coef;
k=0;
for i = 9:8:m-15
    for j = 9:8:n-15
        if k==payload
            break;
        end
        [dct_coef3,num]=Data_emdding(dct_coef3,Data,payload,k,i,j);
        k=k+num;
    end
end
jpeg_info_stego=jpeg_info;
jpeg_info_stego.coef_arrays{1,1} =dct_coef3;