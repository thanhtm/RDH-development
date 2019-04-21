clear
clc
addpath jpegread\;
addpath utils\;
addpath testimage\;
list=dir('testimage');
k=length(list);                     %ͼƬ������
best_70=zeros(3,20000/2000,100);
best_80=zeros(3,24000/2000,100);
best_90=zeros(3,30000/2000,100);
best_100=zeros(3,50000/2000,100);
% parpool('local',24);
for i=3:k                           %ѡ��ÿһ��ͼƬ
list(i).name
[best_70(:,:,i-2),best_80(:,:,i-2),best_90(:,:,i-2),best_100(:,:,i-2)]=synthesize(list(i).name,i);
end
save('D:\houdd\jpegRDH\QF=70\proposed_70.mat','best_70');
save('D:\houdd\jpegRDH\QF=80\proposed_80.mat','best_80');
save('D:\houdd\jpegRDH\QF=90\proposed_90.mat','best_90');
save('D:\houdd\jpegRDH\QF=100\proposed_100.mat','best_100');
poolobj = gcp('nocreate');
delete(poolobj);

save proposed_70 best_70
save proposed_80 best_80
save proposed_90 best_90
save proposed_100 best_100






