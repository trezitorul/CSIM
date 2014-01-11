#visualUtils.jl
#This file contains the plotting and visualization utilities
#Utilities Contained within:
#mFieldSliceZ(Assembly): Plots a slice of the magnetic field on a plane perpendicular to the Z axis
#3DContourPlot(Assembly), plots the magnetic contour lines in 3DContour
#ForceVDistPlot(Assembly), plots the magnetic force vs distance
export mFieldSliceZ
#Plots the contour plot of the magnetic field of B
function mFieldSliceZ(I,coil::Coil,W,Z,res)
  #print([-W:res:W])
  magField=[B(I,coil,[x,y,Z])[1][3] for x=[-W:res:W],y=[-W:res:W]]
  #print(magField)
  x=[-W:res:W]
  plt=contourf(x,x,magField,100)
  colorbar(plt)
end
