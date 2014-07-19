#coilLib.jl
#By: Samuel Peana
#This file is where I will store a few canned coil definitions for easy access and use.

export linSpiral,circle, dcircle

#
function circle(theta)
	return [cos(theta),sin(theta),0]
end

function dcircle(theta)
	return [-sin(theta),cos(theta),0]
end

using ImmutableArrays

type linSpiral <: Coil
    Dr::Float64#Decay rate of the spiral
    rIn::Float64#Inner radius of the anulus that the coils is in.
    rOut::Float64 #Initial outer radius of the spiral
    I::Float64#
    offset::Vector3{Float64}#Translation of the spiral in space

    linSpiral(Dr,rIn,rOut,I,offset::Vector3{Float64}=Vector3(0.,0.,0.)) =
        new(Dr,rIn,rOut,I,offset)
end

export minimum,maximum, current,current!,position,translate,translate!
#Required for the declaration of the lintype
minimum(c::linSpiral) = 0. #Gives minimum parameter size (typically 0)
maximum(c::linSpiral) = (c.rOut-c.rIn) / c.Dr#Gives maximum parameter size computed from inner and outer radii

current(c::linSpiral) = c.I #Returns the current of the spiral
current!(c::linSpiral,I) = (c.I = I)#Sets the current of the spiral in place (Useful if doing computation where memory allocations would be expensive)

translate(c::linSpiral, r::Vector3{Float64}) = linSpiral(c.Dr, c.rIn, c.rOut, c.I, r)#Translates by a vector r in space, returns a new linspiral
translate!(c::linSpiral, r::Vector3{Float64}) = (c.offset=r)#Translates by a vector r in space, note this operates in place on the spiral (useful if doing computation were memallocs would be costly)

function position(L::linSpiral, theta)#Has the x, and dx/dtheta for the function representing coil for a lin spiral
    c = cos(theta)
    s = sin(theta)
    r = L.rOut - L.Dr*theta
    return (L.offset + Vector3(r*c,r*s,0.0),
            Vector3(-L.Dr*c - r*s, -L.Dr*s + r*c, 0.0))
end
