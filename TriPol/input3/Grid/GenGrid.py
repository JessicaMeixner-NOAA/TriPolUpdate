import numpy as np
import netCDF4 as NC


grid_handle = NC.Dataset ('../ocean_hgrid.nc',mode = 'r' )
topog_handle = NC.Dataset ('../topog.nc',mode = 'r' )

# 2. Read in Super Grid
# 3. Read in Topog

Lon = grid_handle.variables['x'][:,:]
Lat = grid_handle.variables['y'][:,:]
H_DPT = topog_handle.variables['depth'][:,:]

print(np.shape(H_DPT))

H_MSK=np.zeros(np.shape(H_DPT))
H_LAT=np.zeros(np.shape(H_DPT))
H_LON=np.zeros(np.shape(H_DPT))

H_LAT = Lat[0:-1:2,0:-1:2]
H_LON = Lon[0:-1:2,0:-1:2]
print(Lat)
print(Lon)
print(H_LAT)
print(H_LON)

for ii in np.arange(0,210):
    for jj in np.arange(0,360):
        if (H_LAT[ii,jj]>80 and H_LAT[ii,jj]<91):
            H_MSK[ii,jj]=1

f1=open('../NewTriPol.Mask','w')
f2=open('../NewTriPol.Dpt','w')
f3=open('../NewTriPol.Obstr','w')
f4=open('../NewTriPol.Lat','w')
f5=open('../NewTriPol.Lon','w')
for ii in np.arange(150,210):
    for jj in np.arange(0,360):
        f1.write(str(H_MSK[ii,jj])+' ')
        f2.write(str(-H_DPT[ii,jj])+' ')
        f3.write(str(0.)+' ')
        f4.write(str(H_LAT[ii,jj])+' ')
        f5.write(str(H_LON[ii,jj])+' ')
    f1.write('\n')
    f2.write('\n')
    f3.write('\n')
    f4.write('\n')
    f5.write('\n')

for ii in np.arange(150,210):
    for jj in np.arange(0,360):
        f3.write(str(0.)+' ')
    f3.write('\n')

f1.close()
f2.close()
f3.close()
f4.close()
f5.close()


