%�㷨�����������RLE��DC������������8*8��DCT����
function reDct=Recoverydct(RLE,DC)
zigzag=zeros(64);
zigzag(1)=DC;
[m,~]=size(RLE);
cnt=2;
for i=1:m
    r=RLE(i,1);
    v=RLE(i,2);
    for j=1:r
        zigzag(cnt)=0;
        cnt=cnt+1;
    end
    zigzag(cnt)=v;
    cnt=cnt+1;
end
reDct=AntiZigzag(zigzag);
end