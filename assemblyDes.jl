#assembly.jl
#By: Samuel Peana
#Purpose: This contains the methods required to build an assembly of multiple coils. This is constructed to allow 
#for the calculation of the effect of multiple coils acting on each other. These functions are designed to operate on#the coil type that is defined in coil.des
#An assembly is a collection of coils along with a translation vector given in x,y,z coordinates,
#and the rotation of the system given by two angles theta (vertical angle) and phi(horizontal angle)
#IE: [(coil,[x,y,z,theta,phi]),(more),(coils)]

function createAssembly(in)
	assembly=CSIM.assembly(in)
end

function getAllCoilPairs(assembly)
	out=[]
	for i=length(assembly.coils)
		for k=i:length(assembly.coils)
			vcat(out,[(assembly.coils[i],assembly.coils[k])])
		end
	end
	return out
end

function plotter(assembly::Assembly,res)
	for kcoil=assembly.coils
		plotter(kcoil,res)
	end
end
		
