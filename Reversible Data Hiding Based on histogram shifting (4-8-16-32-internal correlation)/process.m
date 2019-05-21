function [psnrTable,increaseTable] = process(name,QF)
addpath JPEG_Toolbox\;
addpath img\;

imwrite(imread(name),'ori.jpg','jpeg','quality',QF); %����QFΪXX��ori.jpg
ori_jpeg_info = jpeg_read('ori.jpg');%����JPEGͼ��
oridct = ori_jpeg_info.coef_arrays{1,1}; %��ȡdctϵ��
maxlen = length(find(oridct==1)) + length(find(oridct==-1))-500; %��ȡ���Ƕ�볤��

cnt1=1;
for nn=2000:2000:maxlen
rng(100,'twister');
data = round(rand(1,nn)*1);%�������01���أ���ΪǶ�������
imwrite(imread(name),'ori.jpg','jpeg','quality',QF);%������������ΪXX��JPEGͼ��
ori_jpeg_info = jpeg_read('ori.jpg');%����JPEGͼ��
stego_jpeg_info = ori_jpeg_info;%�ļ�����һ�ݣ���Ϊ����ͼ��
quant_tables = ori_jpeg_info.quant_tables{1,1};%��ȡ������
oridct = ori_jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
oriBlockdct = mat2cell(oridct,8 * ones(1,64),8 * ones(1,64));%��ԭ����ͼ�����ָ��N��8*8��Block

%�õ�AC����
[ACmatrix,zigzag_blockAC] = GetACmatrix(oriBlockdct);

%����ʧ��ѡ�����t
payload=length(data);
[t,~]=GetT(ACmatrix,quant_tables,payload);
%t=4096;

%�����������
[best]=GetBest(ACmatrix,quant_tables,t);

%Ƕ�����
pos=1;
count=1;
while pos<payload
    [ACmatrix,pos]=embed(ACmatrix,data,pos,best(count,:),t);
    count=count+1;
end

%��AC����ԭ��������ʽ
[stego_blockdct]=Recovery(ACmatrix,zigzag_blockAC);

%�������Ϣ
%side = Getside(t);
side = [0,1];
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
if cnt1==1
    psnrTable=[0,0];
    increaseTable=[0,0];
end
end