#Coil Description Module
#By: Samuel Peana
#Purpose: This module holds the code that contains a complete description of a coil, in practice this means that 
#This object contains getters and setters for the parameterized function and its derivative for usage in the calculator
#Along with the parameter start and stop points

#This is the complete description of a coil that allows for the computational features to compute parameters of the coil.

export createCoil,getCoilParams,getCoilF,getCoildF,getCoilxMax,getCoilxMin,plotter,translate,rotate,coilLen,resistance,weight

#Plots the coil in 3D, useful for sanity checking if coil function is reasonable
#Parameters:
#coil, represents the geometry of the coil being plotted
#res, resolution with which the coil is plotted
function plotter(coil::Coil,res::Number)
  line=[coil.f(theta) for theta=[coil.xMin:res:coil.xMax]]
  plot3D([1000*line[n][1] for n=[1:length(line)]],[line[n][2]*1000 for n=[1:length(line)]],[line[n][3]*1000 for n=[1:length(line)]])
  xlabel("X Axis (mm)")
  ylabel("Y Axis (mm)")
  zlabel("Z Axis (mm)")
end

#Translates the coil by a vector r
#Parameters:
#coil, represents the geometry of the coil being plotted
#r, array which is the 3D vector which represents how much to translate the original coil object by
function translate(coil::Coil,r)
	newCoil=Coil(coil.f,coil.df,coil.xMin,coil.xMax,coil.I)
	f(theta)=coil.f(theta)+r
	newCoil.f=theta->coil.f(theta)+r
	return newCoil
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

#TODO
function inductance(coil::Coil)
	print("Warning this function has not been implemented yet")
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
