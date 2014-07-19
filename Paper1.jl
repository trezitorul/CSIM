#Paper1.jl
#These are the scripts and functions that are used to create the plots and results of the first paper for 18.384
using CSIM

spiral(Dr,Width,r0)=Coil(theta->linSpiral(Dr,Width,r0,theta)[1],theta->dLinSpiral(Dr,Width,r0,theta),0,linSpiral(Dr,Width,r0,0)[2],250)

asb1=Assembly([spiral(0.0001294,.0254,.0254)])
asb2=Assembly([translate(spiral(0.0001294,.0254,.0254),[0,0,.0001])])

println("Plotting Force vs. Distance")
function fvd20Gauge()
	zvd=zForceVsDistPlot(spiral(0.0001294,.0254,.0254),spiral(0.0001294,.0254,.0254), 0.00051054,.06,.0005)
end

function fvd24Gauge()
	zvd=zForceVsDistPlot(spiral(0.00008125496,.0254,.0254),spiral(0.00008125496,.0254,.0254),0.00051054,.06,.0005)
end

function plot24Gauge()
	plotter(spiral(0.00008125496,.0254,.0254),.01)
end

function plot20Gauge()
	plotter(spiral(0.0001294,.0254,.0254),.01)
end

function plotRMag20Gauge()
	rFieldSlice(spiral(0.0001294,.0254,.0254),.0260/2,.1,.1)
end

function plotRMag20Gauge()
	rFieldSlice2D(spiral(0.0001294,.0254,.0254),.0260,.1,.001)
end

function plotRMag24Gauge()
	rFieldSlice2D(spiral(0.00008125496,.0254,.0254),.0260,.1,.001)
end


fvd24Gauge()
#plotRMag24Gauge()
#plot20Gauge()
#title("20 Gauge Spiral")
#plot24Gauge()