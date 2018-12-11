from funcs import *
import numpy as np
import matplotlib.pyplot as plt
attns,material_indices=LoadData()
density=LoadDensity()
ph,ph_params=MakePhantom2(a=20,b=30)
fluence,source_params=DefineBeam_2D()
terma=terma_mono(fluence,source_params,ph,ph_params,attns,material_indices,density)
plt.imshow(np.sum(terma,2),cmap='gray')
plt.show()
#print(attn['Bone'])
