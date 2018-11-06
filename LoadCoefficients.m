Water_filename='MaterialData/WaterCoeff.txt';
Bone_filename='MaterialData/BoneCoeff.txt';
SoftTissue_filename='MaterialData/SoftTissueCoeff.txt';
f=fopen(Water_filename);
count=1;
water=cell(0);
while ~feof(f)
    water{count}=strsplit(fgetl(f));
    count=count+1;
end
fclose(f);
f=fopen(Bone_filename);
count=1;
bone=cell(0);
while ~feof(f)
    bone{count}=strsplit(strip(fgetl(f)));
    count=count+1;
end
fclose(f);

f=fopen(SoftTissue_filename);
count=1;
soft_tissue=cell(0);
while ~feof(f)
    soft_tissue{count}=strsplit(strip(fgetl(f)));
    count=count+1;
end
fclose(f);
length_func=@(x) length(x);
bone_ind=find(cellfun(length_func,bone)~=3);
soft_tissue_ind=find(cellfun(length_func,soft_tissue)~=3);
bone(bone_ind)=[];
% global soft_tissue_attn soft_tissue_absor water_attn water_absor bone_attn bone_absor;
soft_tissue(soft_tissue_ind)=[];
water_attn=zeros(2,length(water));
water_absor=zeros(2,length(water));
bone_attn=zeros(2,length(bone));
bone_absor=zeros(2,length(bone));
soft_tissue_attn=zeros(2,length(soft_tissue));
soft_tissue_absor=zeros(2,length(soft_tissue));
for i=1:length(water)
    water_attn(1,i)=str2double(water{i}(1))*1000;
    water_absor(1,i)=str2double(water{i}(1))*1000;
    water_attn(2,i)=str2double(water{i}(2));
    water_absor(2,i)=str2double(water{i}(3));
end
for i=1:length(bone)
    bone_attn(1,i)=str2double(bone{i}(1))*1000;
    bone_absor(1,i)=str2double(bone{i}(1))*1000;
    bone_attn(2,i)=str2double(bone{i}(2));
    bone_absor(2,i)=str2double(bone{i}(3));
end
for i=1:length(soft_tissue)
    soft_tissue_attn(1,i)=str2double(soft_tissue{i}(1))*1000;
    soft_tissue_absor(1,i)=str2double(soft_tissue{i}(1))*1000;
    soft_tissue_attn(2,i)=str2double(soft_tissue{i}(2));
    soft_tissue_absor(2,i)=str2double(soft_tissue{i}(3));
end
attns=cell(3,1);
attns{1}=water_attn;
attns{2}=bone_attn;
attns{3}=soft_tissue_attn;
LoadDensity;
% figure(1);loglog(water_attn(1,:),water_attn(2,:),'k');hold on;
% loglog(water_absor(1,:),water_absor(2,:),'--k');hold off;
% title('Water mass attenuation/absorbption coefficient');
% xlabel('Energy(eV)');
% ylabel('Coefficient(cm^2/g)');
% xlim([min(water_absor(1,:)), max(water_absor(1,:))]);
% legend('Attenuation coefficient','Absorbption coefficient');
% figure(2);loglog(bone_attn(1,:),bone_attn(2,:),'k');hold on;
% loglog(bone_absor(1,:),bone_absor(2,:),'--k');hold off;
% title('Bone mass attenuation/absorbption coefficient');
% xlabel('Energy(eV)');
% ylabel('Coefficient(cm^2/g)');
% xlim([min(bone_attn(1,:)), max(bone_attn(1,:))]);
% legend('Attenuation coefficient','Absorbption coefficient');
% figure(3);loglog(soft_tissue_attn(1,:),soft_tissue_attn(2,:),'k');hold on;
% loglog(soft_tissue_absor(1,:),soft_tissue_absor(2,:),'--k');hold off;
% title('Soft tissue mass attenuation/absorbption coefficient');
% xlabel('Energy(eV)');
% ylabel('Coefficient(cm^2/g)');
% xlim([min(soft_tissue_attn(1,:)), max(soft_tissue_attn(1,:))]);
% legend('Attenuation coefficient','Absorbption coefficient');