import numpy as np

P=np.arange(0,360)
Q=np.arange(0,211)

f=open('../TriPol.Lat')
Y=np.zeros([211,360])
ny=0
for l in f:
    Y[ny,:]=l.split()
    ny=ny+1
f.close()

f=open('../TriPol.Lon')
X=np.zeros([211,360])
nx=0
for l in f:
    X[nx,:]=l.split()
    nx=nx+1
f.close()


MSK=np.zeros([211,360])
for ii in np.arange(0,211):
    for jj in np.arange(0,360):
        if (Y[ii,jj]>75 and Y[ii,jj]<91):
            MSK[ii,jj]=1

f=open('../TriPol.NewMask','w')
f2=open('../TriPol.Deep','w')
for ii in np.arange(0,211):
    for jj in np.arange(0,360):
        f.write(str(MSK[ii,jj])+' ')
        f2.write(str(-1000.)+' ')
    f.write('\n')
    f2.write('\n')
f.close()
f2.close()


print(X[:,0])
print(Y[:,0])
print(MSK[:,0])

print(X[65,314])
print(Y[65,314])

print(np.max(np.max(Y)))
