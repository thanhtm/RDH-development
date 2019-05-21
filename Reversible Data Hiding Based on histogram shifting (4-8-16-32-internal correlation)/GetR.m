function [R,num1,distortion]=GetR(AC,q,cs)
%输入：AC系数块，量化表，分块cs
%输出：嵌入优先R，±1个数，失真
R=0;num1=0;numx=0;
for i=1:cs
    if AC(i)==0
        R=R+2/(q*q);
    elseif abs(AC(i))==1
        num1=num1+1;
    else numx=numx+1;
    end
end
distortion = (numx+num1/2)*q*q;
end