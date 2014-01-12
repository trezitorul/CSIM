#Coil Description Module
#By: Samuel Peana
#Purpose: This module holds the code that contains a complete description of a coil, in practice this means that 
#This object contains getters and setters for the parameterized function and its derivative for usage in the calculator
#Along with the parameter start and stop points

#This is the complete description of a coil that allows for the computational features to compute parameters of the coil.

using PyPlot

export createCoil,getCoilParams,getCoilF,getCoildF,getCoilxMax,getCoilxMin,plotter,translate,rotate

#Plots the coil in 3D, useful for sanity checking if coil function is reasonable
#Parameters:
#coil, represents the geometry of the coil being plotted
#res, resolution with which the coil is plotted
function plotter(coil::Coil,res::Number)
  line=[coil.f(theta) for theta=[coil.xMin:res:coil.xMax]]
  plot3D([line[n][1] for n=[1:length(line)]],[line[n][2] for n=[1:length(line)]],[line[n][3] for n=[1:length(line)]])
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

#Rotates the coil object by angles xRot, yRot,zRot
#Parameters:
#coil, represents the geometry of the coil being plotted
#xRot, number in DEGREES representing the rotation about the x axis
#yRot, number in DEGREES representing the rotation about the y axis
#zRot, number in DEGREES representing the rotation about the z axis
function rotate(coil::Coil,xRot,yRot,zRot)
	print("Warning This Function is not yet complete")
	newCoil=coil
	Rx=eye(3)
	Ry=eye(3)
	Rz=eye(3)
	R=Rx*Ry*Rz
	newCoil.f=theta->R*coil.f(theta)
	return newCoil
end

#TODO
function inductance(coil::Coil)
	print("Warning this function has not been implemented yet")
end

#TODO
function resistance(coil::Coil)
	print("Warning this function has not been implemented yet")
end

#TODO
function coilLen(coil::Coil)
	print("Warning this function has not yet been implemented")
end

#TODO
function weight(coil::Coil)
	print("Warning this function has not yet been implemented")
end 
