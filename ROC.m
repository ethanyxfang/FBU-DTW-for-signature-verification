function [EER TH]=ROC(FAR,FRR)

%   计算等误率和对应阈值系数,画出ROC曲线
%   参数：
%       FAR/FRR:误拒率/误识率,使用时不必区分（1 x n）
%   返回值：
%       EER:等误率
%       TH：阈值系数

len=1:length(FAR);
plot(len,FAR,len,FRR);
if FAR(1)>FRR(1)
    D=FAR-FRR;
else 
    D=FRR-FAR;
end

[NUM LOC]=find(D<0);
if isempty(NUM)
    error('error:FAR与FRR没有交点。');
end 

LOC=min(LOC-1);
NUMU=D(LOC);
NUMD=D(LOC+1);
TH=((LOC+1)*NUMU-LOC*NUMD)/(NUMU-NUMD);
EERA=-((TH-LOC-1)*(FAR(LOC))-(TH-LOC)*(FAR(LOC+1)));
EERR=-((TH-LOC-1)*(FRR(LOC))-(TH-LOC)*(FRR(LOC+1)));
EER=(EERA+EERR)/2;

if find(D==0)
    TH=find(D==0);
    EER=FAR(TH);
end

end