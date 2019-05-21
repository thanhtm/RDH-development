clear
clc
addpath JPEG_Toolbox\;
addpath imgs\;
rng(12,'twister');        %��ʼ������
payload=4000;
data = round(rand(1,payload)*1);     

%ѡ��Ҫ�����ͼƬ������ͼƬ�����DCT����
imwrite(imread('Splash.tiff'),'Ori_photo.jpg','jpeg','quality',90);     %������������ΪXX��JPEGͼ��
ori_jpeg_info = jpeg_read('Ori_photo.jpg');    %����JPEGͼ��
ori_jpeg = imread('Ori_photo.jpg');       %��ȡԭʼjpegͼ��
stego_jpeg_info = ori_jpeg_info;        %ͼ���������һ�ݣ���Ϊ����ͼ������
quant_tables = ori_jpeg_info.quant_tables{1,1};%��ȡ������
ori_dct = ori_jpeg_info.coef_arrays{1,1};     %��ȡdctϵ��
ori_blockdct = mat2cell(ori_dct,8 * ones(1,64),8 * ones(1,64));      %��ԭ����dct����ָ��4096��8*8��Block
stego_blockdct=ori_blockdct;

%������������32��λ�ý������ȼ�����
[R]=GetR(quant_tables);

%��ȡǰ56��AC1�������Чλ����Ϊ�غɵ�һ����
AC1_LSBs=Get_AC1_LSBs(stego_blockdct,56);
data(1,payload+1:payload+56)=AC1_LSBs;
payload=payload+56;

%ͳ��ÿ����ACϵ��ֵΪ0����Ŀ��������������
[zeronum]=Getzeronum(stego_blockdct);      

%�õ�������
[exchange_table]=Getexchange_table(stego_blockdct);          
store_psnr=zeros(1,32);            %�洢ÿ��Cv��Ӧ��psnr
pos=0;
count=1;
flag=0;
% %
% [ACmatrix,zigzag_blockAC] = GetACmatrix(stego_blockdct);
% [ACmatrix0,ACmatrix1,ACmatrixU]=muti_histograms(ACmatrix);
% [stego_blockdct]=Recovery(ACmatrix0,zigzag_blockAC);
%����СCv��ʼ������ģ��Ƕ�룬��¼ÿ��Cv��Ӧ��psnr
for  Cv=1:32                  
        
        while pos<payload  
                if count>4096 
                    flag=1;
                    break;
                end
                [stego_blockdct,pos]=embed(stego_blockdct,data,pos,zeronum(count,1),zeronum(count,2),Cv,exchange_table,R);    
                count=count+1;
        end
        
        % ��������ͼ�񣬲���¼��Ӧ��PSNR
        stego_dct=cell2mat(stego_blockdct);       %��blockdctϸ��������dct����
        stego_jpeg_info.coef_arrays{1,1} = stego_dct;     %�޸ĺ��dctϵ����д��JPEG��Ϣ
        jpeg_write(stego_jpeg_info,'stego_photo.jpg');     %��������jpegͼ��
        stego_jpeg = imread('stego_photo.jpg');       %��ȡ����jpegͼ��
        if flag==0
           store_psnr(1,Cv)=psnr(ori_jpeg ,stego_jpeg);
        else
            store_psnr(1,Cv)=0;
        end
        
        pos=0;
        count=1;
        flag=0;
        stego_blockdct=ori_blockdct;
end

if store_psnr(1,32)==0
    fprintf('��������\n');
end

%�ҵ���õ�psnr��Ӧ��Cv
[~,best_Cv]=find(store_psnr==max(store_psnr));          

%�����ŵ�Cv����Ƕ�룬���ѱ���ϢǶ�뵽AC1��
Cv=best_Cv;
pos=0;
count=1;
stego_blockdct=ori_blockdct;
while pos<payload  
       [stego_blockdct,pos]=embed(stego_blockdct,data,pos,zeronum(count,1),zeronum(count,2),Cv,exchange_table,R);     
       count=count+1;
end

[side]=Getside(payload,Cv,exchange_table);     %������Ϣ(payload,Cv,exchange_table)��ʮ������תΪ��������
[stego_blockdct]=LSB_en(stego_blockdct,side);       %�ѱ���ϢǶ�뵽AC1��

%��������ͼ�񣬲�����PSNR
stego_dct=cell2mat(stego_blockdct);       %��blockdctϸ��������dct����
stego_jpeg_info.coef_arrays{1,1} = stego_dct;     %�޸ĺ��dctϵ����д��JPEG��Ϣ
jpeg_write(stego_jpeg_info,'stego_photo.jpg');     %��������jpegͼ��
stego_jpeg = imread('stego_photo.jpg');       %��ȡ����jpegͼ��
best_psnr=psnr(ori_jpeg ,stego_jpeg);
fprintf('best_psnr=%f   \n',best_psnr);

fid=fopen('stego_photo.jpg','rb');
bit1=fread(fid,'ubit1');
fclose(fid);
fid=fopen('Ori_photo.jpg','rb');
bit2=fread(fid,'ubit1');
fclose(fid);
increaseTable = length(bit1)-length(bit2);
fprintf('increfilesize=%f \n',increaseTable);
%---------------------------------------------------����Ϊ��ȡ����---------------------------------------------------------------------------
stego_jpeg_info = jpeg_read('stego_photo.jpg');      %����stego-JPEGͼ��
quant_tables = stego_jpeg_info.quant_tables{1,1};%��ȡ������
recov_jpeg_info=stego_jpeg_info;                       %ͼ���������һ�ݣ���Ϊ�ָ�ͼ������
stego_dct= stego_jpeg_info.coef_arrays{1,1};     %��ȡ����ͼ���dctϵ��
%��ȡ���ݣ����ָ�ͼ��
[re_dct,exData]=Recover(stego_dct,quant_tables);

%���ɻָ�ͼ��
recov_jpeg_info.coef_arrays{1,1} = re_dct;        %�޸ĺ��dctϵ�� д�� JPEG��Ϣ
jpeg_write(recov_jpeg_info,'recov_photo.jpg');    %��������jpegͼ��    ���ݽ�����Ϣ �ع�JPEGͼ��
re_jpeg = imread('recov_photo.jpg');       %��ȡ�ָ�jpegͼ��

%�ж������Ƿ�׼ȷ��ȡ��ͼ���Ƿ�׼ȷ�ָ�
ans1=isequal(ori_jpeg,re_jpeg);
ans2=isequal(exData,data);
if ans1==1 && ans2==1
    fprintf('������ȷ��ȡ��ͼ��׼ȷ�ָ�\n');
end

