clear
clc

addpath JPEG_Toolbox\;
addpath imgs\;


%ѡ��Ҫ�����ͼƬ������ͼƬ�����DCT����
imwrite(imread('Baboon.tiff'),'Ori_photo.jpg','jpeg','quality',90);     %������������ΪXX��JPEGͼ��
ori_jpeg_info = jpeg_read('Ori_photo.jpg');    %����JPEGͼ��
ori_jpeg = imread('Ori_photo.jpg');       %��ȡԭʼjpegͼ��
stego_jpeg_info = ori_jpeg_info;        %ͼ���������һ�ݣ���Ϊ����ͼ������
ori_dct = ori_jpeg_info.coef_arrays{1,1};     %��ȡdctϵ��
ori_blockdct = mat2cell(ori_dct,8 * ones(1,64),8 * ones(1,64));      %��ԭ����dct����ָ��4096��8*8��Block

TypeA=0;
TypeB=0;
TypeC=0;
TypeD=0;
TypeE=0;
TypeF=0;

for r=1:64
    for c=1:64
       Z_dct=GetZigzag(ori_blockdct{r,c});
       for i=3:2:63
          x=Z_dct(1,i);
          y=Z_dct(1,i+1);
          
          if (x==-1 && y==1) || (x==1 && y==1) || (x==1 && y==-1) || (x==-1 && y==-1)
              TypeA=TypeA+1;
          elseif (x==0 && y==1) || (x==1 && y==0) || (x==0 && y==-1) || (x==-1 && y==0)
              TypeB=TypeB+1;
          elseif abs(x)>1 && abs(y)==1
              TypeC=TypeC+1;
          elseif abs(x)>1 && y==0
              TypeD=TypeD+1;
          elseif abs(y)>1
              TypeE=TypeE+1;
          elseif x==0 && y==0
              TypeF=TypeF+1;
          end
          
       end
    end
end

capacity=TypeA*log2(3)+TypeB+TypeC-30;
fprintf('����չϵ���Ե���Ŀ %d, �������Ϊ %d����\n',TypeA+TypeB+TypeC,round(capacity));










