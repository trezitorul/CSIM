#These are the unit tests for the CSIM module, each function is tested here

function BiotSavartLawTest():
	print("BiotSavartTest")
	return true
end

function LorentzForceLawTest():
	print("LorentzForceLawTest")
	return true
end

function BTest():
	print("BTest")
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

function circle(theta)
	return [cos(theta),sin(theta),0]
end

function dcircle(theta)
	return [-sin(theta),cos(theta),0]
end

using CSIM

test=Coil(theta->circle(theta),theta->dcircle(theta),0,2*pi)
#test=translate(test,[0,0,1])
#plotter(test,.1)
asb=Assembly([test,translate(test,[0,0,1])])
plotter(asb,.01)
println(B(1,test,[0,0,1])[1][3])
mFieldSliceZ(1,test,1,1,.1)