function [rec_blockdct,exData,pos]=extract(rec_blockdct,exData,pos,payload,row,col,Cv)   
%�������ܣ���ȡ�ָ���������λ��(row,col)�Ŀ����������ȡ
%����ֵrec_blockdctΪ�ָ����dct���󣬷���ֵpos��ʾ����ȡ��������

[Z_dct]=GetZigzag(rec_blockdct{row,col});      %�õ�λ��(row,col)�Ŀ��Zigzag����
count=1;

for i=3:2:63
        count=count+1;
        if pos>=payload || count>Cv            %��������ȫ����ȡ��ѡ���Ƶ�ȴ���ȫ����ȡ��������ѭ��
             break
        end
        x=Z_dct(1,i);                    %�������ڵ�ϵ���������
        y=Z_dct(1,i+1);
        
         %�����������Ŀ飬��1��
        if x>0 && y>=0                      
            if (x==2 && y==1) || (x==2 && y==0)    %(2,1)��(2,0)����ȡ����1��(1,1) (1,0)
                pos=pos+1;
                exData(pos)=1;
                x=x-1;
            elseif x>1 && y==2                      %(x,2)����ȡ����1��(x,1)
                pos=pos+1;
                exData(pos)=1;
                y=y-1;
            elseif (x==1 && y==1) || (x==1 && y==0)      %(1,1)��(1,0)����ȡ����0��(1,1) (1,0)
                pos=pos+1;
                exData(pos)=0;
            elseif x>2 && y==1                       %(x,1)����ȡ����0��(x-1,0)
                pos=pos+1;
                exData(pos)=0;
                x=x-1;
            elseif x==1 && y==2              %(1,2)����ȡ����10��(1,1)
                pos=pos+2;
                exData(pos-1)=1;
                exData(pos)=0;
                y=y-1;
            elseif x>2 && y==0      %(x,0)��(x-1,0)
                x=x-1;
            else                     %(x,y)��(x,y-1)
                y=y-1;
            end
          
        %�����������Ŀ飬��2��
        elseif x<=0 && y>0                  
            if x==-2 && y==1                 %(-2,1)����ȡ����1��(-1,1)
                pos=pos+1;
                exData(pos)=1;
                x=x+1;
            elseif (x==0 && y==2) || (x<-1 && y==2)       %(0,2)��(x,2)����ȡ����1��(0,1) (x,1)
                pos=pos+1;
                exData(pos)=1;
                y=y-1;
            elseif (x==-1 && y==1) || (x==0 && y==1)    %(-1,1)��(0,1)����ȡ����0��(-1,1) (0,1)
                pos=pos+1;
                exData(pos)=0;
            elseif x<-2 && y==1        %(x,1)����ȡ����0��(x+1,0)
                pos=pos+1;
                exData(pos)=0;
                x=x+1;
            elseif x==-1 && y==2           %(-1,2)����ȡ����10��(-1,1)
                pos=pos+2;
                exData(pos-1)=1;
                exData(pos)=0;
                y=y-1;
            else                         %(x,y)��(x,y-1)
                y=y-1;
            end
            
        %�����������Ŀ飬��3��    
        elseif x<0 && y<=0               
            if (x==-2 && y==-1) || (x==-2 && y==0)                   %(-2,-1)��(-2,0)����ȡ����1��(-1,-1) (-1,0)
                pos=pos+1;
                exData(pos)=1;
                x=x+1;
            elseif x<-1 && y==-2      %(x,-2)����ȡ����1��(x,-1)
                pos=pos+1;
                exData(pos)=1;
                y=y+1;
            elseif (x==-1 && y==-1) || (x==-1 && y==0)              %(-1,-1)��(-1,0)����ȡ����0��(-1,-1) (-1,0)
                pos=pos+1;
                exData(pos)=0;
            elseif x<-2 && y==-1       %(x,-1)����ȡ����0��(x+1,-1)
                pos=pos+1;
                exData(pos)=0;
                x=x+1;
            elseif x==-1 && y==-2     %(-1,-2)����ȡ����10��(-1,-1)
                pos=pos+2;
                exData(pos-1)=1;
                exData(pos)=0;
                y=y+1;
            elseif x<-2 && y==0         %(x,0)��(x+1,0)
                x=x+1;
            else                 %(x,y)��(x,y+1)
                y=y+1;
            end
            
        %�����������Ŀ飬��4��     
        elseif x>=0 && y<0    
            if x==2 && y==-1          %(2,-1)����ȡ����1��(1,-1)
                pos=pos+1;
                exData(pos)=1;
                x=x-1; 
            elseif (x==0 && y==-2) || (x>1 && y==-2)    %(0,-2)��(x,-2)����ȡ����1��(0,-1) (x,-1)
                pos=pos+1;
                exData(pos)=1;
                y=y+1;
            elseif (x==0 && y==-1) || (x==1 && y==-1)   %(0,-1)��(1,-1)����ȡ����0��(0,-1) (1,-1)
                pos=pos+1;
                exData(pos)=0;
            elseif x>2 && y==-1    %(x,-1)����ȡ����0��(x-1,-1)
                pos=pos+1;
                exData(pos)=0;
                x=x-1;
            elseif x==1 && y==-2    %(1,-2)����ȡ����10��(1,-1)
                pos=pos+2;
                exData(pos-1)=1;
                exData(pos)=0;
                y=y+1;
            else           %(x,y)��(x,y+1)
                y=y+1;
            end
        end
        
        Z_dct(1,i)=x;
        Z_dct(1,i+1)=y;
end

[rec_blockdct{row,col}]=AntiZigzag(Z_dct);   %��һά��Zigzag����תΪ8X8�Ŀ�

if pos>payload
    exData=exData(1,1:payload);
end

end
                
                
                