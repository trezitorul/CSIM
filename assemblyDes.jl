#assembly.jl
#By: Samuel Peana
#Purpose: This contains the methods required to build an assembly of multiple coils. This is constructed to allow 
#for the calculation of the effect of multiple coils acting on each other. These functions are designed to operate on#the coil type that is defined in coil.des
#An assembly is a collection of coils along with a translation vector given in x,y,z coordinates,
#and the rotation of the system given by two angles theta (vertical angle) and phi(horizontal angle)
#IE: [(coil,[x,y,z,theta,phi]),(more),(coils)]

export getAllCoilPairs,plotter,asbLen,weight,resistance, generateStackAsb

#Returns tuples containing all pairings between the selected coil (where the force is calculated) 
#Parameters:
#assembly, description of a particular arrangment of coils
#selected, the coil number of the coil where we wish to calculate the force
function getAllCoilPairs(assembly::Assembly,selected::Int64)
	out=[]
	for tcoils=assembly.coils
		vcat(out,[(assembly.mCoil,tcoils)])
	end
	return out
end

#Plots all of the coils in the assembly together, to verify the sanity of the assembly
#Parameters:
#assembly, collection of coils
#res, resolution with which to plot
function plotter(assembly::Assembly,res::Number)
	figure()
	for kcoil=assembly.coils
		plotter(kcoil,res)
	end
end

#This function calculates the length of wire required to build the assembly in question. This does exclude connector pieces
#Parameters:
#assembly, assembly whose length we wish to know

function asbLen(assembly::Assembly)
	len=coilLen(assembly.coils[1])
	for coil=assembly.coils[2:]
		len=len+coilLen(coil)
	end
	return len
end

#Calculates the resistance of an assembly
#Parameters:
#assembly, assembly whose resistance we wish to know
#resistance, the resistance per meter of the wire used to make the coil
function resistance(assembly::Assembly, resistance::Number)
	return resistance*asbLen(assembly)	
end

#This function calculates the weight of a coil given the density of the wire and its radius
#Parameters:
#assembly, assembly whose weight we wish to measure
#density, density of the metal being used for the coil
#radius, radius of the wire being used for the coil
function weight(assembly::Assembly,density::Number, radius::Number)
	return asbLen(coil)*density*pi*radius^2
end 

#Generates a stack of identical coils going in the z directions, with a given spacing and number
#Parameters:
#coil, the unit coil in the stack
#spacing, distance between coils in the stack
#num, number of coils in the stack
function generateStackAsb(coil::Coil,spacing::Number,num::Number)
	return Assembly([translate(coil,[0,0,z]) for z=[0:spacing:(num-1)*spacing]])
end