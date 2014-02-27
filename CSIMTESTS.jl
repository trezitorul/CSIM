#These are the unit tests for the CSIM module, each function is tested here
using CSIM

function generateTestAssembly(case)
	testCoil=
	if case==1 #Two Circles of radius 1 meter with spacing 1 meter
		println("Using Test Case 1")
		testCoil=Coil(theta->circle(theta),theta->dcircle(theta),0,2*pi,1)
		asb=Assembly([testCoil, translate(testCoil,[0,0,1])])
	elseif case==2
		println("Using Test Case 2")
		println("NOT IMPLEMENTED YET")
	end
	return asb
end

function LorentzForceLawTest()
	print("LorentzForceLawTest")
	return true
end

#Not completed TODO
function BTest(case)
	println("BTest")
	err=.001
	asb=generateTestAssembly(case)
	pass=false
	if case==1
		if -err<=B(asb,[0,0,1])[3]-pi/sqrt(2)<=err
			pass=true
		end
	end
	return true
end

#Runs all unit tests, and returns true if all pass

function autoTestAll(case)
	#print("Testing LoretnzForceLawTest")
	#LorentzForceLawTest()
	println("Testing B test")
	println(BTest(case))
end





test=Coil(theta->circle(theta),theta->dcircle(theta),0,2*pi,1)
t1asb=Assembly([translate(test,[0,0,1])])
#test=translate(test,[0,0,1])
#plotter(test,.1)
asb=Assembly([test,translate(test,[0,0,1])])
plotter(asb,.01)
println(B(test,[1,0,1]))
print(lorentzForce(test,t1asb))
#mFieldSliceZ3D(test,1,1,.1,1)
#mFieldSliceZ3D(test,1,1,.1,2)
#mFieldSliceZ3D(test,1,1,.1,3)
#mFieldSliceZ2D(test,1,1,.1,1)
#mFieldSliceZ2D(test,1,1,.1,2)
#mFieldSliceZ2D(test,1,1,.1,3)
#autoTestAll(1)