#coilLib.jl
#By: Samuel Peana
#This file is where I will store a few canned coil definitions for easy access and use.

export linSpiral,dLinSpiral,circle, dcircle

#
function circle(theta)
	return [cos(theta),sin(theta),0]
end

function dcircle(theta)
	return [-sin(theta),cos(theta),0]
end


#Linearly Decaying Spiral
function linSpiral(Dr,Width,r0,theta)
	thetaMax=Width/Dr
	return ([(r0-Dr*theta)*cos(theta),(r0-Dr*theta)*sin(theta),0],thetaMax)
end

function dLinSpiral(Dr,Width,r0,theta)
	return [-Dr*cos(theta)-(r0-Dr*theta)*sin(theta),-Dr*sin(theta)+(r0-Dr*theta)*cos(theta),0]
end