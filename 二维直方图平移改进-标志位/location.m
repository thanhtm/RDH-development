function  [all_location,k]=location(dct_coef2,i,j)  %�ҳ���ѡacϵ��������
all_location=zeros(64,2);
k=0;
for a=0:7
  for b=0:7
      if a~=0||b~=0  %ȥ��dcϵ��
        if dct_coef2(i+a,j+b) ~= -1 && dct_coef2(i+a,j+b) ~= 0 && dct_coef2(i+a,j+b) ~= 1 %�ų�Ϊ-1��0 ��1��acϵ��
        all_location(k+1,1)=i+a;
        all_location(k+1,2)=j+b;
        k=k+1;
        end
      end
  end
end