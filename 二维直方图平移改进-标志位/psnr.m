function psnrvalue = psnr(originI,stegoI)
%�õ�ԭʼͼ��originI������ͼ��stegoI��PSNRֵ
I1=double(originI);
I2=double(stegoI);
E=I1-I2;
MSE=mean2(E.*E);
if MSE==0
    psnrvalue=-1;
else
    psnrvalue=10*log10(255*255/MSE);
end