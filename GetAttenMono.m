function [phantom_attn] = GetAttenMono(phantom,energy,attns)
%UNTITLED2 이 함수의 요약 설명 위치
%   자세한 설명 위치
phantom_attn=phantom;
attn_values=GetAttnValues(attns,energy);
for i=1:length(attn_values) % three is number of available materials
    phantom_attn(phantom==i)=attn_values(i);
end
end

