function [terma] = RayTracing_2D(fluence,source_params,phantom_attn,phantom_mass_attn...
    ,phantom_params)
dx=phantom_params.dx;
dy=-phantom_params.dy;
phantom_origin=phantom_params.origin;
nx=phantom_params.nx;
ny=phantom_params.ny;
terma=zeros(nx,ny);
tol_min=1e-6;
tol_max=1e6;
% SDD=source_params.beam_SAD*2;
Xplane=(phantom_origin(1)-nx/2+(0:nx))*dx;
Yplane=(phantom_origin(2)-ny/2+(0:ny))*dy;
Xplane=Xplane-dx/2;
Yplane=Yplane-dy/2;
beam_x=source_params.beam_x;
beam_y=source_params.beam_y;
weight_map=zeros(nx,ny);
ref_vector=-source_params.beam_center;
fluence2=fluence;
for i=1:length(fluence)
% for i=10:10 %length(fluence)
    SourceX=beam_x(i);
    SourceY=beam_y(i);
    DetectorX=SourceX+2*ref_vector(1);
    DetectorY=SourceY+2*ref_vector(2);
    alpha_x=(Xplane-SourceX)/(DetectorX-SourceX);
    alpha_y=(Yplane-SourceY)/(DetectorY-SourceY);
    alpha_min=max([0,min(alpha_x(1),alpha_x(end)),min(alpha_y(1),alpha_y(end))]);
    alpha_max=min([1,max(alpha_x(1),alpha_x(end)),max(alpha_y(1),alpha_y(end))]);
    if(alpha_min>=alpha_max)
        continue;
    end
    if(SourceX==DetectorX)
        alpha_x=[];
    elseif(SourceX<DetectorX)
        i_min=ceil((nx+1)-(Xplane(end)-alpha_min*(DetectorX-SourceX)-SourceX)/dx);
        i_max=floor(1+(SourceX+alpha_max*(DetectorX-SourceX)-Xplane(1))/dx);
        alpha_x=alpha_x(i_min:i_max);
    else
        i_min=ceil((nx+1)-(Xplane(end)-alpha_max*(DetectorX-SourceX)-SourceX)/dx);
        i_max=floor(1+(SourceX+alpha_min*(DetectorX-SourceX)-Xplane(1))/dx);
        alpha_x=alpha_x(i_max:-1:i_min);
    end
    if(SourceY==DetectorY)
        alpha_y=[];
    elseif(SourceY>DetectorY)
        j_min=ceil((ny+1)-(Yplane(end)-alpha_min*(DetectorY-SourceY)-SourceY)/dy);
        j_max=floor(1+(SourceY+alpha_max*(DetectorY-SourceY)-Yplane(1))/dy);
        alpha_y=alpha_y(j_min:j_max);
    else
        j_min=ceil((ny+1)-(Yplane(end)-alpha_max*(DetectorY-SourceY)-SourceY)/dy);
        j_max=floor(1+(SourceY+alpha_min*(DetectorY-SourceY)-Yplane(1))/dy);
        alpha_y=alpha_y(j_max:-1:j_min);
    end
    alpha=uniquetol(sort([alpha_min,alpha_x,alpha_y,alpha_max]),tol_min/alpha_max);
    l=zeros(length(alpha)-1,1);
    d12=sqrt((SourceX-DetectorY)^2+(SourceY-DetectorY)^2);
%     fprintf('%f\n',d12);
    for j=1:length(l)
        l(j)=d12*(alpha(j+1)-alpha(j));
        alpha_mid=(alpha(j+1)+alpha(j))/2;
        xx=(SourceX+alpha_mid*(DetectorX-SourceX)-Xplane(1))/dx;
        yy=(SourceY+alpha_mid*(DetectorY-SourceY)-Yplane(1))/dy;
        if(abs(xx)<=tol_min)
            xx=0;
        end
        if(abs(yy)<=tol_min)
            yy=0;
        end
        index_x=floor(xx+1);
        index_y=floor(yy+1);
%         fprintf('%f %f\n',fluece2(i), fluence2(i)*exp(-l(j)*phantom_attn(index_y,index_x)));
        assert(fluence2(i)>=fluence2(i)*exp(-l(j)*phantom_attn(index_y,index_x)));
        
        fluence2(i)=fluence2(i)*exp(-l(j)*phantom_attn(index_y,index_x));
%         fprintf('%f %f\n',l(j),fluence2(i));
        terma(index_y,index_x)=phantom_mass_attn(index_y,index_x)*fluence2(i);
%             weight_map(index_y,index_x,angle_index)=weight_map(index_y,index_x,angle_index)+l(i);
    end
end
end

