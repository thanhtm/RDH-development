function  [F,num]=construc_F(dct_coef,i,j) %��ȡlsb
F=zeros(1,64)-1;
num=0;
for a=0:7
  for b=0:7
      if a~=0||b~=0  %ȥ��dcϵ��
        if dct_coef(i+a,j+b) ~= -1 && dct_coef(i+a,j+b) ~= 0 && dct_coef(i+a,j+b) ~= 1 %�ų�Ϊ-1��0 ��1��acϵ��
        F(1,num+1)=dct_coef(i+a,j+b)-2*(floor(dct_coef(i+a,j+b)/2));
        num=num+1;
        end
      end
  end
end

