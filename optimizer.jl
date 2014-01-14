#optimizer.jl
#This is where I will be optimizing the coil function, I plan on exploring several methods of optimization. The first of which is simply to use a spiral with a linear radial coefficient. Then I will explore other function types as I become more experienced.
#We are optimizing the geometry with respect to the force it can generate. For the moment I will simply be optimizing over two assemblies each consisting of identical coils lying one on top of the other with a spacing of 1mm or .001 meters

using CSIM

export linSpiral,dLinSpiral

function linSpiral(Dr,Width,r0,theta)
	thetaMax=Width/Dr
	return ([(r0-Dr*theta)*cos(theta),(r0-Dr*theta)*sin(theta),0],thetaMax)
end

function dLinSpiral(Dr,Width,r0,theta)
	return [-Dr*cos(theta)-(r0-Dr*theta)*sin(theta),-Dr*sin(theta)+(r0-Dr*theta)*cos(theta),0]
end

tCoil(Dr,Width,r0)=Coil(theta->linSpiral(Dr,Width,r0,theta)[1],theta->dLinSpiral(Dr,Width,r0,theta),0,linSpiral(Dr,Width,r0,0)[2],300)

#plotter(tCoil(.01,1,1),.01)


asb1=Assembly([tCoil(.00052,.0254,.0254),translate(tCoil(.00052,.0254,.0254),[0,0,-.00052])])
asb2=Assembly([translate(tCoil(.00052,.0254,.0254),[0,0,.001]),translate(tCoil(.00052,.0254,.0254),[0,0,.00152])])
plotter(asb1,.01)
plotter(asb2,.01)
force=lorentzForce(asb1,[asb2])
print(force/10^7)
#mFieldSliceZ3D(tCoil(.00052,.0254,.0254),.03,.001,.001,1)
#mFieldSliceZ3D(tCoil(.00052,.0254,.0254),.03,.001,.001,2)
#mFieldSliceZ3D(tCoil(.00052,.0254,.0254),.03,.001,.001,3)