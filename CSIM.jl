# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <headingcell level=1>

# Coil Simulator for Cubes by Samuel Peana

# <rawcell>

# Imports

# <codecell>

using PyPlot

# <headingcell level=2>

# Attempt Number 3: Using a parametarized curve and quadgk for integration

# <headingcell level=3>

# Section 1: Defining Useful Utilities

# <codecell>

#Converts vector of vector into len(A)x3 matrix for plotting
function converter(A)
  newA=[[testSpiral[n][1] for n=[1:length(testSpiral)]],[testSpiral[n][2] for n=[1:length(testSpiral)]],[testSpiral[n][3] for n=[1:length(testSpiral)]]]
  return reshape(newA,length(A),3)
end

# <codecell>

#This is the calculation of the biot-Savart law without the magnetic permitivity constant included
#The constant was not included since it is of the order 10^-7 and is a constant multiplicitive factor, which can
#Be added in at the very end for proper scaling. 
#Finally this biotSavart law does not include the dTheta term in dl because that is supplied by quadgk in the B 
#Calculator Below
mu=1
function biotSavart(I,f,df,r,theta)
  dl=df(theta)
  dr=f(theta)-r
  ldr=sqrt(dr[1]^2+dr[2]^2+dr[3]^2)
  f=I*cross(dl,dr)/ldr^3
  return f
end

# <codecell>

#Calculates the magnetic field due to the wire given by function f.
function B(I,f,df,r, thetaMax)
  BF=quadgk(theta -> biotSavart(I,f,df,r,theta),0,thetaMax)
  return BF
end

# <codecell>

#Plots the contour plot of the magnetic field of B
function mFieldSliceZ(I,f,df,thetaMax,W,Z,res)
  #print([-W:res:W])
  magField=[B(I,f,df,[x,y,Z],thetaMax)[1][3] for x=[-W:res:W],y=[-W:res:W]]
  #print(magField)
  x=[-W:res:W]
  plt=contourf(x,x,magField,100)
  colorbar(plt)
end

# <codecell>

#Plots the function of the coil that is parametrized in the function f at 
function plotF(f,thetaMax,res)
  line=[f(theta) for theta=[0:res:thetaMax]]
  plot3D([line[n][1] for n=[1:length(line)]],[line[n][2] for n=[1:length(line)]],[line[n][3] for n=[1:length(line)]])
end

# <headingcell level=3>

# Section 2: Verification of Utilities

# <rawcell>

# In this section we will test the magnetic field from 

# <codecell>

#The magnetic field in this ring is easy to calculate analytically so I will compute it first.
function ring(R,Z,theta)
  return [R*cos(theta),R*sin(theta),Z]
end

# <codecell>

function dring(R,Z,theta)
  return [-R*sin(theta),R*cos(theta),0]
end

# <codecell>

#Test of the line plotter to verify our ring parametrization
plotF(theta->ring(1,0,theta),2*pi,.01)

# <codecell>

mFieldSliceZ(1,theta->ring(1,1,theta),theta->dring(1,1,theta),2*pi,1,0,.1)

# <codecell>

B(1,theta->ring(1,1,theta),theta->dring(1,1,theta),[0,0,0],2*pi)

# <rawcell>

# These show that my magnetic field calculator/BiotSavart Law are actually valid calculations, and work properly, I am now ready to implement the Lorentz force law, which should allow for me to calculate the force now between two circles carrying a certain current. Which is the next step.

# <headingcell level=3>

# Section 3: Generate magnetic field plots for different functions

# <codecell>

testSpiral=[spiral(.001,2,0,theta) for theta in [0:.1:240]]
testSpiral=converter(testSpiral)
len=size(testSpiral)[1]
plot3D(testSpiral[1:len,1],testSpiral[1:len,2],testSpiral[1:len,3])

# <codecell>

biotSavart(1,theta -> spiral(.01,0,1,theta),theta->dspiral(.01,0,1,theta),[0,0,0],50)

# <codecell>

B(1,theta -> spiral(.01,0,1,theta),theta->dspiral(.01,0,1,theta),[0,0,0],240)

# <codecell>

function norm(A)
  val=sqrt(A[1]^2+A[2]^2+A[3]^2)
end

# <codecell>

magField=[[B(1,theta -> spiral(.01,0,1,theta),theta->dspiral(.01,0,1,theta),[x,y,0],240)[1][3] for x=-3:.1:3, y=-3:.1:3]]

# <codecell>

testSpiral=[spiral(.01,0,0,theta) for theta in [0:.1:240]]
testSpiral=converter(testSpiral)
len=size(testSpiral)[1]
plot(10*testSpiral[1:len,1]+30,10*testSpiral[1:len,2]+30)
plt=contourf(magField,100)
colorbar(plt)

# <codecell>

magFieldS=[[B(1,theta -> spiral(.001,2,1,theta),theta->dspiral(.001,2,1,theta),[x,y,0],240)[1][3] for x=-3:.1:3, y=-3:.1:3]]

# <codecell>

testSpiral=[spiral(.001,2,0,theta) for theta in [0:.1:240]]
testSpiral=converter(testSpiral)
len=size(testSpiral)[1]
plot(10*testSpiral[1:len,1]+30,10*testSpiral[1:len,2]+30)
plt=contourf(magFieldS,100)
colorbar(plt)

# <codecell>


# <codecell>

#Simple 2D spiral with start radius of R0, and incremental size increase of dw for complete period of theta
function spiral(dw,R0,z,theta)
  r=dw*theta+R0
  return [r*cos(theta),r*sin(theta),z]
end

# <codecell>

#Simple 2D spiral with start radius of R0, and incremental size increase of dw for complete period of theta
function dspiral(dw,R0,z,theta)
  r=dw*theta+R0
  return [dw*cos(theta)-r*sin(theta),dw*sin(theta)+r*cos(theta),0]
end

