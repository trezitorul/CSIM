#These are the unit tests for the CSIM module, each function is tested here


function circle(theta)
	return [cos(theta),sin(theta),0]
end

function dcircle(theta)
	return [-sin(theta),cos(theta),0]
end

function generateTestAssembly(case)
	testCoil=
	if case==1 #Two Circles of radius 1 meter with spacing 1 meter
		println("Using Test Case 1")
		testCoil=Coil(theta->circle(theta),theta->dcircle(theta),0,2*pi)
		asb=Assembly([test,translate(test,[0,0,1])])
	elseif case==2
		println("Using Test Case 2")
		println("NOT IMPLEMENTED YET")
	end
	return asb
end

function LorentzForceLawTest():
	print("LorentzForceLawTest")
	return true
end

#Not completed TODO
function BTest(case):
	print("BTest")
	asb=generateTestAssembly(case)
	pass=false
	if case==1
		B(1,asb,1)
	end
	return true
end

#Runs all unit tests, and returns true if all pass

function autoTestAl():
	print("Testing BiotSavart")
	BiotSavartLawTest()
	print("Testing LoretnzForceLawTest")
	LorentzForceLawTest()
	print("Testing B test")
	BTest()
end



using CSIM

test=Coil(theta->circle(theta),theta->dcircle(theta),0,2*pi,1)
#test=translate(test,[0,0,1])
#plotter(test,.1)
asb=Assembly(test,[translate(test,[0,0,1])])
plotter(asb,.01)
println(B(test,[0,0,1]))
mFieldSliceZ3D(test,1,1,.1)
mFieldSliceZ2D(test,1,1,.1)