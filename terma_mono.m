function [ terma ] = terma_mono(fluence,source_params,phantom,phantom_params,attns)
% Function to calculate total energy released per unit mass(TERMA)
%   D=
E=source_params.beam_energy;
E_flu=E*fluence;
AttnMono=GetAttenMono(phantom,E,attns);
terma=RayTracing_2D(E_flu,source_params,AttnMono,phantom_params);
% terma=zeros(size(phantom));
% terma=
end

