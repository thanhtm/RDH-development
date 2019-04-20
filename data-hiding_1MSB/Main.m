clear
clc
% I = imread('测试图像\Airplane.tiff');
I = imread('测试图像\Lena.tiff');
% I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
%% 产生二进制秘密数据
num = 10000000;
rand('seed',0); %设置种子
Data = round(rand(1,num)*1); %产生稳定随机数
payload = 10000000;
%% 数据嵌入和提取
[ error_location_map ] = Predictor2( origin_I );%图像位置图预测
[ encryptI ] = Encrypted( origin_I );%图像加密函数
[ numData,emdData,stegoI,flag_mark,flag ] = embed( encryptI,Data,payload,error_location_map ); %数据嵌入
[ numData2,extData,recoI ] = extract( stegoI,payload,flag_mark,error_location_map ); %数据提取及图像重构
%% 图像对比
figure;
subplot(221);imshow(origin_I,[]);title('原始图像');
subplot(222);imshow(encryptI,[]);title('加密图像');
subplot(223);imshow(stegoI,[]);title('载密图像');
subplot(224);imshow(recoI,[]);title('恢复图像');
%% 判断结果是否正确
check1 = isequal(emdData,extData);
check2 = isequal(recoI,I);
if check1 == 1
    disp('提取数据与嵌入数据完全相同！')
else
    disp('Warning！数据提取错误！')
end
if check2 == 1
    disp('重构图像与原始图像完全相同！')
else
    disp('Warning！图像重构错误！')
end
%% 结果输出
if check1 == 1 && check2 == 1
    [m,n] = size(I);
    bpp = numData/(m*n);
    disp(['Embedding capacity equal to : ' num2str(numData)])
    disp(['Embedding rate equal to : ' num2str(bpp)])
    fprintf(['该测试图像------------ OK','\n\n']);
else
    fprintf(['该测试图像------------ ERROR','\n\n']);
end