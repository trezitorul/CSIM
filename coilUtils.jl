#Coil Description Module
#By: Samuel Peana
#Purpose: This module holds the code that contains a complete description of a coil, in practice this means that 
#This object contains getters and setters for the parameterized function and its derivative for usage in the calculator
#Along with the parameter start and stop points

#This is the complete description of a coil that allows for the computational features to compute parameters of the coil.

using PyPlot

export createCoil,getCoilParams,getCoilF,getCoildF,getCoilxMax,getCoilxMin,plotter,translate,rotate

function plotter(coil::Coil,res)
  line=[coil.f(theta) for theta=[coil.xMin:res:coil.xMax]]
  plot3D([line[n][1] for n=[1:length(line)]],[line[n][2] for n=[1:length(line)]],[line[n][3] for n=[1:length(line)]])
end

function translate(coil::Coil,r)
	newCoil=Coil(coil.f,coil.df,coil.xMin,coil.xMax)
	f(theta)=coil.f(theta)+r
	newCoil.f=theta->coil.f(theta)+r
	return newCoil
end

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

function inductance(coil::Coil)
	print("Warning this function has not been implemented yet")
end

function resistance(coil::Coil)
	print("Warning this function has not been implemented yet")
end

function coilLen(coil::Coil)
	print("Warning this function has not yet been implemented")
end

function weight(coil::Coil)
	print("Warning this function has not yet been implemented")
end 
