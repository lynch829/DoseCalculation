function [ beam_location ] = beam_path( beam_pos,beam_direction,beam_energy...
    ,phantom,phantom_x,phantom_y,dx,dy)
%UNTITLED3 이 함수의 요약 설명 위치
%   자세한 설명 위치
beam_location=zeros(size(phantom));
beam_pos_original=beam_pos;
count=0;
if(beam_pos(1)
while beam_pos(1)>min(phantom_x) && beam_pos(1)<max(phantom_x) ...
        && beam_pos(2)>min(phantom_y) && beam_pos(2)<max(phantom_y)
    beam_pos=beam_pos+beam_direction.*[dx,dy];
    material1=phantom(beam_ind_x,beam_ind_y);
    beam_ind_x=round((beam_pos(1)-min(phantom_x))/dx+1);
    beam_ind_y=round((beam_pos(2)-min(phantom_y))/dy+1);
    count=count+1;
    material2=phantom(beam_ind_x,beam_ind_y);
    attn1=
    beam_location(beam_ind_x,beam_ind_y)=1;
end


end