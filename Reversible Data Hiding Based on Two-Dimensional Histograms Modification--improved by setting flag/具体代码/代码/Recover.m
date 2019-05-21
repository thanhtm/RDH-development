function [re_dct,exData]=Recover(stego_dct,quant_tables)
%�������ܣ���ȡ���ݣ����ָ�ͼ��
%����ֵre_dctΪ�ָ����dct����exDataΪ��ȡ������

exData=zeros();
stego_blockdct = mat2cell(stego_dct,8 * ones(1,64),8 * ones(1,64));         %��dct����ָ��4096��8*8��Block
rec_blockdct=stego_blockdct;

%ͳ��ÿ����ACϵ��Ϊ0����Ŀ��������������
[zeronum]=Getzeronum(rec_blockdct);         

%������������32��λ�ý������ȼ�����
[R]=GetR(quant_tables);

%��AC1����ȡ(payload,Cv,exchange_table)
side=Get_AC1_LSBs(rec_blockdct,56);            %��ȡǰ56��AC1�������Чλ
[payload,Cv,exchange_table]=Extside(side);          %��side����ȡpayload,Cv,exchange_table

%��ȡ+�ָ�
pos=0;
count=1;
while pos<payload  
       [rec_blockdct,exData,pos]=extract(rec_blockdct,exData,pos,payload,zeronum(count,1),zeronum(count,2),Cv,exchange_table,R);  %��ȡ����
       count=count+1;
end

%�ָ�ǰ56��AC1�������Чλ
for i=1:56
    rec_blockdct{1,i}(1,2)=rec_blockdct{1,i}(1,2)-mod(rec_blockdct{1,i}(1,2),2)+exData(payload-56+i);
end

re_dct=cell2mat(rec_blockdct);             %��blockdctϸ��������dct����

end