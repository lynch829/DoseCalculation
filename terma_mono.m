function [ terma ] = terma_mono(fluence,source_params,phantom,phantom_params...
    ,attns,density)
% Function to calculate total energy released per unit mass(TERMA)
%   D=
E=source_params.beam_energy;
E_flu=E*fluence;
[MassAttnMono,AttnMono]=GetAttenMono(phantom,E,attns,density);

phantom_mask=ones(size(phantom));
phantom_mask(phantom==0)=0;
terma=RayTracing_2D(E_flu,source_params,AttnMono,MassAttnMono,phantom_params).*phantom_mask;
% terma=zeros(size(phantom));
% terma=
end

