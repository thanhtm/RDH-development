function [zeronum]=Getzeronum(blockdct)    
%�������ܣ�ͳ��ÿ����ACϵ��Ϊ0����Ŀ������AC1��
%����ֵzeronum------��һ��Ϊ��ĺ����꣬�ڶ���Ϊ��������꣬������Ϊ��ACϵ��Ϊ0����Ŀ
zeronum=zeros(64*64,3);        
count=1;
for r=1:64
    for c=1:64
        zeronum(count,1)=r;
        zeronum(count,2)=c;
        blockdct{r,c}(1,1:2)=99;              %�ŵ�ǰ����ϵ��
        zeronum(count,3)=sum(blockdct{r,c}(:)==0);
        count=count+1;
    end
end

end