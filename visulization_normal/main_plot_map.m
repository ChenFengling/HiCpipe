%% high resolution  
mycolor=dlmread('color.txt');
datatable = importdata('example_gene.txt');
data=datatable.data;
name=datatable.textdata;
for m=1:4
m
set(0,'DefaultFigureVisible', 'off');
fig=figure('visible','off');
set(gcf,'visible','off');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8.5 10]);
RESOL=10000;
posstart=data(2,m);
posend=data(3,m);
chr=data(1,m);
tX=floor(posstart/RESOL+1):floor(posend/RESOL);
sample={'A0','A3','W0','W3'};
samplename={'A0','A3','W0','W3'};
asum=[];
ha = tight_subplot(2,2,[.01 .01],[.1 .01],[.01 .01]);

for i=1:4
% % Rawmatid = 'sample/GM12878_chr21_10kb.RAWobserved ';
Rawmatid = ['/data02/fchen/jingxue/',sample{i},'/maps/observed_KR_10000.chr',num2str(chr),'_',sample{i}];
triple = dlmread(Rawmatid); %start from 0
asum=[asum,nansum(triple(:,3))];
N = max(triple(:,1));
N = max([triple(:,2);N])/RESOL+1;
im = zeros(N,N,'single');
im(triple(:,1)/RESOL+1+N*(triple(:,2)/RESOL))=triple(:,3);
imA = im+im';
imA = double(imA-diag(diag(im)))/asum(i)*asum(1);
%subplot(2,4,i);
axes(ha(i)); 
imagesc(imA(tX,tX),[0,50]);   
set(gca,'ytick',[],'xtick',[]);
ntitle(samplename{i},'location','northeast','color','k','fontsize',40);
switch i
    case 1
        A0=imA(tX,tX);
    case 2
        A3=imA(tX,tX);
    case 3
        W0=imA(tX,tX);
    otherwise
        W3=imA(tX,tX);
end
end
%colormap(jet)
%load mycolor; 
colormap(mycolor); 
print(fig,'-dpdf',[num2str(chr) '_' num2str(posstart) '_' num2str(posend) '_' name{m} '_HiCmap_all_max20.pdf']);
close all;

set(0,'DefaultFigureVisible', 'off');
fig=figure('visible','off');
set(gcf,'visible','off');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8.5 10]);
ha = tight_subplot(4,4,[.01 .01],[.1 .01],[.01 .01]);
axes(ha(1));
mat=A3-A0;
imagesc(mat,[-10,10]);
set(gca,'ytick',[],'xtick',[]);
ntitle('A3-A0','location','northeast','color','k','fontsize',13);
axes(ha(2));
mat=W3-W0;
imagesc(mat,[-10,10]);
set(gca,'ytick',[],'xtick',[]);
ntitle('W3-W0','location','northeast','color','k','fontsize',13);
axes(ha(3));
mat=A0-W0;
imagesc(mat,[-10,10]);
set(gca,'ytick',[],'xtick',[]);
ntitle('A0-W0','location','northeast','color','k','fontsize',13);
axes(ha(4));
mat=A3-W3;
imagesc(mat,[-10,10]);
set(gca,'ytick',[],'xtick',[]);
ntitle('A3-W3','location','northeast','color','k','fontsize',13);


mycolor=dlmread('color_sub.txt');
colormap(mycolor)
axes(ha(5));
mat=A3-W3;
imagesc(mat,[-10,10]);
set(gca,'ytick',[],'xtick',[]);
colorbar;
print(fig,'-dpdf',['figure1_' num2str(chr) '_' num2str(posstart) '_' num2str(posend) '_' name{m} 'sub.pdf']);
close all;



end
% mycolor=colormap(gca);%mycolor
% save mycolor2 mycolor;

