function [ typeV,typeV0,typeV1,typeV2,typeV3,typeV4,typeV5,typeV6,car,e,detectpos] = dataload_1(filefolder,root)
%% Load vehicle messages
files = dir(filefolder);
size_row = size(files);
folder_num = size_row(1);
typeV = zeros(folder_num-5,1); %All vehicles;
typeV0 = zeros(folder_num-5,1);%All normal vehicles;
typeV1 = zeros(folder_num-5,1);%Malicious vehicles;
typeV2 = zeros(folder_num-5,1);%Malicious vehicles;
typeV3 = zeros(folder_num-5,1);%Malicious vehicles;
typeV4 = zeros(folder_num-5,1);%Malicious vehicles;
typeV5 = zeros(folder_num-5,1);%Malicious vehicles;
typeV6 = zeros(folder_num-5,1);%Malicious vehicles;
for i=6:folder_num
    s=files(i,1).name;
    fileName_folder = fullfile(filefolder,s);
    m = csvread(fileName_folder,1,0);
    cartype = cell2mat(regexp(s,'car+\d', 'match'));
    cartypenum = str2num(cell2mat(regexp(cartype,'\d', 'match')));
    cartypenum=int32(cartypenum);
    carid = cell2mat(regexp(s,'id[0-9]*', 'match'));
    caridnum = str2num(cell2mat(regexp(carid,'\d*', 'match')));
    caridnum=int32(caridnum);
    eval(['car.' carid '=m(:,1:11);']);
    typeV(caridnum,1) = cartypenum;
    if (cartypenum==0)
        typeV0(i-5,1) = caridnum;
    end
    if (cartypenum==1)
        typeV1(i-5,1) = caridnum;
    end
    if (cartypenum==2)
        typeV2(i-5,1) = caridnum;
    end
    if (cartypenum==3)
        typeV3(i-5,1) = caridnum;
    end
    if (cartypenum==4)
        typeV4(i-5,1) = caridnum;
    end
    if (cartypenum==5)
        typeV5(i-5,1) = caridnum;
    end
    if (cartypenum==6)
        typeV6(i-5,1) = caridnum;
    end
end
% Delete 0 rows
typeV0(all(typeV0==0,2),:)=[];
typeV1(all(typeV1==0,2),:)=[];
typeV2(all(typeV2==0,2),:)=[];
typeV3(all(typeV3==0,2),:)=[];
typeV4(all(typeV4==0,2),:)=[];
typeV5(all(typeV5==0,2),:)=[];
typeV6(all(typeV6==0,2),:)=[];
%% Load sensor data
enum=12;
for i=1:enum
    fileName= ['e',num2str(i-1),'.csv'];
    fid = fopen([root,fileName]);
    dcells = textscan(fid, '%f%f%d%f%s%d%d%d%f%f','Delimiter', ';', 'HeaderLines', 1 );
    fclose(fid);
    p = [dcells{1,[1,2,10]}];
    eval(['e.e' num2str(i) '=p;']);
end
detectpos =zeros(12,2);
detectpos(1,1)=325;detectpos(1,2)=23.4;
detectpos(2,1)=325;detectpos(2,2)=26.6;
detectpos(3,1)=625;detectpos(3,2)=23.4;
detectpos(4,1)=625;detectpos(4,2)=26.6;
detectpos(5,1)=925;detectpos(5,2)=23.4;
detectpos(6,1)=925;detectpos(6,2)=26.6;
detectpos(7,1)=1225;detectpos(7,2)=23.4;
detectpos(8,1)=1225;detectpos(8,2)=26.6;
detectpos(9,1)=1525;detectpos(9,2)=23.4;
detectpos(10,1)=1525;detectpos(10,2)=26.6;
detectpos(11,1)=1825;detectpos(11,2)=23.4;
detectpos(12,1)=1825;detectpos(12,2)=26.6;
end
