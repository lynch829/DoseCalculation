function [ attn,absorption] = find_material( material,E )
%UNTITLED4 이 함수의 요약 설명 위치
%   자세한 설명 위치
global soft_tissue_attn soft_tissue_absor water_attn water_absor bone_attn bone_absor;
if(material==1)
    attn=interp1(water_attn(1,:),water_attn(2,:),E);
    absorption=interp(water_absor(1,:),water_absor(2,:),E);
else
    error('Material is not defined');
end

end

