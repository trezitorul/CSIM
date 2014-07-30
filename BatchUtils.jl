#Batch Utilities
#Automation Scripts for large batch runs

#EnergyBatchRun
#Takes in a configuration, and applies the following parameters to it, then executes the energy calculation
#Parameters: 
#mAsb: mobile Assembly
#fAsb: fixed Assembly
using CSIM

function coilEnergy(mAsb,fAsb,loadMass,V,R,bankSize, initOffset,runName)
	tau=R*bankSize
	tmax=4*tau
	bankEnergy=.5*bankSize*V*V
	I0=V/R
	mAsb
	wireDia=mAsb.coils[1].Dr*2*pi
	xOffset=initOffset[1]
	yOffset=initOffset[2]
	E=coilStateAfterDischarge(loadMass,mAsb,fAsb,t->-capacitorDischarge(I0,t,tau),t->capacitorDischarge(I0,t,tau),[wireDia,0],tmax,xOffset,yOffset)
	folderName=string("../",runName)
	run(`mkdir -p $folderName`)
	outName=string("../",runName,"/",wireDia,",",loadMass,",",V,",",R,",",bankSize,",",initOffset',".csv")
	println(string("Writing ",outName))
	writecsv(outName,E)
	Energy=energyCalculator(loadMass, wireDia,E[2][end,:][1],E[2][end,:][2])
	return [bankEnergy,Energy,Energy/bankEnergy,wireDia,loadMass,V,R,bankSize,initOffset[1],initOffset[2],initOffset[3]]
end




