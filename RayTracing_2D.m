function [outputArg1,outputArg2] = RayTracing_2D(fluence,phantom,phantom_params,source_params)
dx=phantom_params.dx;
dy=phantom_params.dy;
phantom_origin=phantom_params.origin;
nx=phantom_params.nx;
ny=phantom_params.ny;
tol_min=1e-6;
tol_max=1e6;
Xplane=(phantom_origin(1)-nx/2+(0:nx))*dx;
Yplane=(phantom_origin(2)-ny/2+(0:ny))*dy;
Xplane=Xplane-dx/2;
Yplane=Yplane-dy/2;
beam_x=source_params.beam_x;
beam_y=source_params.beam_y;
weight_map=zeros(nx,ny);
for i=1:length(fluence)
        SourceX=beam_x(i);
        SourceY=beam_y(i);
        
end
end

