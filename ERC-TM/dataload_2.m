function [ typeV,typeV0,typeV1,typeV2,typeV3,typeV4,typeV5,typeV6,car,e,detectpos] = dataload_2(filefolder,root)
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
enum=30;
for i=1:enum
    fileName= ['e',num2str(i-1),'.csv'];
    fid = fopen([root,fileName]);
    dcells = textscan(fid, '%f%f%d%f%s%d%d%d%f%f','Delimiter', ';', 'HeaderLines', 1 );
    fclose(fid);
    p = [dcells{1,[1,2,10]}];
    eval(['e.e' num2str(i) '=p;']);
end
detectpos =zeros(30,2);
detectpos(1,1)=325;detectpos(1,2)=625+1.6;
detectpos(2,1)=325;detectpos(2,2)=625-1.6;
detectpos(3,1)=625-8.2;detectpos(3,2)=625+1.6;
detectpos(4,1)=625-8.2;detectpos(4,2)=625-1.6;
detectpos(5,1)=625+8.2;detectpos(5,2)=625+1.6;
detectpos(6,1)=625+8.2;detectpos(6,2)=625-1.6;
detectpos(7,1)=925;detectpos(7,2)=625+1.6;
detectpos(8,1)=925;detectpos(8,2)=625-1.6;
detectpos(9,1)=1225-8.2;detectpos(9,2)=625+1.6;
detectpos(10,1)=1225-8.2;detectpos(10,2)=625-1.6;
detectpos(11,1)=1225+8.2;detectpos(11,2)=625-1.6;
detectpos(12,1)=1225+8.2;detectpos(12,2)=625+1.6;
detectpos(13,1)=1525;detectpos(13,2)=625+1.6;
detectpos(14,1)=1525;detectpos(14,2)=625-1.6;
detectpos(15,1)=625-1.6;detectpos(15,2)=325;
detectpos(16,1)=625+1.6;detectpos(16,2)=325;
detectpos(17,1)=625-1.6;detectpos(17,2)=625-8.2;
detectpos(18,1)=625+1.6;detectpos(18,2)=625-8.2;
detectpos(19,1)=625-1.6;detectpos(19,2)=625+8.2;
detectpos(20,1)=625+1.6;detectpos(20,2)=625+8.2;
detectpos(21,1)=625-1.6;detectpos(21,2)=925;
detectpos(22,1)=625+1.6;detectpos(22,2)=925;
detectpos(23,1)=1225-1.6;detectpos(23,2)=325;
detectpos(24,1)=1225+1.6;detectpos(24,2)=325;
detectpos(25,1)=1225-1.6;detectpos(25,2)=625-8.2;
detectpos(26,1)=1225+1.6;detectpos(26,2)=625-8.2;
detectpos(27,1)=1225-1.6;detectpos(27,2)=625+8.2;
detectpos(28,1)=1225+1.6;detectpos(28,2)=625+8.2;
detectpos(29,1)=1225-1.6;detectpos(29,2)=925;
detectpos(30,1)=1225+1.6;detectpos(30,2)=925;

end
