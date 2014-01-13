#CSIM MKI simulator utilities
#By: Samuel Peana
#This module contains the utilities required to operate the simulator software

module CSIM

export Coil,Assembly

type Coil
	#f and df are both parametrized functions with on changing parameter x
	f::Function#Geometry of the coil, returns an array with 3 elements for each parameter points
	df::Function#The derivative of f also returns an array with 3 elements
	xMin::Number#Starting value of the parameterization
	xMax::Number#Ending value of the parametrization
	I::Number#Current flowing through the Coil
end

#Geometric configuration of the coils
type Assembly
	coils::Array{Coil,1}#Array of coils, used to store a particular geometric configuration of coils
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

