function [re_dct,exData]=Recover(stego_dct)
%�������ܣ���ȡ���ݣ����ָ�ͼ��
%����ֵre_dctΪ�ָ����dct����exDataΪ��ȡ������

exData=zeros();
stego_blockdct = mat2cell(stego_dct,8 * ones(1,64),8 * ones(1,64));         %��dct����ָ��4096��8*8��Block
rec_blockdct=stego_blockdct;

%ͳ��ÿ����ACϵ��Ϊ0����Ŀ
[zeronum]=Getzeronum(rec_blockdct);         

%��AC1����ȡ(payload,Cv,Th)
side=Get_AC1_LSBs(rec_blockdct,30);            %��ȡǰ30��AC1�������Чλ
[payload,Cv,Th]=Extside(side);          %��side����ȡpayload,Cv,Th

%��ȡ+�ָ�
pos=0;
count=1;
while pos<payload  
    if zeronum(count,3)>=Th                 %��ϵ������Th�Ŀ������ȡ
       [rec_blockdct,exData,pos]=extract(rec_blockdct,exData,pos,payload,zeronum(count,1),zeronum(count,2),Cv);  %��ȡ����
    end
    count=count+1;
end

%�ָ�ǰ30��AC1�������Чλ
for i=1:30
    rec_blockdct{1,i}(1,2)=rec_blockdct{1,i}(1,2)-mod(rec_blockdct{1,i}(1,2),2)+exData(payload-30+i);
end

re_dct=cell2mat(rec_blockdct);             %��blockdctϸ��������dct����

end