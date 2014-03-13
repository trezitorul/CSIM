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
    Dr::Float64
    Width::Float64
    r0::Float64
    I::Float64
    offset::Vector3{Float64}

    linSpiral(Dr,Width,r0,I,offset::Vector3{Float64}=Vector3(0.,0.,0.)) =
        new(Dr,Width,r0,I,offset)
end

minimum(c::linSpiral) = 0.
maximum(c::linSpiral) = c.Width / c.Dr
current(c::linSpiral) = I
current!(c::linSpiral) = (c.I = I)

translate(c::linSpiral, r::Vector3{Float64}) = linSpiral(c.Dr, c.Width, c.r0,
                                                         c.I, c.offset + r)

function position(L::linSpiral, theta)
    c = cos(theta)
    s = sin(theta)
    r = L.r0 - L.Dr*theta
    return (L.offset + Vector3(r*c,r*s,0.0),
            Vector3(-L.Dr*c - r*s, -L.Dr*s + r*c, 0.0))
end
