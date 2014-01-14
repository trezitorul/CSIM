#assembly.jl
#By: Samuel Peana
#Purpose: This contains the methods required to build an assembly of multiple coils. This is constructed to allow 
#for the calculation of the effect of multiple coils acting on each other. These functions are designed to operate on#the coil type that is defined in coil.des
#An assembly is a collection of coils along with a translation vector given in x,y,z coordinates,
#and the rotation of the system given by two angles theta (vertical angle) and phi(horizontal angle)
#IE: [(coil,[x,y,z,theta,phi]),(more),(coils)]

export getAllCoilPairs,plotter

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
		
