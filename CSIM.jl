#CSIM MKI simulator utilities
#By: Samuel Peana
#This module contains the utilities required to operate the simulator software

module CSIM

export Coil,Assembly

type Coil
	f
	df
	xMin::Number
	xMax::Number
end

type Assembly
	coils
end

#Contains the module coilUtils that has utilities related to the coil type
include("coilUtils.jl")

#Contains code for the creation of an assembly
include("assemblyDes.jl")

#Contains the code for the visualization tools with the code
include("visualUtils.jl")

#Contains the code for the optimization utilities for the simulator
#include("optimizationUtils.jl")

#Contains the code for the computational aspect of the simulator
include("BUtils.jl")

end

