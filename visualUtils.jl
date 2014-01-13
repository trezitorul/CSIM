#visualUtils.jl
#This file contains the plotting and visualization utilities
#Utilities Contained within:
#mFieldSliceZ(Assembly): Plots a slice of the magnetic field on a plane perpendicular to the Z axis
#3DContourPlot(Assembly), plots the magnetic contour lines in 3DContour
#ForceVDistPlot(Assembly), plots the magnetic force vs distance
export mFieldSliceZ3D, mFieldSliceZ2D
#Plots the contour plot of the magnetic field of B on a plane perpendicular to the Z axis,showing the magnitude on the z axis
#Parameters:
#Coil, geometry of the coil being energized
#W, number width of the plotting area (will plot a 2W by 2W square centered on zero)
#Z, number which represents the distance from 0 that the B field is measured at
#res, number representing the resolution with which the plots are made
function mFieldSliceZ3D(coil::Coil,W::Number,Z::Number,res::Number, dim::Number)
  figure()
  subplot(111,projection="3d")
  magField=[B(coil,[x,y,Z])[dim] for x=[-W:res:W],y=[-W:res:W]]
  #print(magField)
  x=[-W:res:W]
  plt=contourf(x,x,magField,100)
  colorbar(plt)
end

#Plots the contour plot of the magnetic field of B on a plane perpendicular to the Z axis
#Parameters:
#Coil, geometry of the coil being energized
#W, number width of the plotting area (will plot a 2W by 2W square centered on zero)
#Z, number which represents the distance from 0 that the B field is measured at
#res, number representing the resolution with which the plots are made
function mFieldSliceZ2D(coil::Coil,W::Number,Z::Number,res::Number,dim::Number)
  figure()
  subplot(111)
  magField=[B(coil,[x,y,Z])[dim] for x=[-W:res:W],y=[-W:res:W]]
  #print(magField)
  x=[-W:res:W]
  plt=contourf(x,x,magField,100)
  colorbar(plt)
end


