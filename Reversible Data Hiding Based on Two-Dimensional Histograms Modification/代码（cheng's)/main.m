clear
clc

addpath JPEG_Toolbox\;
addpath imgs\;

rng(12,'twister');        %��ʼ������
payload=3000;
data = round(rand(1,payload)*1);     

%ѡ��Ҫ�����ͼƬ������ͼƬ�����DCT����
imwrite(imread('Lax.tiff'),'Ori_photo.jpg','jpeg','quality',80);     %������������ΪXX��JPEGͼ��
ori_jpeg_info = jpeg_read('Ori_photo.jpg');    %����JPEGͼ��
ori_jpeg = imread('Ori_photo.jpg');       %��ȡԭʼjpegͼ��
stego_jpeg_info = ori_jpeg_info;        %ͼ���������һ�ݣ���Ϊ����ͼ������
ori_dct = ori_jpeg_info.coef_arrays{1,1};     %��ȡdctϵ��
ori_blockdct = mat2cell(ori_dct,8 * ones(1,64),8 * ones(1,64));      %��ԭ����dct����ָ��4096��8*8��Block
stego_blockdct=ori_blockdct;

%��ȡǰ30��AC1�������Чλ����Ϊ�غɵ�һ����
AC1_LSBs=Get_AC1_LSBs(stego_blockdct,30);
data(1,payload+1:payload+30)=AC1_LSBs;
payload=payload+30;

%ͳ��ÿ����ACϵ��ֵΪ0����Ŀ
[zeronum]=Getzeronum(stego_blockdct);         

%�ҵ�������Ƕ����������СCv
[min_Cv]=minimum_Cv(stego_blockdct,data,zeronum);              

result=zeros((32-min_Cv+1)*63,3);           %��¼ʵ��������ʽΪ��Cv��Th��PSNR��
num=1;
pos=0;
count=1;
flag=1;

%��������������СCv��ʼ������ģ��Ƕ�룬��¼ÿ��{Cv��Th}��Ӧ��psnr
for  Cv=min_Cv:32                  
    for Th=0:62
        
        while pos<payload  
             if zeronum(count,3)>=Th         %��ϵ������Th�Ŀ鱻����Ƕ��
                [stego_blockdct,pos]=embed(stego_blockdct,data,pos,zeronum(count,1),zeronum(count,2),Cv);    
             end
             count=count+1;
             if count>4096           %����������flag��0
                 flag=0;
                 break;
             end
        end

        % ��������ͼ�񣬲���¼��Ӧ��PSNR
        if flag==1
        stego_dct=cell2mat(stego_blockdct);       %��blockdctϸ��������dct����
        stego_jpeg_info.coef_arrays{1,1} = stego_dct;     %�޸ĺ��dctϵ����д��JPEG��Ϣ
        jpeg_write(stego_jpeg_info,'stego_photo.jpg');     %��������jpegͼ��
        stego_jpeg = imread('stego_photo.jpg');       %��ȡ����jpegͼ��
        result(num,1)=Cv;
        result(num,2)=Th;
        result(num,3)=psnr(ori_jpeg ,stego_jpeg);
        else
        result(num,1)=Cv;
        result(num,2)=Th;
        result(num,3)=0;
        end
        
        flag=1;
        num=num+1;
        pos=0;
        count=1;
        stego_blockdct=ori_blockdct;
    end
end

%�������ݣ��ҵ����ŵ�Cv��Th
result=sortrows(result,-3);
best_Cv=result(1,1);
best_Th=result(1,2);

%�����ŵ�Cv��Th����Ƕ�룬���ѱ���ϢǶ�뵽AC1��
Cv=best_Cv;
Th=best_Th;
pos=0;
count=1;
stego_blockdct=ori_blockdct;
while pos<payload  
    if zeronum(count,3)>=Th            %��ϵ������Th�Ŀ鱻����Ƕ��
       [stego_blockdct,pos]=embed(stego_blockdct,data,pos,zeronum(count,1),zeronum(count,2),Cv);     
    end
    count=count+1;
end

[side]=Getside(payload,Cv,Th);     %������Ϣ(payload,Cv,Th)��ʮ������תΪ��������
[stego_blockdct]=LSB_en(stego_blockdct,side);       %�ѱ���ϢǶ�뵽AC1��

%��������ͼ�񣬲�����PSNR
stego_dct=cell2mat(stego_blockdct);       %��blockdctϸ��������dct����
stego_jpeg_info.coef_arrays{1,1} = stego_dct;     %�޸ĺ��dctϵ����д��JPEG��Ϣ
jpeg_write(stego_jpeg_info,'stego_photo.jpg');     %��������jpegͼ��
stego_jpeg = imread('stego_photo.jpg');       %��ȡ����jpegͼ��


best_psnr=psnr(ori_jpeg ,stego_jpeg);
fprintf("best_psnr=%f   \n",best_psnr);





%---------------------------------------------------����Ϊ��ȡ����---------------------------------------------------------------------------



stego_jpeg_info = jpeg_read('stego_photo.jpg');      %����stego-JPEGͼ��
recov_jpeg_info=stego_jpeg_info;                       %ͼ���������һ�ݣ���Ϊ�ָ�ͼ������
stego_dct= stego_jpeg_info.coef_arrays{1,1};     %��ȡ����ͼ���dctϵ��

%��ȡ���ݣ����ָ�ͼ��
[re_dct,exData]=Recover(stego_dct);

%���ɻָ�ͼ��
recov_jpeg_info.coef_arrays{1,1} = re_dct;        %�޸ĺ��dctϵ�� д�� JPEG��Ϣ
jpeg_write(recov_jpeg_info,'recov_photo.jpg');    %��������jpegͼ��    ���ݽ�����Ϣ �ع�JPEGͼ��
re_jpeg = imread('recov_photo.jpg');       %��ȡ�ָ�jpegͼ��

%�ж������Ƿ�׼ȷ��ȡ��ͼ���Ƿ�׼ȷ�ָ�
ans1=isequal(ori_jpeg,re_jpeg);
ans2=isequal(exData,data);
if ans1==1 && ans2==1
    fprintf("������ȷ��ȡ��ͼ��׼ȷ�ָ�\n");
end