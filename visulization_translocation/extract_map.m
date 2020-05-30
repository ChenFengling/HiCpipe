function [imap,pos] = extract_map(imA,imB,imC,chr1,start1,strand1,chr2,start2,strand2,resolution,left,right,FLAG,chrsizes)
    A1=1;
    A2=ceil(start1/resolution);
    A3=ceil(chrsizes(chr1)/resolution);
    B1=1;
    B2=ceil(start2/resolution);
    B3=ceil(chrsizes(chr2)/resolution);
    if  strand1==1 && strand2==0
        M1=ceil(left/resolution)+1;
        M2=ceil(right/resolution);
        map=zeros(A2+B3-B2+1,A2+B3-B2+1,'single');
        map(1:A2,1:A2)=imA(1:A2,1:A2);
        map((A2+1):(A2+B3-B2+1),(A2+1):(A2+B3-B2+1))=imB(B2:B3,B2:B3);
        map(1:A2,(A2+1):(A2+B3-B2+1))=imC(1:A2,B2:B3);
        map=triu(map);
        imap=map+map';
        imap= double(imap - diag(diag(map)));
        if FLAG==1
        imap= bnewt2(imap);
        end
        pos=M1:(A2+1+M2-B2);
    elseif strand1==1 && strand2==1
        M1=ceil(left/resolution)+1;
        M2=ceil(right/resolution)+1;
        map=zeros(A2+B2,A2+B2,'single');
        map(1:A2,1:A2)=imA(1:A2,1:A2);
        map((A2+1):(A2+B2),(A2+1):(A2+B2))=rot90(rot90(imB(B1:B2,B1:B2)));
        map(1:A2,(A2+1):(A2+B2))=rot90(transpose(imC(1:A2,1:B2)),-1);
        map=triu(map);
        imap=map+map';
        imap= double(imap - diag(diag(map)));
        if FLAG==1
        imap= bnewt2(imap);
        end
        pos=M1:(A2+1+B2-M2);
    else
        M1=ceil(left/resolution);
        M2=ceil(right/resolution);
        map=zeros(A3-A2+1+B3-B2+1,A3-A2+1+B3-B2+1,'single');
        map(1:(A3-A2+1),1:(A3-A2+1))=rot90(rot90(imA(A2:A3,A2:A3)));
        map((A3-A2+1+1):(A3-A2+1+B3-B2+1),(A3-A2+1+1):(A3-A2+1+B3-B2+1))=imB(B2:B3,B2:B3);
        map(1:(A3-A2+1),(A3-A2+1+1):(A3-A2+1+B3-B2+1))=rot90(transpose(imC(A2:A3,B2:B3)));
        map=triu(map);
        imap=map+map';
        imap= double(imap - diag(diag(map)));
        if FLAG==1
        imap= bnewt2(imap);
        end
        pos=(A3-M1+1):(A3-A2+2+M2-B2);
    end
end
