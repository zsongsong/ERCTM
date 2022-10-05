function [carTrust,carnum] = trustmodel(typeV,typeV0,typeV1,typeV2,typeV3,typeV4,typeV5,typeV6,car,e,detectpos,num,epxinop,epxinov,alpha,slope,freq,numsenor)
%% Set different types of vehicles in the normal vehicle set
carnum = size(typeV);
carnum = carnum(1,1);
numtypeA=num;
numtypeB=num;
numtypeC=num;
numtypeD=num;
numtypeE=num;
%Ath vehicles
typeV0=sort(typeV0);
typeA=typeV0(1:numtypeA);
tem = setdiff(typeV0,typeA);
typeB=tem(1:numtypeB);
tem = setdiff(tem,typeB);
typeC=tem(1:numtypeC);
tem = setdiff(tem,typeC);
typeD=tem(1:numtypeD);
tem = setdiff(tem,typeD);
typeE=tem(1:numtypeE);
tradition = setdiff(tem,typeE);
%Other vehicles
typeOth=[];
typeOth = union(typeOth,typeV1);
typeOth = union(typeOth,typeV2);
typeOth = union(typeOth,typeV3);
typeOth = union(typeOth,typeV4);
typeOth = union(typeOth,typeV5);
typeOth = union(typeOth,typeV6);
%%
for i=1:carnum
    eval(['mess=car.id' num2str(i) ';']);
    messnum=length(mess);
    for j=1:messnum
        youid=mess(j,1);
        youposx=mess(j,2);
        youposy=mess(j,3);
        youspeedx=mess(j,4);
        youspeedy=mess(j,5);
        youtime=mess(j,6);
        myposx=mess(j,7);
        myposy=mess(j,8);
        myspeedx=mess(j,9);
        myspeedy=mess(j,10);
        mytime=mess(j,11);
        %% Position expectation
        dispos=sqrt((youposx-myposx)^2+(youposy-myposy)^2);
        if dispos > epxinop
            tempos =0;
        else
            tempos =1;
        end
        eval(['carTrust.id' num2str(i) '.expectpos(j)=tempos;']);
        %% Speed expectation
        k=1;%Find the corresponding detector K according to its position
        mindistance=inf;
        for p=1:numsenor
            temp=sqrt((youposx-detectpos(p,1))^2+(youposy-detectpos(p,2))^2);
            if mindistance>temp
                mindistance=temp;
                k=p;
            end
        end
        t = ceil(youtime/freq);% Find t according to time
        %Find the expected velocity at the position and time.
        preV = double(eval(['e.e' num2str(k) '(' num2str(t) ',3);']));
        %exponential function
        youV = sqrt(youspeedx^2+youspeedy^2);
        disspeed = youV-preV;
        tempspeed = exp(-abs(disspeed)*alpha);
        if preV==-1
            tempspeed = 0.6;%Default 0.6 if there is no predicted speed
        end
        if youV>epxinov
            tempspeed =0;
        end
        eval(['carTrust.id' num2str(i) '.expectspeed(j)=tempspeed;']);
        eval(['carTrust.id' num2str(i) '.expect(j)=min(tempos, tempspeed);']);
        %% Risk
        myV =  sqrt(myspeedx^2+myspeedy^2);
        if myV<=1e-3||youV<1e-3
            P_like = 0.5;
        else
            theta = acos((myspeedx*youspeedx+myspeedy*youspeedy)/(myV*youV));
            P_like =-(1.6/pi^2)*theta^2+(1.6/pi)*theta+0.5;
        end
        I_impact = -dispos*slope+1;
        %Risk = Likelihood × Impact
        risk = P_like * I_impact;
        eval(['carTrust.id' num2str(i) '.risk(j)=risk;']);
        %% confidence
        % Different confidence values are given according to the vehicle's type.
        if ismember(youid,typeA)
            eval(['carTrust.id' num2str(i) '.confidence(j)=1;']);
        end
        if ismember(youid,typeB)
            eval(['carTrust.id' num2str(i) '.confidence(j)=0.9;']);
        end
        if ismember(youid,typeC)
            eval(['carTrust.id' num2str(i) '.confidence(j)=0.8;']);
        end
        if ismember(youid,typeD)
            eval(['carTrust.id' num2str(i) '.confidence(j)=0.7;']);
        end
        if ismember(youid,typeE)
            eval(['carTrust.id' num2str(i) '.confidence(j)=0.6;']);
        end
        if ismember(youid,tradition)
            eval(['carTrust.id' num2str(i) '.confidence(j)=0.5;']);
        end
        if ismember(youid,typeOth)
            eval(['carTrust.id' num2str(i) '.confidence(j)=0.5;']);%0.5,0.6,0.7,0.8,0.9,1
        end
        %% Trust decision
        P_confidence = eval(['carTrust.id' num2str(i) '.confidence(j);']);
        P_expect = eval(['carTrust.id' num2str(i) '.expect(j);']);
        P_risk = eval(['carTrust.id' num2str(i) '.risk(j);']);
        if P_confidence^2>=(1-P_expect)^2+P_risk^2
            eval(['carTrust.id' num2str(i) '.trust(j)=1;']);
        else
            eval(['carTrust.id' num2str(i) '.trust(j)=0;']);
        end
        if P_confidence>=(1-P_expect)
            eval(['carTrust.id' num2str(i) '.trustce(j)=1;']);
        else
            eval(['carTrust.id' num2str(i) '.trustce(j)=0;']);
        end
        if P_expect>=P_risk
            eval(['carTrust.id' num2str(i) '.truster(j)=1;']);
        else
            eval(['carTrust.id' num2str(i) '.truster(j)=0;']);
        end
        if P_confidence>=P_risk
            eval(['carTrust.id' num2str(i) '.trustcr(j)=1;']);
        else
            eval(['carTrust.id' num2str(i) '.trustcr(j)=0;']);
        end
    end
end