clear
clc
addpath(genpath('JPEG_Toolbox'));
addpath(genpath('img'));
imgname='lena.tiff';
%imgname='Baboon.tiff';
%imgname='Pepper.tiff';
%imgname='Tiffany.tiff';
Data = round(rand(1,100000)*1);%�������01���أ���ΪǶ�������
count1=1;
for QF=30:20:90;   
count2=1;
for  payload=2000:2000:100000;
%% ����Ƕ��
%% ����JPEG�ļ�
I = imread(imgname);
imwrite(I,'ori.jpg','jpeg','quality',QF);%������������ΪQF��JPEGͼ��
jpeg_info = jpeg_read('ori.jpg');%����JPEGͼ��
stego_jpeg_info =jpeg_info;%�ļ�����һ�ݣ���Ϊ����ͼ��
quant_tables = jpeg_info.quant_tables{1,1};%��ȡ������
dct_coef = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
[num1,num_1] = jpeg_hist(dct_coef);%���Ʒ���acϵ��ֱ��ͼ num1=+1����  num_1=-1����
oriBlockdct = mat2cell(dct_coef,8 * ones(1,64),8 * ones(1,64));
[ACmatrix,zigzag_blockAC] = GetACmatrix(oriBlockdct);
if payload <= num1+num_1;
    [emdData,numData,ACmatrix,index] = jpeg_emdding(Data,ACmatrix,payload);
else
    break;
end
[stego_blockdct]=Recovery(ACmatrix,zigzag_blockAC);
stego_dct=cell2mat(stego_blockdct);
stego_jpeg_info.coef_arrays{1,1} = stego_dct;   %�޸ĺ��DCTϵ����д��JPEG��Ϣ
jpeg_write(stego_jpeg_info,'stego.jpg');    %��������jpegͼ�񣬸��ݽ�����Ϣ���ع�JPEGͼ�񣬻������ͼ��
%% ��ʾ
figure(1);
subplot(221);imshow(I);title('tiffԭʼͼ��');%��ʾԭʼͼ��
subplot(222);imshow(imread('ori.jpg'));title('jpegԭʼͼ��');%��ʾJPEGѹ��ͼ��
subplot(223);imshow(imread('stego.jpg'));title('����ͼ��');%��ʾJPEG����ͼ��
pause(0.1)
%% ��ȡPSNR���ļ����� ���������Ϣ
result(count1,count2).QF=QF;
result(count1,count2).capacity=num1+num_1;
result(count1,count2).payload=payload;
ori_jpeg = imread('ori.jpg');   %��ȡԭʼjpegͼ��
stego_jpeg = imread('stego.jpg')    ;%��ȡ����jpegͼ��
result(count1,count2).psnr=psnr(ori_jpeg,stego_jpeg);

fid=fopen('stego.jpg','rb');
bit1=fread(fid,'ubit1');
fclose(fid);
fid=fopen('ori.jpg','rb');
bit2=fread(fid,'ubit1');
fclose(fid);
result(count1,count2).increase= length(bit1)-length(bit2);
A(count1,count2)=result(count1,count2).psnr;
B(count1,count2)=result(count1,count2).increase;
count2=count2+1;
end
count1=count1+1;
end