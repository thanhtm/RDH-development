function [messL,psnr,T,N]=main(messL,D_T,gray,cover,PER,PEB,pred_R,pred_B,cost)

%  messL=140000;
%  D_T=20;%%%%%ʧ������ baboon ʱ�� D_T=50 ���� =20

for T=0:1:10^10
    if length(find(cost<=T))>messL
        break;
    end
    
    if length(find(cost<=T))>=length(cost)
        error('Too large payloads');
    end
end

%%%%*******���������ѡ�㣬֤������
% % %         index=1:length(v_gray);
% % %         sel_ind=(10<v_gray)&(v_gray<246);
% % %         cost_RB=cost_RB0(sel_ind);
% % %         sel_ind=index(sel_ind);
% [~,order_ind]=sort(cost_RB0);
% order_ind=sel_ind(order_ind);
tag=0;
while ~tag
sel_ind=find(cost<=T);
lsb_ind=find(cost>=T);
[stego,L_embedmess,L_a,tag,N]=addPEs(gray,cover,PER,PEB,pred_R,pred_B,sel_ind,lsb_ind,messL,D_T^2);
T=T+1;
end
T=T-1;
% L_embedmess,L_tags
messL=L_embedmess-L_a;
psnr=appraise_PSNR(cover,stego);
%lsb_ind=order_ind(end-L_tags:end);
R_Gray=round( 0.299*stego(:,:,1)+0.587*stego(:,:,2)+0.114*stego(:,:,3) );
as=double(R_Gray(:))-double(gray(:));
graydiff=sum(abs(as))
%  imwrite(uint8(stego),'our3916lena140000.png')
