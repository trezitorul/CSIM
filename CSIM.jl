#CSIM MKI simulator utilities
#By: Samuel Peana
#This module contains the utilities required to operate the simulator software

module CSIM

export Coil,Assembly

using ImmutableArrays
#using PyPlot


# abstract type representing a coil geometry
abstract Coil
# each concrete subtype of Coil should implement the following methods:
#  x, dx/dtheta = position(c::Coil, theta)
#  minimum(c::Coil) : the starting theta
#  maximum(c::Coil) : the ending theta
#  current(c::Coil) : current I flowing through the coil
#  current!(c::Coil, I) : sets current to I
#  translate(c::Coil, r) : translate coil by a vector r
import Base: minimum, maximum

#Geometric configuration of the coils
type Assembly
	coils::Vector{Coil} # Array of coils, used to store a particular geometric configuration of coils
	offset::Vector3{Float64}#The offset of the whole assembly
	I::Float64#Current of the assembly
	function Assembly(coils,offset,I)
		map(coil->current!(coil,I),coils)
		map(coil->translate!(coil,offset),coils)
		new(coils,offset,I)
	end
end

#Contains the module coilUtils that has utilities related to the coil type
include("coilUtils.jl")

#Contains code for the creation of an assembly
include("assemblyDes.jl")

#Contains the code for the visualization tools with the code
#include("visualUtils.jl")

#Contains the code for the optimization utilities for the simulator
#include("optimizationUtils.jl")

#Contains the code for the computational aspect of the simulator
include("BUtils.jl")

#Contains library of possible coil functions
include("coilLib.jl")

#Contains time based simulation utilities
include("timeUtils.jl")

end

