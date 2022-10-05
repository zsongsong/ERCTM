function [TPR,TNR,acc,p,F1,TPRce,TNRce,accce,pce,F1ce,TPRcr,TNRcr,acccr,pcr,F1cr,TPRer,TNRer,accer,per,F1er] = metrics(carnum,car,carTrust,typeV0)
TP=0;TN=0;FP=0;FN=0;
TPce=0;TNce=0;FPce=0;FNce=0;
TPcr=0;TNcr=0;FPcr=0;FNcr=0;
TPer=0;TNer=0;FPer=0;FNer=0;
for i=1:carnum
    eval(['mess=car.id' num2str(i) ';']);
    messnum=length(mess);
    for j=1:messnum
        youid=mess(j,1);
        trustvalue = eval(['carTrust.id' num2str(i) '.trust(j);']);
        if ismember(youid,typeV0)% 正常车 均值为0 方差为 0
            if trustvalue==1
                TN=TN+1;% 正常车 预测为 正常车
            else
                FP=FP+1;% 正常车 预测为 异常车
            end
        else% 异常车
            if trustvalue==1
                FN=FN+1;% 异常车 预测为 正常车
            else
                TP=TP+1;% 异常车 预测为 异常车
            end
        end
    end
    for j=1:messnum
        youid=mess(j,1);
        trustvaluece = eval(['carTrust.id' num2str(i) '.trustce(j);']);
        if ismember(youid,typeV0)% 正常车 均值为0 方差为 0
            if trustvaluece==1
                TNce=TNce+1;% 正常车 预测为 正常车
            else
                FPce=FPce+1;% 正常车 预测为 异常车
            end
        else% 异常车
            if trustvaluece==1
                FNce=FNce+1;% 异常车 预测为 正常车
            else
                TPce=TPce+1;% 异常车 预测为 异常车
            end
        end
    end
    for j=1:messnum
        youid=mess(j,1);
        trustvaluecr = eval(['carTrust.id' num2str(i) '.trustcr(j);']);
        if ismember(youid,typeV0)% 正常车 均值为0 方差为 0
            if trustvaluecr==1
                TNcr=TNcr+1;% 正常车 预测为 正常车
            else
                FPcr=FPcr+1;% 正常车 预测为 异常车
            end
        else% 异常车
            if trustvaluecr==1
                FNcr=FNcr+1;% 异常车 预测为 正常车
            else
                TPcr=TPcr+1;% 异常车 预测为 异常车
            end
        end
    end
    
    for j=1:messnum
        youid=mess(j,1);
        trustvalueer = eval(['carTrust.id' num2str(i) '.truster(j);']);
        if ismember(youid,typeV0)% 正常车 均值为0 方差为 0
            if trustvalueer==1
                TNer=TNer+1;% 正常车 预测为 正常车
            else
                FPer=FPer+1;% 正常车 预测为 异常车
            end
        else% 异常车
            if trustvalueer==1
                FNer=FNer+1;% 异常车 预测为 正常车
            else
                TPer=TPer+1;% 异常车 预测为 异常车
            end
        end
    end
end
TPR=TP/(TP+FN);
TNR=TN/(TN+FP);
acc=(TP+TN)/(TP+TN+FP+FN);
p=TP/(TP+FP);
r=TPR;
F1=2*r*p/(r+p);

TPRce=TPce/(TPce+FNce);
TNRce=TNce/(TNce+FPce);
accce=(TPce+TNce)/(TPce+TNce+FPce+FNce);
pce=TPce/(TPce+FPce);
rce=TPRce;
F1ce=2*rce*pce/(rce+pce);


TPRcr=TPcr/(TPcr+FNcr);
TNRcr=TNcr/(TNcr+FPcr);
acccr=(TPcr+TNcr)/(TPcr+TNcr+FPcr+FNcr);
pcr=TPcr/(TPcr+FPcr);
rcr=TPRcr;
F1cr=2*rcr*pcr/(rcr+pcr);


TPRer=TPer/(TPer+FNer);
TNRer=TNer/(TNer+FPer);
accer=(TPer+TNer)/(TPer+TNer+FPer+FNer);
per=TPer/(TPer+FPer);
rer=TPRer;
F1er=2*rer*per/(rer+per);

