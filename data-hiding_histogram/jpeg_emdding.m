function [emdData,numData,ACmatrix,index] = jpeg_emdding(Data,ACmatrix,payload)
numData = 0;
%����0�ĸ����Ӵ�С��������Ƕ��0������Ŀ顣
temp=ACmatrix;
for i=1:63;
    for j=1:4096;
        if ACmatrix(i,j)==0;
            temp(i,j)=1;
        else
            temp(i,j)=0;
        end
    end
end
temp=sum(temp);%һά���飬1-4096��0�ĸ���
[~,index]=sort(temp,'descend');
%��ʼǶ��,������ĸ����Ӵ�С
for i = 1:4096;
     for j = 1:63
            if ACmatrix(j,index(i)) ~= 0 %�ų�Ϊ0 ��acϵ��
                if numData == payload
                    break;
                end
                if ACmatrix(j,index(i)) > 1
                    ACmatrix(j,index(i)) = ACmatrix(j,index(i)) +1;
                elseif ACmatrix(j,index(i)) < -1
                    ACmatrix(j,index(i)) = ACmatrix(j,index(i)) -1;
                elseif ACmatrix(j,index(i)) == 1
                    numData = numData + 1;
                    ACmatrix(j,index(i)) = ACmatrix(j,index(i)) + Data(numData);
                elseif ACmatrix(j,index(i)) == -1
                    numData = numData + 1;
                    ACmatrix(j,index(i)) = ACmatrix(j,index(i)) - Data(numData);
                end
            end
        end
    end

emdData = Data(1:numData);%Ƕ�������
end