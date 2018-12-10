function [ terma ] = terma_mono(fluence,source_params,phantom,phantom_params...
    ,attns,density)
% Function to calculate total energy released per unit mass(TERMA)
%   D=
E=source_params.beam_energy;
% E_flu=E*fluence;
[MassAttnMono,AttnMono]=GetAttenMono(phantom,E,attns,density);

phantom_mask=ones(size(phantom));
phantom_mask(phantom==0)=0;
beam_nx=source_params.beam_nx;
beam_dx=source_params.beam_dx;
beam_angles=source_params.beam_angles;
beam_SAD=source_params.beam_SAD;
terma=zeros([size(phantom),length(beam_angles)]);
for i=1:length(beam_angles)
    E_flu=E*fluence(:,i);
    beam_angle=beam_angles(i);
    beam_center=[beam_SAD*sind(beam_angle), beam_SAD*cosd(beam_angle)];
%     source_params.beam_angle=beam_angle;
    source_params.beam_center=[beam_SAD*sind(beam_angle), beam_SAD*cosd(beam_angle)];
    source_params.beam_x=beam_center(1)+cosd(beam_angle)*((0:beam_nx-1)-(beam_nx-1)/2)*beam_dx;
    source_params.beam_y=beam_center(2)-sind(beam_angle)*((0:beam_nx-1)-(beam_nx-1)/2)*beam_dx;
    terma(:,:,i)=RayTracing_2D(E_flu,source_params,AttnMono,MassAttnMono,phantom_params).*phantom_mask;
end
% terma=zeros(size(phantom));
% terma=
end

