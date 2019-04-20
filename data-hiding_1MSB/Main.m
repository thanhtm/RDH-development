clear
clc
% I = imread('����ͼ��\Airplane.tiff');
I = imread('����ͼ��\Lena.tiff');
% I = imread('����ͼ��\Man.tiff');
% I = imread('����ͼ��\Jetplane.tiff');
% I = imread('����ͼ��\Baboon.tiff');
% I = imread('����ͼ��\Tiffany.tiff');
origin_I = double(I); 
%% ������������������
num = 10000000;
rand('seed',0); %��������
Data = round(rand(1,num)*1); %�����ȶ������
payload = 10000000;
%% ����Ƕ�����ȡ
[ error_location_map ] = Predictor2( origin_I );%ͼ��λ��ͼԤ��
[ encryptI ] = Encrypted( origin_I );%ͼ����ܺ���
[ numData,emdData,stegoI,flag_mark,flag ] = embed( encryptI,Data,payload,error_location_map ); %����Ƕ��
[ numData2,extData,recoI ] = extract( stegoI,payload,flag_mark,error_location_map ); %������ȡ��ͼ���ع�
%% ͼ��Ա�
figure;
subplot(221);imshow(origin_I,[]);title('ԭʼͼ��');
subplot(222);imshow(encryptI,[]);title('����ͼ��');
subplot(223);imshow(stegoI,[]);title('����ͼ��');
subplot(224);imshow(recoI,[]);title('�ָ�ͼ��');
%% �жϽ���Ƿ���ȷ
check1 = isequal(emdData,extData);
check2 = isequal(recoI,I);
if check1 == 1
    disp('��ȡ������Ƕ��������ȫ��ͬ��')
else
    disp('Warning��������ȡ����')
end
if check2 == 1
    disp('�ع�ͼ����ԭʼͼ����ȫ��ͬ��')
else
    disp('Warning��ͼ���ع�����')
end
%% ������
if check1 == 1 && check2 == 1
    [m,n] = size(I);
    bpp = numData/(m*n);
    disp(['Embedding capacity equal to : ' num2str(numData)])
    disp(['Embedding rate equal to : ' num2str(bpp)])
    fprintf(['�ò���ͼ��------------ OK','\n\n']);
else
    fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
end