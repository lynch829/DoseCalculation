LoadCoefficients;
MakePhantom2;
DefineBeam_2D;
terma=terma_mono(fluence_1d,source_params,ph,phantom_params,attns,density);
figure(2);imshow(terma,[]);
figure(3);plot(terma(:,128));hold on;plot(ph(:,128));hold off;
% beam_location=beam_path(beam_pos,beam_direction,beam_energy,ph,x,y,dx,dy);