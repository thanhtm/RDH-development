function [stego_blockdct]=LSB_en(stego_blockdct,side)     
%�������ܣ�������ϢǶ�뵽AC1��

for i=1:56
    stego_blockdct{1,i}(1,2)=stego_blockdct{1,i}(1,2)-mod(stego_blockdct{1,i}(1,2),2)+side(i);
end

end