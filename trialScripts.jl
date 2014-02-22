using CSIM

tCoil1(Dr,Width,r0)=Coil(theta->linSpiral(Dr,Width,r0,theta)[1],theta->dLinSpiral(Dr,Width,r0,theta),0,linSpiral(Dr,Width,r0,0)[2],250)
tCoil2(Dr,Width,r0)=Coil(theta->linSpiral(Dr,Width,r0,theta)[1],theta->dLinSpiral(Dr,Width,r0,theta),0,linSpiral(Dr,Width,r0,0)[2],250)
function diaConverter(diameter)
	return (diameter/6.28)
end


dr=diaConverter(.0010236)

asb1=Assembly([tCoil1(0.0001294,.0254,.0254)])
asb2=Assembly([translate(tCoil2(0.0001294,.0254,.0254),[0,0,.0001])])


#asb1=Assembly([tCoil(.00052,.0254,.0254),translate(tCoil(.00052,.0254,.0254),[0,0,-.00052])])
#asb2=Assembly([translate(tCoil(.00052,.0254,.0254),[0,0,.001])])
#asb1=Assembly([Coil(theta->.0254*circle(theta),theta->.0254*dcircle(theta),0,2*pi,50)])
#asb2=Assembly([translate(Coil(theta->.0254*circle(theta),theta->.0254*dcircle(theta),0,2*pi,50),[0,0,.001])])
plotter(asb1,.01)
#plotter(asb2,.01)
println(coilLen(asb1.coils[1])[1])
println(resistance(asb1.coils[1],87.5/1000))
println(asbLen(asb1))
println(resistance(asb1,87.5/1000))

#stack=generateStackAsb(tCoil(.00052,.0254,.0254),.00052,10)
#plotter(stack,.1)
force=lorentzForce(asb1,[asb2])
print(force/10^7)
#mFieldSliceZ3D(tCoil(.00052,.0254,.0254),.03,.001,.001,1)
#mFieldSliceZ3D(tCoil(.00052,.0254,.0254),.03,.001,.001,2)
#mFieldSliceZ3D(tCoil(.00052,.0254,.0254),.03,.001,.001,3)