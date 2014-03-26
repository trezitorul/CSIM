#visualUtils.jl
#This file contains the plotting and visualization utilities
#Utilities Contained within:
#mFieldSliceZ(Assembly): Plots a slice of the magnetic field on a plane perpendicular to the Z axis
#3DContourPlot(Assembly), plots the magnetic contour lines in 3DContour
#ForceVDistPlot(Assembly), plots the magnetic force vs distance
export mFieldSliceZ3D, mFieldSliceZ2D, zForceVsDistPlot,rFieldSlice2D,rFieldSlice3D
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
  return magField
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
  return magField
end
#Plots the radial component of the magnetic field of the coil on the plane perpendicular to the Z axis
#Parameters:
#Coil, geometry of the coil being energized
#W, number width of the plotting area (will plot a 2W by 2W square centered on zero)
#Z, number which represents the distance from 0 that the B field is measured at
#res, number representing the resolution with which the plots are made
function rFieldSlice2D(coil::Coil, W::Number,Z::Number,res::Number)
  figure()
  subplot(111)
  magField=[sqrt(B(coil,[x,y,Z])[1]^2+B(coil,[x,y,Z])[2]^2) for x=[-W:res:W],y=[-W:res:W]]
  x=[-W:res:W]
  plt=contourf(x,x,magField,100)
  colorbar(plt)
  return magField
end
#Plots the radial component of the magnetic field of the coil on the plane perpendicular to the Z axis
#Parameters:
#Coil, geometry of the coil being energized
#W, number width of the plotting area (will plot a 2W by 2W square centered on zero)
#Z, number which represents the distance from 0 that the B field is measured at
#res, number representing the resolution with which the plots are made
function rFieldSlice3D(coil::Coil, W::Number,Z::Number,res::Number)
  figure()
  subplot(111,projection="3d")
  magField=[sqrt(B(coil,[x,y,Z])[1]^2+B(coil,[x,y,Z])[2]^2) for x=[-W:res:W],y=[-W:res:W]]
  x=[-W:res:W]
  plt=contourf(x,x,magField,100)
  colorbar(plt)
  return magField
end
#Plots the force between two coils vs their separation
#Parameters:
#coil1,coil2, the coils between which the forces are to be calculated, notice that in both of these their displacement vectors should both be at 0
#start, the initial separation of the two coils
#stop, the final separation of the two coils
#The sampling resolution of the plotter
#Returns, the separation vector and the force for later processing if desired
function zForceVsDistPlot(coil1::Coil, coil2::Coil, start::Float64, stop::Float64, res::Float64)
  println("Starting zForceVsDistPlot")
  figure()
  subplot(111)
  x=[start:res:stop]
  y=Array(Float64,length(x))
  for i=[1:length(x)]
    println(x[i]/x[end])
    y[i]=lorentzForce(coil1,translate(coil2,Vector3(0.,0.,x[i])))[1][3]/10^7
  end
  plot(1000*x,y,linewidth=2,color="black")
  xlabel("Separation between Coils (mm)")
  ylabel("Force between Coils (N)")
  title("Force between Coils vs. Separation")
  return (x,y)
end


