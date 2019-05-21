clear
clc
%JPEG�������ߵĵ�ǰ·�� ����ʵ�����
addpath(genpath('JPEG_Toolbox'));
payload =100; %Ƕ���������Ʊ���
Data = round(rand(1,payload)*1);%�������01���أ���ΪǶ�������
lsb_bit=200;%����Ƕ���lsb����Ҫ>payload
I = imread('Lena.tiff');
i = 80;%60,70,80
QF = i;%��������
imwrite(I,'Lena.jpg','jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��
imwrite(I,'Ori_Lena.jpg','jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��
%% ����JPEG�ļ�
jpeg_info = jpeg_read('Lena.jpg');%����JPEGͼ�� jpeg_read�����ǽ��������еĺ��� ֱ�ӵ���
ori_jpeg_80 = imread('Lena.jpg');%��ȡԭʼjpegͼ��
quant_tables = jpeg_info.quant_tables{1,1};%��ȡ������ 
dct_coef = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
%% Ƕ������
[jpeg_info_stego,E0,E1]=emdding(Data,dct_coef,jpeg_info,payload,lsb_bit);
jpeg_write(jpeg_info_stego,'stego_Lena.jpg');%��������jpegͼ��  jpeg_write�����ǽ��������еĺ���  ���ݽ�����Ϣ �ع�JPEGͼ��
stego_jpeg_80 = imread('stego_Lena.jpg');%��ȡ����jpegͼ�� 
%% ��ȡ����
stego_jpeg_info = jpeg_read('stego_Lena.jpg');%�ٴν���JPEG ����ͼ��  
[stego_jpeg_info,extData] = extract(stego_jpeg_info,payload,lsb_bit,E0,E1); %��ȡ����
jpeg_write(stego_jpeg_info,'re_Lena.jpg');%����ָ�jpegͼ�� 
re_jpeg_80 = imread('re_Lena.jpg');%��ȡ�ָ�jpegͼ��
%% ��ʾ
figure;
subplot(221);imshow(I);title('tiffԭʼͼ��');%��ʾԭʼͼ��
subplot(222);imshow(ori_jpeg_80);title('jpegԭʼͼ��');%��ʾJPEGѹ��ͼ��
subplot(223);imshow(stego_jpeg_80);title('����ͼ��');%��ʾstego_jpeg_80
subplot(224);imshow(re_jpeg_80);title('�ָ�ͼ��');%��ʾ�ָ�ͼ��
%% ͼ�������Ƚ�
psnrvalue1 = psnr(ori_jpeg_80,stego_jpeg_80);%�Ƚ� ԭʼͼ�� �� ����ͼ��
psnrvalue2 = psnr(ori_jpeg_80,re_jpeg_80);%�Ƚ� ԭʼͼ�� �� �ָ�ͼ��
v = isequal(Data,extData);
if psnrvalue2 == -1
    disp('�ָ�ͼ����ԭʼͼ����ȫһ�¡�');
elseif psnrvalue2 ~= -1
    disp('warning���ָ�ͼ����ԭʼͼ��һ�£�');
end
if v == 1
    disp('��ȡ������Ƕ��������ȫһ�¡�');
elseif v ~= 1
    disp('warning����ȡ������Ƕ�����ݲ�һ��!');
end
%% �ļ���С���ӷ���
ori_filesize = imfinfo('Ori_Lena.jpg');
steo_filesize = imfinfo('stego_Lena.jpg');
Lena_increased_fs = (ori_filesize.FileSize -steo_filesize.FileSize);        %��λ���ֽڣ�