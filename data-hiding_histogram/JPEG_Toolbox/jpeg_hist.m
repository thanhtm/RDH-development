function [num1,num_1] = jpeg_hist(dct_coef)
[m,n] = size(dct_coef);
ac_arrays = zeros();
%%�洢���з���acϵ��
t = 0;
for i = 1:m
    for j = 1:n
        if (mod(i,8) ~= 1) && (mod(j,8) ~= 1) %ȥ��dcϵ��
            if dct_coef(i,j) ~= 0 %�ų�Ϊ0 ��acϵ��
                t = t + 1;
                ac_arrays(t) =  dct_coef(i,j);%�洢����acϵ��
            end
        end
    end
end
hist_info=tabulate(ac_arrays(:));%ͳ��ֱ��ͼ
% figure;bar(hist_info(:,1),hist_info(:,2),0.1);title('Histogram of all nonzero AC coefficients of the Lena image with QF = 80');
num1 = hist_info(find(hist_info(:,1)==1),2);
num_1 = hist_info(find(hist_info(:,1)== -1),2);
end