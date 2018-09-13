LoadCoefficients;
MakePhantom;
beam_pos=[-50, 0]; % real coordinate
beam_energy=6; % MeV
beam_direction=[1,0]; % direction vector
beam_location=beam_path(beam_pos,beam_direction,beam_energy,ph,x,y,dx,dy);
