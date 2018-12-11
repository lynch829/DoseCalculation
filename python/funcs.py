import numpy as np
import os,sys
import time
import matplotlib.pyplot as plt
import logging
logger=logging.getLogger()
logger.setLevel(logging.DEBUG)
stream_handler=logging.StreamHandler()
logger.addHandler(stream_handler)
sin=np.sin
cos=np.cos
pi=np.pi
sqrt=np.sqrt

def uniquetol(in_data,tolerance):
    tol=tolerance*np.max(np.abs(in_data))
    results=[in_data.pop(0)]
    for i in in_data:
        if(np.abs(results[-1]-i)<=tol):
            continue
        results.append(i)
    return results
def RayDriven2D_weight(SourceX,SourceY,DetectorX,DetectorY,Xplane,Yplane,nx,ny,dx,dy,tol_min):
    eps=1e-5
    alpha_x=(Xplane-SourceX)/(DetectorX-SourceX+eps)
    alpha_y=(Yplane-SourceY)/(DetectorY-SourceY+eps)
    alpha_min=np.max([0,np.min([alpha_x[0],alpha_x[-1]]),np.min([alpha_y[0],alpha_y[-1]])])
    alpha_max=np.min([1,np.max([alpha_x[0],alpha_x[-1]]),np.max([alpha_y[0],alpha_y[-1]])])
    if(alpha_min>=alpha_max):
        #continue
        alpha=[]
        return alpha
    if(SourceX==DetectorX):
        alpha_x=[]
    elif(SourceX<DetectorX):
        i_min=int(np.ceil((nx+1)-(Xplane[-1]-alpha_min*(DetectorX-SourceX)-SourceX)/dx))
        i_max=int(np.floor(1+(SourceX+alpha_max*(DetectorX-SourceX)-Xplane[0])/dx))
        alpha_x=alpha_x[i_min:i_max]
    else:
        i_min=int(np.ceil((nx+1)-(Xplane[-1]-alpha_max*(DetectorX-SourceX)-SourceX)/dx))
        i_max=int(np.floor(1+(SourceX+alpha_min*(DetectorX-SourceX)-Xplane[0])/dx))
        alpha_x=alpha_x[i_max:i_min:-1]
    if(SourceY==DetectorY):
        alpha_y=[]
    elif(SourceY>DetectorY):
        j_min=int(np.ceil((ny+1)-(Yplane[-1]-alpha_min*(DetectorY-SourceY)-SourceY)/dy))
        j_max=int(np.floor(1+(SourceY+alpha_max*(DetectorY-SourceY)-Yplane[0])/dy))
        alpha_y=alpha_y[j_min:j_max]
    else:
        j_min=int(np.ceil((ny+1)-(Yplane[-1]-alpha_max*(DetectorY-SourceY)-SourceY)/dy))
        j_max=int(np.floor(1+(SourceY+alpha_min*(DetectorY-SourceY)-Yplane[0])/dy))
        alpha_y=alpha_y[j_max:j_min:-1]
    alpha=[alpha_min]
    alpha.extend(alpha_x)
    alpha.extend(alpha_y)
    alpha.append(alpha_max)
    alpha=uniquetol(sorted(alpha),tol_min/alpha_max)
    return alpha
def RayTracing_2D(fluence,source_params,phantom_attn,phantom_mass_attn,phantom_params):
    dx=phantom_params['dx']
    dy=-phantom_params['dy']
    phantom_origin=phantom_params['origin']
    nx=phantom_params['nx']
    ny=phantom_params['ny']
    terma=np.zeros([nx,ny],dtype=np.float32)
    tol_min=1e-6
    tol_max=1e6
    Xplane=(phantom_origin[0]-nx/2.0+np.arange(nx+1))*dx
    Yplane=(phantom_origin[1]-ny/2.0+np.arange(ny+1))*dy
    Xplane-=dx/2.0
    Yplane-=dy/2.0
    beam_x=source_params['beam_x']
    beam_y=source_params['beam_y']
    ref_vector=-np.array(source_params['beam_center'])
    fluence2=np.copy(fluence)
    for i in range(len(fluence)):
        SourceX=beam_x[i]
        SourceY=beam_y[i]
        DetectorX=SourceX+2.0*ref_vector[0]
        DetectorY=SourceY+2.0*ref_vector[1]
        alpha=RayDriven2D_weight(SourceX,SourceY,DetectorX,DetectorY,Xplane,Yplane,nx,ny,dx,dy,tol_min)
        l=np.zeros(len(alpha)-1,dtype=np.float32)
        d12=sqrt((SourceX-DetectorX)**2+(SourceY-DetectorY)**2)
        for j in range(len(l)):
            l[j]=d12*(alpha[j+1]-alpha[j])
            alpha_mid=(alpha[j+1]+alpha[j])/2.0
            xx=(SourceX+alpha_mid*(DetectorX-SourceX)-Xplane[0])/dx
            yy=(SourceY+alpha_mid*(DetectorY-SourceY)-Yplane[0])/dy
            if(abs(xx)<=tol_min):
                xx=0
            if(abs(yy)<=tol_min):
                yy=0
            index_x=int(np.floor(xx))
            index_y=int(np.floor(yy))
            fluence2[i]=fluence2[i]*np.exp(-l[j]*phantom_attn[index_y,index_x])
            #terma[index_x,index_y]=phantom_mass_attn[index_x,index_y]*fluence2[i]
            terma[index_y,index_x]=phantom_mass_attn[index_y,index_x]*fluence2[i]

    return terma
def GetAttenMono(phantom,energy,attns,material_indices,density):
    mass_attn=np.copy(phantom)
    attn=np.copy(phantom)
    attn_values=GetAttnValues(attns,energy)
    materials=attn_values.keys()
    for m in materials:
        material_ind=material_indices[m]
        mass_attn[np.where(phantom==material_ind)]=attn_values[m]
        attn[np.where(phantom==material_ind)]=attn_values[m]*density[m]
    return mass_attn,attn

def GetAttnValues(attns,energy):
    materials=attns.keys()
    attn_values={}
    for m in materials:
        attn_material=attns[m]
        attn_values[m]=np.interp(energy,attn_material[:,0],attn_material[:,1])
    return attn_values
    
def terma_mono(fluence,source_params,phantom,phantom_params,attns,material_indices,density):
    E=source_params['energy']
    MassAttnMono,AttnMono=GetAttenMono(phantom,E,attns,material_indices,density)
    phantom_mask=np.ones(phantom.shape,dtype=np.float32)
    phantom_mask[np.where(phantom==0)]=0
    beam_nx=source_params['nx']
    beam_dx=source_params['dx']
    beam_SAD=source_params['SAD']
    beam_angles=source_params['angles']
    terma=np.zeros([phantom_params['nx'],phantom_params['ny'],len(beam_angles)],dtype=np.float32)
    for i in range(len(beam_angles)):
        E_flu=E*fluence[:,i]
        beam_angle=beam_angles[i]*pi/180.0
        beam_center=[beam_SAD*sin(beam_angle),beam_SAD*cos(beam_angle)]
        beam_x=beam_center[0]+cos(beam_angle)*(np.arange(beam_nx)-(beam_nx-1)/2.0)*beam_dx
        beam_y=beam_center[1]-sin(beam_angle)*(np.arange(beam_nx)-(beam_nx-1)/2.0)*beam_dx
        source_params['beam_x']=beam_x
        source_params['beam_y']=beam_y
        source_params['beam_center']=beam_center
        #logger.debug([AttnMono,MassAttnMono])
        terma[:,:,i]=RayTracing_2D(E_flu,source_params,AttnMono,MassAttnMono,phantom_params)*phantom_mask
        #terma[:,:,i]=RayTracing_2D(E_flu,source_params,AttnMono,MassAttnMono,phantom_params)
    return terma

def DefineBeam_2D():
    beam_SAD=50
    beam_angles=[0,50,100,150,200,250]
    beam_energy=6000
    beam_nx=21
    beam_dx=0.25
    beam_dy=0.25
    source_params={'SAD':beam_SAD,'angles':beam_angles,'energy':beam_energy,'dx':beam_dx,'nx':beam_nx}
    fluence=np.ones([beam_nx,len(beam_angles)],dtype=np.float32)
    return fluence,source_params
def MakePhantom(a,b):
    nx=256
    ny=256
    dx=0.5
    dy=0.5
    origin=[0,0]
    x=(np.arange(0,nx)-nx/2.0)*dx+origin[0]
    y=(np.arange(0,ny)-ny/2.0)*dy+origin[1]
    phantom_params={'nx':nx,'ny':ny,'dx':dx,'dy':dy,'origin':origin}
    [xx,yy]=np.meshgrid(x,y)
    eclipse=(xx**2/a**2)+(yy**2/b**2)
    ph=np.zeros([nx,ny],dtype=np.float32)
    ph[np.where(elicpse<1)]=1
    return ph,phantom_params

def MakePhantom2(a,b):
    nx=256
    ny=256
    dx=0.5
    dy=0.5
    origin=[0,0]
    x=(np.arange(0,nx)-nx/2.0)*dx+origin[0]
    y=(np.arange(0,ny)-ny/2.0)*dy+origin[1]
    phantom_params={'nx':nx,'ny':ny,'dx':dx,'dy':dy,'origin':origin}
    [xx,yy]=np.meshgrid(x,y)
    eclipse=(xx**2/a**2)+(yy**2/b**2)
    ph=np.zeros([nx,ny],dtype=np.float32)
    ph[np.where(eclipse<1)]=1
    circle=(xx**2+yy**2)
    ph[np.where(circle<5)]=2
    return ph,phantom_params

def LoadDensity():
    density={}
    density['Water']=1.0000
    density['Bone']=1.040
    density['SoftTissue']=1.060
    return density

def LoadData():
    Water_filename='../MaterialData/WaterCoeff.txt'
    water_attn=Read_attn(Water_filename)
    Bone_filename='../MaterialData/BoneCoeff.txt'
    bone_attn=Read_attn(Bone_filename)
    SoftTissue_filename='../MaterialData/SoftTissueCoeff.txt'
    soft_tissue_attn=Read_attn(SoftTissue_filename)
    attn={'Water':water_attn,'Bone': bone_attn,'SoftTissue': soft_tissue_attn}
    material_indices={'Water':1,'Bone':2,'SoftTissue':3}
    return attn,material_indices

def Read_attn(filename):
    f=open(filename)
    count=0
    while True:
        l=f.readline().strip()
        if not l: break
        if len(l.split())!=3: continue
        count+=1
    f.close()
    data=np.zeros([count,2],dtype=np.float32)
    f=open(filename)
    c=0
    while True:
        l=f.readline().strip()
        if not l: break
        if len(l.split())!=3: continue
        line=l.split()
        data[c,0]=float(line[0])*1000.0
        data[c,1]=float(line[1])
        c+=1
    f.close()
    return data
