#Coil Description Module
#By: Samuel Peana
#Purpose: This module holds the code that contains a complete description of a coil, in practice this means that 
#This object contains getters and setters for the parameterized function and its derivative for usage in the calculator
#Along with the parameter start and stop points

#This is the complete description of a coil that allows for the computational features to compute parameters of the coil.

export createCoil,getCoilParams,getCoilF,getCoildF,getCoilxMax,getCoilxMin,plotter,translate,rotate,coilLen,resistance,weight,inductance

using Cubature
include("coilLib.jl")
#Plots the coil in 3D, useful for sanity checking if coil function is reasonable
#Parameters:
#coil, represents the geometry of the coil being plotted
#res, resolution with which the coil is plotted
function plotter(coil::Coil,res::Number)
  line=[position(coil,theta)[1] for theta=[minimum(coil):res:maximum(coil)]]
  plot3D([1000*line[n][1] for n=[1:length(line)]],[line[n][2]*1000 for n=[1:length(line)]],[line[n][3]*1000 for n=[1:length(line)]])
  xlabel("X Axis (mm)")
  ylabel("Y Axis (mm)")
  zlabel("Z Axis (mm)")
end

#Parameters:
#value: value in degrees
#return: angle in rad
function degree_to_rad(value)
	return value / 180 * pi
end

#Rotates the coil object by angles xRot, yRot,zRot
#Parameters:
#coil, represents the geometry of the coil being plotted
#xRot, number in DEGREES representing the rotation about the x axis
#yRot, number in DEGREES representing the rotation about the y axis
#zRot, number in DEGREES representing the rotation about the z axis
#NOTE: assuming the angle of rotation between -180 to 180, but should work for any angle
#using formula from here: http://en.wikipedia.org/wiki/Rotation_matrix
function rotate(coil::Coil,xRot,yRot,zRot)
	print("Warning This Function is only assumed to be correct, but not tested :)")
	newCoil=coil
	Rx=eye(3)
	theta_x = degree_to_rad(xRot)
	Rx[2,2] = cos(theta_x)
	Rx[3,3] = cos(theta_x)
	Rx[2,3] = -sin(theta_x)
	Rx[3,2] = sin(theta_x)
	Ry=eye(3)
	theta_y = degree_to_rad(yRot)
	Ry[1,1] = cos(theta_y)
	Ry[1,3] = sin(theta_y)
	Ry[3,1] = -sin(theta_y)
	Ry[3,3] = cos(theta_y)
	Rz=eye(3)
	theta_z = degree_to_rad(zRot)
	Rz[1,1] = cos(theta_z)
	Rz[1,2] = -sin(theta_z)
	Rz[2,1] = sin(theta_z)
	Rz[2,2] = cos(theta_z)
	R=Rx*Ry*Rz
	# not sure if this is correct - where does theta comes from?
	newCoil.f=theta->R*coil.f(theta)
	# coil.f = R*coil.f
	return newCoil
end

#Calculates the inductance of a single layer coil
#Parameters:
#coil, coil whose inductance we wish to calculate
#reltoler is the relative tolerance that the integrator will integrate to.
function inductance(coil::linSpiral,reltoler=.001)
	println("WARNING FUNCTION NOT PASSING BASIC TESTS")
	rmax=coil.rOut
	coil.I=1.0
	println("hello")
	println(coil.I)
	z=coil.offset[3]+coil.Dr*pi/2#The z component of the coil (assumed parallel to the z plane) with the offset 
	# to calculate flux at the surface of our coil since they have a finite diameter.
	#r[1]=radius
	#r[2]=theta in polar coord.
  return hcubature(r -> r[1]*B(coil,Vector3(r[1]*cos(r[2]),r[1]*sin(r[2]),z))[3],[0.0,0.0],[rmax,2*pi],reltol=reltoler)
end

#Calculates the inductance of an assembly
#Parameters: 
#asb, assembly whose induction we wish to calculate 
#reltoler, relative tolerance of the integrator
function inductance(asb::Assembly,reltoler=.001)
	println("WARNING FUNCTION NOT PASSING BASIC TESTS")
	current!(asb,1.0)
	induct=[0.0,0.0]
	temp=0.0
	for i=1:length(asb.coils)
		rmax=asb.coils[i].rOut
		z=asb.coils[i].offset[3]+asb.coils[i].Dr*pi
		temp=hcubature(r -> r[1]*B(asb,Vector3(r[1]*cos(r[2]),r[1]*sin(r[2]),z))[3],[0.0,0.0],[rmax,2*pi],reltol=reltoler/length(asb.coils))
		println(temp)
		induct[1]=induct[1]+temp[1]
		induct[2]=induct[2]+temp[2]
	end
	return induct
end




#Calculates the resistance of a coil
#Parameters:
#coil, coil whose resistance we wish to know
#resistance, the resistance per meter of the wire used to make the coil
function resistance(coil::Coil,resistance::Number)
	return coilLen(coil)*resistance
end

#This function calculates the length of a coil
#Parameters:
#coil, the coil whose length we wish to know
function coilLen(coil::Coil)
	return quadgk(theta->norm(coil.df(theta)),coil.xMin,coil.xMax)[1]
end

#This function calculates the weight of a coil given the density of the wire and its radius
#Parameters:
#coil, coil whose weight we wish to measure
#density, density of the metal being used for the coil
#radius, radius of the wire being used for the coil
function weight(coil::Coil,density::Number, radius::Number)
	return coilLen(coil)*density*pi*radius^2
end 
