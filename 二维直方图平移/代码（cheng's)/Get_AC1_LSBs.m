function AC1_LSBs=Get_AC1_LSBs(blockdct,n)
%�������ܣ�ȡ��ǰn��AC1�������Чλ

AC1_LSBs=zeros(1,n);
count=1;
for r=1:64
    for c=1:64
       if count>n
          break
       end
    if mod(blockdct{r,c}(1,2),2)==0
        AC1_LSBs(1,count)=0;
    else
        AC1_LSBs(1,count)=1;
    end
    count=count+1;
    end
end

end
        