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
    rIn::Float64#Width of the anulus (specifies maximum theta) allows for holes in the spiral
    rOut::Float64 #Initial outer radius of the spiral
    I::Float64#
    offset::Vector3{Float64}#Translation of the spiral in space

    linSpiral(Dr,rIn,rOut,I,offset::Vector3{Float64}=Vector3(0.,0.,0.)) =
        new(Dr,rIn,rOut,I,offset)
end

export minimum,maximum, current,current!,position,translate
#Required for the declaration of the lintype
minimum(c::linSpiral) = 0.
maximum(c::linSpiral) = (c.rOut-c.rIn) / c.Dr
current(c::linSpiral) = c.I
current!(c::linSpiral) = (c.I = I)

translate(c::linSpiral, r::Vector3{Float64}) = linSpiral(c.Dr, c.rIn, c.rOut, c.I, c.offset + r)

function position(L::linSpiral, theta)#Has the x, and dx/dtheta for the function representing theta
    c = cos(theta)
    s = sin(theta)
    r = L.rOut - L.Dr*theta
    return (L.offset + Vector3(r*c,r*s,0.0),
            Vector3(-L.Dr*c - r*s, -L.Dr*s + r*c, 0.0))
end
