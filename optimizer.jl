#optimizer.jl
#This is where I will be optimizing the coil function, I plan on exploring several methods of optimization. The first of which is simply to use a spiral with a linear radial coefficient. Then I will explore other function types as I become more experienced.
#We are optimizing the geometry with respect to the force it can generate. For the moment I will simply be optimizing over two assemblies each consisting of identical coils lying one on top of the other with a spacing of 1mm or .001 meters

using CSIM
using NLopt

count=0
#plotter(tCoil(.01,1,1),.01)
tCoil(Dr,Width,r0,I)=Coil(theta->linSpiral(Dr,Width,r0,theta)[1],theta->dLinSpiral(Dr,Width,r0,theta),0,linSpiral(Dr,Width,r0,0)[2],I)
voltage=10
println("Starting Optimizer")
function f(x::Vector,grad::Vector)
	global count
	count::Int+=1
#	println("f_$count($x)")

	coil=tCoil(x[1],x[2],.0254,1)
	current=voltage/resistance(coil,87.5/1000)
	coil.I=current
	if coil.I>=100
		coil.I=100
	end
	masb=Assembly([coil])
	tasb=Assembly([translate(coil,[0,0,.001])])
	return lorentzForce(masb,[tasb])[3]/10^7
end


opt = Opt(:LN_SBPLX,2)
lower_bounds!(opt,[.00052,.0033])
upper_bounds!(opt,[.0254,.0254])

xtol_rel!(opt,1e-4)

max_objective!(opt,f)

(maxf,maxX,ret)=optimize(opt,[.0152,.0152])
plotter(tCoil(maxX[1],maxX[2],.0254,1),.01)
#plotter(tCoil(.00052,.0254,.0254,1),.01)
println("got $maxf at $maxX after $count iterations (returned $ret)")