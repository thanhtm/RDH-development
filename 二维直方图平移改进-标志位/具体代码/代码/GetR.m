function [R]=GetR(quant_tables)
%�������ܣ���32��λ�ý������ȼ�����
%ÿ��λ�ã��������������ӣ�����ȡ���ǵ�ƽ��ֵ�ĵ��������ֵԽ�����ȼ�Խ��
R=zeros(32,2);
Z_qtable=GetZigzag(quant_tables);
for count=1:32
   R(count,1)=count;
   R(count,2)=2/(Z_qtable(1,2*count-1)+Z_qtable(1,2*count));
end
R=sortrows(R,-2);     %���ڶ��н���������
   
   