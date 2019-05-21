clear;
clc;
addpath(genpath('JPEG_Toolbox'));
addpath imgs\;
list=dir('imgs');
k=length(list); %ͼƬ������
sumPSNR20=zeros(1,50);
sumPSNR40=zeros(1,50);
sumPSNR60=zeros(1,50);
sumPSNR80=zeros(1,50);
sumIncrease20=zeros(1,50);
sumIncrease40=zeros(1,50);
sumIncrease60=zeros(1,50);
sumIncrease80=zeros(1,50);
num20=zeros(1,50);
num40=zeros(1,50);
num60=zeros(1,50);
num80=zeros(1,50);
for i=3:k %����img�ļ����е�ÿһ��ͼƬ
    fprintf('%s\n',list(i).name);
    for QF=60%20:20:80
        [psnrTable,increaseTable] = process(list(i).name,QF);
        xx = strcat('result\',list(i).name,num2str(QF));
        name = strcat(xx,'psnrTable.mat');
        save(name,'psnrTable');
        name = strcat(xx,'increaseTable.mat');
        save(name,'increaseTable');
        len = length(psnrTable);
        if QF==20
            for j=1:len
                sumPSNR20(j)=sumPSNR20(j)+psnrTable(j);
                sumIncrease20(j)=sumIncrease20(j)+increaseTable(j);
                num20(j)=num20(j)+1;
            end
        elseif QF==40
            for j=1:len
                sumPSNR40(j)=sumPSNR40(j)+psnrTable(j);
                sumIncrease40(j)=sumIncrease40(j)+increaseTable(j);
                num40(j)=num40(j)+1;
            end
        elseif QF==60
            for j=1:len
                sumPSNR60(j)=sumPSNR60(j)+psnrTable(j);
                sumIncrease60(j)=sumIncrease60(j)+increaseTable(j);
                num60(j)=num60(j)+1;
            end
        else
            for j=1:len
                sumPSNR80(j)=sumPSNR80(j)+psnrTable(j);
                sumIncrease80(j)=sumIncrease80(j)+increaseTable(j);
                num80(j)=num80(j)+1;
            end
        end
    end
end
ansPSNR=zeros(4,50);
ansPSNR(1,:)=sumPSNR20./num20;
ansPSNR(2,:)=sumPSNR40./num40;
ansPSNR(3,:)=sumPSNR60./num60;
ansPSNR(4,:)=sumPSNR80./num80;
ansIncrease=zeros(4,50);
ansIncrease(1,:)=sumIncrease20./num20;
ansIncrease(2,:)=sumIncrease40./num40;
ansIncrease(3,:)=sumIncrease60./num60;
ansIncrease(4,:)=sumIncrease80./num80;
save('PSNR','ansPSNR');
save('FileSize','ansIncrease');