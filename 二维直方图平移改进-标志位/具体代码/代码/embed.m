function [stego_blockdct,pos]=embed(stego_blockdct,data,pos,row,col,Cv,exchange_table,R)
%�������ܣ�Ƕ�뺯������λ��(row,col)�Ŀ��������Ƕ��
%����ֵstego_blockdctΪǶ����dct���󣬷���ֵpos��ʾ��Ƕ���������

payload=length(data);
[Z_dct]=GetZigzag(stego_blockdct{row,col});      %�õ�λ��(row,col)�Ŀ��Zigzag���У�Ϊһ����Ϊ64��һά����


for i=1:32
        if R(i,1)==1           %����λ��1��ϵ���Բ������غ�Ƕ��
            continue;
        end
        if pos==payload || i>Cv            %����������ѡ���λ������Ƕ��������ѭ��
             break
        end
        
        %�������ڵ�ϵ��������ԣ����ݽ������ֵѡ���Ϸ�ʽ
        if exchange_table(1,R(i,1))==0    
           x=Z_dct(1,2*R(i,1)-1);
           y=Z_dct(1,2*R(i,1));
        else
           x=Z_dct(1,2*R(i,1));
           y=Z_dct(1,2*R(i,1)-1); 
        end
        
        %�����������Ŀ飬��1��
        if x>0 && y>=0                      
            if x==1 && y==1
                pos=pos+1;
                if pos+1<=payload         %Ƕ�����ݻ�ʣ��2λ����
                    if data(pos)==1 && data(pos+1)==0
                        y=y+1;           %Ƕ��10ʱ(1,1)��(1,2) 
                        pos=pos+1;
                    else 
                        x=x+data(pos);           %Ƕ��0ʱ(1,1)��(1,1),Ƕ��1ʱ(1,1)��(2,1)
                    end
                else               %ֻʣһλ��Ƕ������
                    x=x+data(pos);
                end
            elseif x==1 && y==0     %Ƕ��0ʱ(1,0)��(1,0),Ƕ��1ʱ(1,0)��(2,0)
                pos=pos+1;
                x=x+data(pos);
            elseif x>1 && y==1     %Ƕ��0ʱ(x,1)��(x+1,1),Ƕ��1ʱ(x,1)��(x,2)
                pos=pos+1;
                if data(pos)==0
                    x=x+1;
                else
                    y=y+1;
                end
            elseif x>1 && y==0        %��λϵ����(x,0)��(x+1,0)
                x=x+1;
            elseif x>0 && y>1        %��λϵ����(x,y)��(x,y+1)
                y=y+1;
            end
            
        %�����������Ŀ飬��2��
        elseif x<=0 && y>0              
            if x==-1 && y==1
                pos=pos+1;
                if pos+1<=payload        %Ƕ�����ݻ�ʣ��2λ����
                    if data(pos)==1 && data(pos+1)==0
                        y=y+1;                  %Ƕ��10ʱ(-1,1)��(-1,2) 
                        pos=pos+1;
                    else 
                        x=x-data(pos);     %Ƕ��0ʱ(-1,1)��(-1,1),Ƕ��1ʱ(-1,1)��(-2,1)
                    end
                else                %ֻʣһλ��Ƕ������
                    x=x-data(pos);
                end
            elseif x==0 && y==1     %Ƕ��0ʱ(0,1)��(0,1),Ƕ��1ʱ(0,1)��(0,2)
                pos=pos+1;
                y=y+data(pos);
            elseif x<-1 && y==1     %Ƕ��0ʱ(x,1)��(x-1,1),Ƕ��1ʱ(x,1)��(x,2)
                pos=pos+1;
                if data(pos)==0
                    x=x-1;
                else
                    y=y+1;
                end
            elseif x<=0 && y>1         %��λϵ����(x,y)->(x,y+1)
                y=y+1;
            end
            
        %�����������Ŀ飬��3��     
        elseif x<0 && y<=0             
            if x==-1 && y==-1
                pos=pos+1;
                if pos+1<=payload              %Ƕ�����ݻ�ʣ��2λ����
                    if data(pos)==1 && data(pos+1)==0
                        y=y-1;                %Ƕ��10ʱ(-1,-1)��(-1,-2) 
                        pos=pos+1;
                    else                     %Ƕ��0ʱ(-1,-1)��(-1,-1),Ƕ��1ʱ(-1,-1)��(-2,-1)
                        x=x-data(pos);
                    end
                else                        %ֻʣһλ��Ƕ������
                    x=x-data(pos);
                end
            elseif x==-1 && y==0     %Ƕ��0ʱ(-1,0)��(-1,0),Ƕ��1ʱ(-1,0)��(-2,0)
                pos=pos+1;
                x=x-data(pos);
            elseif x<-1 && y==-1    %Ƕ��0ʱ(x,-1)��(x-1,-1),Ƕ��1ʱ(x,-1)��(x,-2)
                pos=pos+1;
                if data(pos)==0
                    x=x-1;
                else 
                    y=y-1;
                end
            elseif x<-1 && y==0    %��λϵ����(x,0)��(x-1,0)
                x=x-1;
            elseif x<0 && y<-1      %��λϵ����(x,y)��(x,y-1)
                y=y-1;
            end
            
        %�����������Ŀ飬��4��   
        elseif x>=0 && y<0           
            if x==1 && y==-1
                pos=pos+1;
                if pos+1<=payload             %Ƕ�����ݻ�ʣ��2λ����
                    if data(pos)==1 && data(pos+1)==0
                        y=y-1;              %Ƕ��10ʱ(1,-1)��(1,-2)
                        pos=pos+1;
                    else             %Ƕ��0ʱ(1,-1)��(1,-1),Ƕ��1ʱ(1,-1)��(2,-1)
                        x=x+data(pos);
                    end
                else                %ֻʣһλ��Ƕ������
                    x=x+data(pos);
                end
            elseif x==0 && y==-1      %Ƕ��0ʱ(0,-1)��(0,-1),Ƕ��1ʱ(0,-1)��(0,-2)
                pos=pos+1;
                y=y-data(pos);
            elseif x>1 && y==-1    %Ƕ��0ʱ(x,-1)��(x+1,-1),Ƕ��1ʱ(x,-1)��(x,-2)
                pos=pos+1;
                if data(pos)==0
                    x=x+1;
                else
                    y=y-1;
                end
            elseif x>=0 && y<-1    %��λϵ����(x,y)��(x,y-1)
                y=y-1;
            end
        end
        
        if exchange_table(1,R(i,1))==0
           Z_dct(1,2*R(i,1)-1)=x;
           Z_dct(1,2*R(i,1))=y;
        else
           Z_dct(1,2*R(i,1)-1)=y;
           Z_dct(1,2*R(i,1))=x;
        end
end

%��һά��Zigzag����תΪ8X8�Ŀ�
[stego_blockdct{row,col}]=AntiZigzag(Z_dct);        
end

                
                    
                        
        

