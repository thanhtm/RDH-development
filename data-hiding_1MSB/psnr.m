function psnrvalue=psnr(origin,test)
I1=double(origin);
I2=double(test);
E=I1-I2;
MSE=mean2(E.*E);
if MSE==0
    psnrvalue=-1;
else
    psnrvalue=10*log10(255*255/MSE);
end
