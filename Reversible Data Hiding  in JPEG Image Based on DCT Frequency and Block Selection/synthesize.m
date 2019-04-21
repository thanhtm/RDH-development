function [new_70,new_80,new_90,new_100]=synthesize(filename,i)  %ѡ��ͼƬ
addpath jpegread\;
addpath utils\;
best_70=zeros(3,20000/2000);
best_80=zeros(3,24000/2000);
best_90=zeros(3,30000/2000);
best_100=zeros(3,50000/2000);
for QF=70:10:100                 %ѡ��ͬ��QF���д���
   if QF==70
       T=20000;
%        best_70=zeros(3,T/2000);
   end
   if QF==80
        T=24000;
%         best_80=zeros(3,T/2000);
   end
   if QF==90
       T=30000;
%        best_90=zeros(3,T/2000);
   end
   if QF==100
       T=50000;
%        best_100=zeros(3,T/2000);
   end
imwrite(uint8(imread(filename)),strcat('name',num2str(i),num2str(QF),'.jpg'),'jpg','quality',QF);      %�ڵ�ǰQF��ѹ��
filename1=strcat('name',num2str(i),num2str(QF),'.jpg'); 
filename2=strcat('namestego',num2str(i),num2str(QF),'.jpg');
J=imread(filename1);
%��ǰQF��ѹ���γɵ�ͼƬ
% �Ե�ǰ��ͼƬ����һϵ�д���
jobj=jpeg_read(filename1);
              %�޸ķ���
     try
        jobj.optimize_coding = 1;
        jpeg_write(jobj,filename1);
    catch
        error('ERROR (problem with saving the stego image)');
    end
jobj=jpeg_read(filename1);                          %����ͼƬ
dct=jobj.coef_arrays{1};                           %��dctϵ�� 
Q_table=jobj.quant_tables{1};              %����������и�ֵ
%%%%%%%%%%%%%%%%%%��ͬǶ�������µ�ֵ%%%%%%%%%%%%%%%%%%%%%%%
for messLen=2000:2000:T         %�ڵ�ǰQF�µ�JPEGͼǶ�벻ͬ����Ϣ��
embed_bit=round(rand(1,messLen));  %��ǰmesslen���������Ƕ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%����ѡ��Ƕ��ϵ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PSNR=zeros(1,64);
INCRE=zeros(1,64);
Q_cost=costFun(Q_table);            %���������ÿ�����ӷ��ص������п��������ز�����Ӱ��  
bin63=get63bin(dct);          %���г��ÿ��DCT����ijλ�õ�ϵ��Ϊһ�У���ͬλ��Ϊһ���γɾ���
[outbin63,capacity63,unitdistortion63]=getuintcost63bin(bin63,Q_cost);
[unitdistortion63,sort_index]=sort(unitdistortion63);        %��ʧ�������������õĿ�ϵ����sort_index
for selnum=12:3:3*floor(length(sort_index)/3)                %%��������selnum������psnrѰ����ѵĿ�Ƕ������K
    sel_index=sort_index(1:selnum);
    M=matrix_index(sel_index);                 %������Ǿ���M
    DCT=mark(M,dct);                          %û���⣬����ѡ��ϵ�����DCT��%%%
%%%%%%%%%%%%%%ģ���޸�ͼƬ����Ƕ������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simulate_dct=simulate(DCT);         %ģ���޸ĺ��ͼƬ������simulate_dct
counter_1=count(DCT,1);
counter_0=count(DCT,0);
[counter_0,sort_0]=sort(counter_0);        
table=jobj.quant_tables{1};
[order,vd_distor]=select_block2(simulate_dct,DCT,table,counter_1);   %����ģ���޸ĵķ���̰���㷨��ʧ���С������һ��Ƕ��ͼƬ������,��������ʧ������
%%%%%%%%%%%%%%%%%%%%%%%%����Ƕ�����У�����ϢǶ��ͼƬ%%%%%%%%%%%%%%%%%%%%%%
for r=1:length(order)                                    %Ѱ��Ƕ���ٽ�ֵ
     if (sum(counter_1(order(1:r)))>=messLen)            %��ÿ������1����Ŀ
         order=order(1:r);
         sort_0=sort_0(1:r);        
         break;
     end
end
[stego1_dct,tag]=generate_stego(order,DCT,embed_bit,messLen);       %����Ƕ���DCTϵ��
if tag==1
 continue;
end
stego_dct=recoverstego(dct,stego1_dct,sel_index);         %�ָ�����ϵ��
%%%%%%%%%%%%%%%%%%%%%%%%%%�����������stego.dct����Ƕ��ͼƬ%%%%%%%%%%%%%%%%%%%%%%%
 jobj.coef_arrays{1} = stego_dct;                     %�޸ķ���
    try

        jobj.optimize_coding = 1;
        jpeg_write(jobj,filename2);
    catch
        error('ERROR (problem with saving the stego image)');
    end
 %% %%%&%%%%%%%%%%%%%%%%%%%%%%%%%����ʧ�����������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    I=imread(filename2);
    psnr_goad=appraise(I,J);
    fid=fopen(filename2,'rb');
                    bit1=fread(fid,'ubit1');
                fclose(fid);
                fid=fopen(filename1,'rb');
                    bit2=fread(fid,'ubit1');
                fclose(fid);
    incre_bit=length(bit1)-length(bit2);
    PSNR(selnum)=psnr_goad;
    INCRE(selnum)=incre_bit;
end
[best_psnr,index]=max(PSNR);                            %�ҵ���õ�psnr
 best_incre=INCRE(index);                               %�ҵ���õ�incre_bit
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if QF==70
 j=messLen/2000;
 best_70(:,j)=[messLen,best_psnr,best_incre];
end
if QF==80   
j=messLen/2000;   
best_80(:,j)=[messLen,best_psnr,best_incre];
end
if QF==90
j=messLen/2000;
best_90(:,j)=[messLen,best_psnr,best_incre];
end
if QF==100
j=messLen/2000;
best_100(:,j)=[messLen,best_psnr,best_incre];
end
end                %%%����messlenǶ�����
new_70=best_70;
new_80=best_80;
new_90=best_90;
new_100=best_100;
end

