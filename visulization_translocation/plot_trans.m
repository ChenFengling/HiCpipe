function [] =figure3(patient,chr1,start1,strand1,chr2,start2,strand2,resolution,left,right)
addpath(genpath('/data01/fchen/HiCpipe/pipe/0.trans/vistrans'));
chrsizes=dlmread('/data01/fchen/HiCDB/annotation/hg19.chrom.sizes.txt');
factor=1.0383;
cmin=-3
cmax=3
cmax2=10
%% shift  01 to 10 
if  strand1==0 && strand2==1
    tmp=chr1;
    chr1=chr2;
    chr2=tmp;
    tmp=start1;
    start1=start2;
    start2=tmp;
    tmp=strand1;
    strand1=strand2;
    strand2=tmp;
end

%%%%%%%%%%%%%%%
%% cancer
%%%%%%%%%%%%%%%
%%
triple=dlmread(['transtmp/' patient '.chr' num2str(chr1)]);
N=ceil(chrsizes(chr1)/resolution);
im = zeros(N,N,'single');
im(triple(:,1)/resolution+1+N*(triple(:,2)/resolution))=triple(:,3);
imA = im+im';
imA  = double(imA- diag(diag(im)));
%%
triple=dlmread(['transtmp/' patient '.chr' num2str(chr2)]);
N=ceil(chrsizes(chr2)/resolution);
im = zeros(N,N,'single');
im(triple(:,1)/resolution+1+N*(triple(:,2)/resolution))=triple(:,3);
imB = im+im';
imB  = double(imB - diag(diag(im)));
%%
triple=dlmread(['transtmp/' patient '.chr' num2str(chr1) '_' num2str(chr2)]);
if chrsizes(chr1) < chrsizes(chr2)
    tmptriple=triple;
    triple(:,1)=tmptriple(:,2);
    triple(:,2)=tmptriple(:,1); 
end
N1 = ceil(chrsizes(chr1)/resolution);
N2 = ceil(chrsizes(chr2)/resolution);
imC = zeros(N1,N2,'single');
imC(triple(:,1)/resolution+1+N1*(triple(:,2)/resolution))=triple(:,3);
[map_trans,pos_trans] = extract_map(imA,imB,imC,chr1,start1,strand1,chr2,start2,strand2,resolution,left,right,1,chrsizes);
size(map_trans)
pos_trans
%%%%%%%%%%%%%%%
%% normal 
%%%%%%%%%%%%%%%
%%
sample={'097-N','076-N','077-N','108-N','098-N','115-N','107-N','124-N','103-N','102-N','122-N','123-N','118-N','116-N','121-N','MXYL-N'};
asum=[];
bsum=[];
csum=[];
imAsum=zeros(ceil(chrsizes(chr1)/resolution),ceil(chrsizes(chr1)/resolution),'single');
imBsum=zeros(ceil(chrsizes(chr2)/resolution),ceil(chrsizes(chr2)/resolution),'single');
imCsum=zeros(ceil(chrsizes(chr1)/resolution),ceil(chrsizes(chr2)/resolution),'single');
for i=1:16
    triple=dlmread(['transtmp/' sample{i} '.chr' num2str(chr1)]);
    asum=[asum,nansum(triple(:,3))];
    N=ceil(chrsizes(chr1)/resolution);
    im = zeros(N,N,'single');
    im(triple(:,1)/resolution+1+N*(triple(:,2)/resolution))=triple(:,3);
    imA = im+im';
    imA  = double(imA- diag(diag(im)))/asum(i)*asum(1);
    imAsum=imAsum+imA;
    %%
    triple=dlmread(['transtmp/' sample{i} '.chr' num2str(chr2)]);
    bsum=[bsum,nansum(triple(:,3))];
    N=ceil(chrsizes(chr2)/resolution);
    im = zeros(N,N,'single');
    im(triple(:,1)/resolution+1+N*(triple(:,2)/resolution))=triple(:,3);
    imB = im+im';
    imB  = double(imB - diag(diag(im)))/bsum(i)*bsum(1);
    imBsum=imBsum+imB;
    %%
    triple=dlmread(['transtmp/' sample{i} '.chr' num2str(chr1) '_' num2str(chr2)]);
    csum=[csum,nansum(triple(:,3))];
    if chrsizes(chr1) < chrsizes(chr2)
        tmptriple=triple;
        triple(:,1)=tmptriple(:,2);
        triple(:,2)=tmptriple(:,1); 
    end
    N1 = ceil(chrsizes(chr1)/resolution);
    N2 = ceil(chrsizes(chr2)/resolution);
    imC = zeros(N1,N2,'single');
    imC(triple(:,1)/resolution+1+N1*(triple(:,2)/resolution))=triple(:,3);
    imC= imC/csum(i)*csum(1);
    imCsum=imCsum+imC;
end
[map_notrans,pos_notrans] = extract_map(imAsum/16,imBsum/16,imCsum/16,chr1,start1,strand1,chr2,start2,strand2,resolution,left,right,0,chrsizes);
size(map_notrans)
pos_notrans

set(0,'DefaultFigureVisible', 'off');
fig=figure('visible','off');
set(gcf,'visible','off');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8.5 10]);
set(gca,'ytick',[],'xtick',[]);
ha = tight_subplot(3,3,[.01 .01],[.1 .01],[.01 .01]);
axes(ha(1));
imagesc(map_trans(pos_trans,pos_trans)/factor,[0,cmax2]);
axes(ha(2));
imagesc(map_notrans(pos_notrans,pos_notrans),[0,cmax2]);
axes(ha(3));
imagesc(map_notrans(pos_notrans,pos_notrans),[0,cmax2]);
mycolor=dlmread('/data01/fchen/HiCpipe/pipe/0.trans/vistrans/color.txt');
colormap(mycolor)
colorbar;
print(fig,'-dpdf',[num2str(resolution) '_' num2str(chr1) '_' num2str(start1) '_' num2str(chr2) '_' num2str(start2) '_' num2str(strand1) '_' num2str(strand2) '.Hicmap.pdf']);

A2=ceil(start1/resolution);
B2=ceil(start2/resolution);
HOXA=importdata('/home/fchen/TLX3.loci.t2')
dataHOXA=ceil(HOXA.data+A2-B2+1);
set(0,'DefaultFigureVisible', 'off');
fig=figure('visible','off');
set(gcf,'visible','off');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8.5 10]);
set(gca,'ytick',[],'xtick',[]);
ha = tight_subplot(8,2,[.01 .01],[.1 .01],[.01 .01]);
axes(ha(1));
mat=map_trans(dataHOXA,pos_trans)/factor-map_notrans(dataHOXA,pos_notrans);
imagesc(mat,[cmin,cmax]);
axes(ha(2));
mat=map_trans(dataHOXA,pos_trans)/factor-map_notrans(dataHOXA,pos_notrans);
imagesc(mat,[cmin,cmax]);
dlmwrite('v4C_HOXA_sub.txt',mat)
mycolor=dlmread('/data01/data/TALL_patient/plotsample/color_sub.txt');
colormap(mycolor)
colorbar;
print(fig,'-dpdf',['v4C_HOXA_sub.pdf'],'-fillpage');

set(0,'DefaultFigureVisible', 'off');
fig=figure('visible','off');
set(gcf,'visible','off');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8.5 10]);
set(gca,'ytick',[],'xtick',[]);
ha = tight_subplot(8,2,[.01 .01],[.1 .01],[.01 .01]);
axes(ha(1));
mat=map_trans(dataHOXA,pos_trans)/factor;
imagesc(mat,[0,cmax2]);
dlmwrite('v4C_HOXA.txt',mat)
axes(ha(2));
mat=map_trans(dataHOXA,pos_trans);
imagesc(mat,[0,cmax2]);
mycolor=dlmread('/data01/fchen/HiCpipe/pipe/0.trans/vistrans/color.txt');
colormap(mycolor)
colorbar;
print(fig,'-dpdf',['v4C_HOXA.pdf'],'-fillpage');

end

