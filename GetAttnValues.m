function [attn_values] = GetAttnValues(attns, energy)
%UNTITLED3 이 함수의 요약 설명 위치
%   자세한 설명 위치

attn_values=zeros(size(attns));
for i=1:length(attns)
    attn_materials=attns{i};
    attn_values(i)=interp1(attn_materials(1,:),attn_materials(2,:),energy);
end
end

