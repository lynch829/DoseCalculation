LoadCoefficients;
MakePhantom;
DefineBeam_2D;
terma=terma_mono(fluence_1d,source_params,ph,phantom_params,attns);
figure(1);imshow(terma,[]);
% beam_location=beam_path(beam_pos,beam_direction,beam_energy,ph,x,y,dx,dy);