function [ terma ] = TERMA_mono(fluence,source_params,phantom,phantom_params)
% Function to calculate total energy released per unit mass(TERMA)
%   D=
E=source_params.beam_energy;
E_flu=E*fluence;
AttnMono=GetAttenMono(phantom,E);
l=RayTracing(E_flu,source_params,phantom,phantom_params);
terma=zeros(size(phantom));
terma=
end

