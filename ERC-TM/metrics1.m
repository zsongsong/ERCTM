function [tru,truce,trucr,truer] = metrics1(carnum,car,carTrust,typeV0)
tru=zeros(carnum,4);
truce=zeros(carnum,4);
trucr=zeros(carnum,4);
truer=zeros(carnum,4);
for i=1:carnum
    eval(['mess=car.id' num2str(i) ';']);
    messnum=length(mess);
    for j=1:messnum
        youid=mess(j,1);
        trustvalue = eval(['carTrust.id' num2str(i) '.trust(j);']);
        if trustvalue==1
            tru(youid,1)=tru(youid,1)+1;%可信消息个数
        else
            tru(youid,2)=tru(youid,2)+1;%不可信消息个数
        end
    end    
     for j=1:messnum
        youid=mess(j,1);
        trustvaluece = eval(['carTrust.id' num2str(i) '.trustce(j);']);
        if trustvaluece==1
            truce(youid,1)=truce(youid,1)+1;%可信消息个数
        else
            truce(youid,2)=truce(youid,2)+1;%不可信消息个数
        end
     end    
     for j=1:messnum
        youid=mess(j,1);
        trustvaluecr = eval(['carTrust.id' num2str(i) '.trustcr(j);']);
        if trustvaluecr==1
            trucr(youid,1)=trucr(youid,1)+1;%可信消息个数
        else
            trucr(youid,2)=trucr(youid,2)+1;%不可信消息个数
        end
     end    
     for j=1:messnum
        youid=mess(j,1);
        trustvalueer = eval(['carTrust.id' num2str(i) '.truster(j);']);
        if trustvalueer==1
            truer(youid,1)=truer(youid,1)+1;%可信消息个数
        else
            truer(youid,2)=truer(youid,2)+1;%不可信消息个数
        end
    end    
end
tru(:,3)=tru(:,1)./(tru(:,1)+tru(:,2));
for i=1:carnum
    if ismember(i,typeV0)
        tru(i,4)=1;% 正常车
    else
        tru(i,4)=0;% 异常车
    end
end


truce(:,3)=truce(:,1)./(truce(:,1)+truce(:,2));
for i=1:carnum
    if ismember(i,typeV0)
        truce(i,4)=1;% 正常车
    else
        truce(i,4)=0;% 异常车
    end
end


trucr(:,3)=trucr(:,1)./(trucr(:,1)+trucr(:,2));
for i=1:carnum
    if ismember(i,typeV0)
        trucr(i,4)=1;% 正常车
    else
        trucr(i,4)=0;% 异常车
    end
end


truer(:,3)=truer(:,1)./(truer(:,1)+truer(:,2));
for i=1:carnum
    if ismember(i,typeV0)
        truer(i,4)=1;% 正常车
    else
        truer(i,4)=0;% 异常车
    end
end


