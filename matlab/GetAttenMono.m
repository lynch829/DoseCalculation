function [mass_attn,attn] = GetAttenMono(phantom,energy,attns,density)
%UNTITLED2 이 함수의 요약 설명 위치
%   자세한 설명 위치
mass_attn=phantom;
attn=phantom;
attn_values=GetAttnValues(attns,energy);
for i=1:length(attn_values) % three is number of available materials
    mass_attn(phantom==i)=attn_values(i);
    attn(phantom==i)=attn_values(i)*density(i);
end
end

