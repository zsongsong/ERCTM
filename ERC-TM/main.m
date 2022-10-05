% % Scenario 1
clear all;
% Super parameter setting
epxinov=13.89;%max Speed
epxinop = 300;%The communication distance
alpha =0.3315;%  0.3315
slope=0.5/300;%Risk
freq=5;%Sensor acquisition interval
numsenor=12;%Number of sensors
for i=1:7 %Threat Model
    tic
    for j=1:5 %5 runs
        filefolder = ['F:\TrustExperiment1\sc1\', num2str(i), '\', num2str(j), '\', 'results'];
        root=['F:\TrustExperiment1\Detector1\Detector',num2str(j),'\'];
        fprintf('i=%d,j=%d\n', i,j);
        [typeV,typeV0,typeV1,typeV2,typeV3,typeV4,typeV5,typeV6,car,e,detectpos]=dataload_1(filefolder,root);
        [carTrust,carnum] = trustmodel(typeV,typeV0,typeV1,typeV2,typeV3,typeV4,typeV5,typeV6,car,e,detectpos,5,epxinop,epxinov,alpha,slope,freq,numsenor);
        
        [TPR,TNR,acc,p,F1,TPRce,TNRce,accce,pce,F1ce,TPRcr,TNRcr,acccr,pcr,F1cr,TPRer,TNRer,accer,per,F1er] = metrics(carnum,car,carTrust,typeV0);
        [tru,truce,trucr,truer] = metrics1(carnum,car,carTrust,typeV0);

        savepath =['F:\TrustExperiment1\Scenario1\',num2str(i),'-',num2str(j),'.mat'];
        save(savepath);
    end
    toc
end
% Scenario1
clear all;
TNRlist=zeros(7,5);TNRlistce=zeros(7,5);TNRlistcr=zeros(7,5);TNRlister=zeros(7,5);
TPRlist=zeros(7,5);TPRlistce=zeros(7,5);TPRlistcr=zeros(7,5);TPRlister=zeros(7,5);
ACClist=zeros(7,5);ACClistce=zeros(7,5);ACClistcr=zeros(7,5);ACClister=zeros(7,5);
Plist=zeros(7,5);Plistce=zeros(7,5);Plistcr=zeros(7,5);Plister=zeros(7,5);
Flist=zeros(7,5);Flistce=zeros(7,5);Flistcr=zeros(7,5);Flister=zeros(7,5);
ratio=zeros(7,5,100);ratioce=zeros(7,5,100);ratiocr=zeros(7,5,100);ratioer=zeros(7,5,100);
for i=1:7
    for j=1:5
        matpath= ['F:\TrustExperiment1\Scenario1\',num2str(i),'-',num2str(j),'.mat'];
        load(matpath);
        TNRlist(i,j)=TNR;
        TPRlist(i,j)=TPR;
        ACClist(i,j)=acc;
        Plist(i,j)=p;
        Flist(i,j)=F1;
        ratio(i,j,:)=tru(:,3);

        TNRlistce(i,j)=TNRce;
        TPRlistce(i,j)=TPRce;
        ACClistce(i,j)=accce;
        Plistce(i,j)=pce;
        Flistce(i,j)=F1ce;
        ratioce(i,j,:)=truce(:,3);

        TNRlistcr(i,j)=TNRcr;
        TPRlistcr(i,j)=TPRcr;
        ACClistcr(i,j)=acccr;
        Plistcr(i,j)=pcr;
        Flistcr(i,j)=F1cr;
        ratiocr(i,j,:)=trucr(:,3);

        TNRlister(i,j)=TNRer;
        TPRlister(i,j)=TPRer;
        ACClister(i,j)=accer;
        Plister(i,j)=per;
        Flister(i,j)=F1er;
        ratioer(i,j,:)=truer(:,3);
    end
end
savepath =['F:\TrustExperiment1\Scenario1\Scenario1.mat'];
save(savepath); 

% Scenario 2
clear all;
%% Super parameter setting
epxinov=13.89;%max Speed
epxinop = 300;%The communication distance
alpha =0.3315;%0.3315  0.1657
slope=0.5/300;%Risk
freq=5;%Sensor acquisition interval
numsenor=30;%Number of sensors
%%
for i=1:7
    tic
    for j=1:5
        filefolder = ['F:\TrustExperiment1\sc2\', num2str(i), '\', num2str(j), '\', 'results'];
        root=['F:\TrustExperiment1\Detector2\Detector',num2str(j),'\'];
        fprintf('i=%d,j=%d\n', i,j);
        [typeV,typeV0,typeV1,typeV2,typeV3,typeV4,typeV5,typeV6,car,e,detectpos]=dataload_2(filefolder,root);
        [carTrust,carnum] = trustmodel(typeV,typeV0,typeV1,typeV2,typeV3,typeV4,typeV5,typeV6,car,e,detectpos,5,epxinop,epxinov,alpha,slope,freq,numsenor);
        
        [TPR,TNR,acc,p,F1,TPRce,TNRce,accce,pce,F1ce,TPRcr,TNRcr,acccr,pcr,F1cr,TPRer,TNRer,accer,per,F1er] = metrics(carnum,car,carTrust,typeV0);
        [tru,truce,trucr,truer] = metrics1(carnum,car,carTrust,typeV0);

        savepath =['F:\TrustExperiment1\Scenario2\',num2str(i),'-',num2str(j),'.mat'];
        save(savepath);
    end
    toc
end
% Scenario 2
clear all;
TNRlist=zeros(7,5);TNRlistce=zeros(7,5);TNRlistcr=zeros(7,5);TNRlister=zeros(7,5);
TPRlist=zeros(7,5);TPRlistce=zeros(7,5);TPRlistcr=zeros(7,5);TPRlister=zeros(7,5);
ACClist=zeros(7,5);ACClistce=zeros(7,5);ACClistcr=zeros(7,5);ACClister=zeros(7,5);
Plist=zeros(7,5);Plistce=zeros(7,5);Plistcr=zeros(7,5);Plister=zeros(7,5);
Flist=zeros(7,5);Flistce=zeros(7,5);Flistcr=zeros(7,5);Flister=zeros(7,5);
ratio=zeros(7,5,100);ratioce=zeros(7,5,100);ratiocr=zeros(7,5,100);ratioer=zeros(7,5,100);
for i=1:7
    for j=1:5
        matpath= ['F:\TrustExperiment1\Scenario2\',num2str(i),'-',num2str(j),'.mat'];
        load(matpath);
        TNRlist(i,j)=TNR;
        TPRlist(i,j)=TPR;
        ACClist(i,j)=acc;
        Plist(i,j)=p;
        Flist(i,j)=F1;
        ratio(i,j,:)=tru(:,3);

        TNRlistce(i,j)=TNRce;
        TPRlistce(i,j)=TPRce;
        ACClistce(i,j)=accce;
        Plistce(i,j)=pce;
        Flistce(i,j)=F1ce;
        ratioce(i,j,:)=truce(:,3);

        TNRlistcr(i,j)=TNRcr;
        TPRlistcr(i,j)=TPRcr;
        ACClistcr(i,j)=acccr;
        Plistcr(i,j)=pcr;
        Flistcr(i,j)=F1cr;
        ratiocr(i,j,:)=trucr(:,3);

        TNRlister(i,j)=TNRer;
        TPRlister(i,j)=TPRer;
        ACClister(i,j)=accer;
        Plister(i,j)=per;
        Flister(i,j)=F1er;
        ratioer(i,j,:)=truer(:,3);

    end
end
savepath =['F:\TrustExperiment1\Scenario2\Scenario2.mat'];
save(savepath); 

