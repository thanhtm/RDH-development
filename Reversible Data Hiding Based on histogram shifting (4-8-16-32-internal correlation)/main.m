clear;
clc;
addpath(genpath('JPEG_Toolbox'));
rng(100,'twister');
cnt1=1;
for nn=8000%:1000:2000
data = round(rand(1,nn)*1);%�������01���أ���ΪǶ�������
imwrite(imread('imgs/lena.tiff'),'ori.jpg','jpeg','quality',80);%������������ΪXX��JPEGͼ��
ori_jpeg_info = jpeg_read('ori.jpg');%����JPEGͼ��
stego_jpeg_info = ori_jpeg_info;%�ļ�����һ�ݣ���Ϊ����ͼ��
quant_tables = ori_jpeg_info.quant_tables{1,1};%��ȡ������
oridct = ori_jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
oriBlockdct = mat2cell(oridct,8 * ones(1,64),8 * ones(1,64));%��ԭ����ͼ�����ָ��N��8*8��Block

%�õ�AC����
[ACmatrix,zigzag_blockAC] = GetACmatrix(oriBlockdct);
payload=length(data);
%����ʧ��ѡ�����t
[t,allbest]=GetT(ACmatrix,quant_tables,payload);

%�����������
[best]=GetBest(ACmatrix,quant_tables,t);
% 
%[ACmatrix0,ACmatrix1,ACmatrixU]=muti_histograms(ACmatrix)
%Ƕ�����
pos=1;
count=1;
while pos<payload
    [ACmatrix,pos]=embed(ACmatrix,data,pos,best(count,:),t);
    count=count+1;
end
%ACmatrix=ACmatrix0+ACmatrix1+ACmatrixU;
%��AC����ԭ��������ʽ
[stego_blockdct]=Recovery(ACmatrix,zigzag_blockAC);

%�������Ϣ
side = Getside(t);

[stego_blockdct]=LSB_en(stego_blockdct,side);

%�õ�����ͼ��
stego_dct=cell2mat(stego_blockdct);
stego_jpeg_info.coef_arrays{1,1} = stego_dct;   %�޸ĺ��DCTϵ����д��JPEG��Ϣ
jpeg_write(stego_jpeg_info,'stego.jpg');    %��������jpegͼ�񣬸��ݽ�����Ϣ���ع�JPEGͼ�񣬻������ͼ��

%��ȡPSNR���ļ�����
ori_jpeg = imread('ori.jpg');   %��ȡԭʼjpegͼ��
stego_jpeg = imread('stego.jpg')    ;%��ȡ����jpegͼ��
psnrTable(cnt1)=psnr(ori_jpeg,stego_jpeg);
fid=fopen('stego.jpg','rb');
bit1=fread(fid,'ubit1');
fclose(fid);
fid=fopen('ori.jpg','rb');
bit2=fread(fid,'ubit1');
fclose(fid);
increaseTable(cnt1) = length(bit1)-length(bit2);

 cnt1=cnt1+1;
end