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

function autoTestAll():
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

test=Coil(theta->circle(theta),theta->dcircle(theta),0,6.3)
#test=translate(test,[0,0,1])
#plotter(test,.1)
asb=Assembly([test,translate(test,[0,0,1])])
plotter(asb,.1)
