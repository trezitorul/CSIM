#TimeUtils.jl
#This is where the time based time simulations are. IE calculating how far a coil jumps vertically given a certain discharge pattern.
using ODE
using ImmutableArrays
export capacitorDischarge,coilStateAfterDischarge,energyCalculator
#Capacitor Discharge Curve
function capacitorDischarge(I0,t,tau)
	return I0*exp(-t/tau)
end
#Returns the 
function coilForce(mAsb,fAsb,t,mDischargeProfile,fDischargeProfile, mOffset)
	println(t)
	current!(mAsb,mDischargeProfile(t))
	current!(fAsb,fDischargeProfile(t))
	translate!(mAsb,mOffset)
	F=lorentzForce(mAsb,fAsb)[3]
	return F/10^7
end

#Calculates the final state of an assembly after a current discharge
#Parameters:
#loadMass: Load and the weight of the coils in an assembly
#mAsb: Assembly that is permitted to move
#fAsb: Assembly that is fixed
#mDischargeProfile: The time dependent discharge profile of our current source in the mAsb
#fDischargeProfile: The time dependent discharge profile of our current source in the fAsb
function coilStateAfterDischarge(loadMass,mAsb,fAsb,mDischargeProfile,fDischargeProfile,initCond, tMax)
	println("Calculating Coil State")
	F(t,z)=magForce(t,z,loadMass,mAsb,fAsb,mDischargeProfile,fDischargeProfile)
	t_out,y_out=ode45(F,[0,tMax],initCond)
	return t_out,y_out
end

function magForce(t::Float64,z,loadMass,mAsb,fAsb,mDischargeProfile,fDischargeProfile)
	return [z[2],(coilForce(mAsb,fAsb,t,mDischargeProfile,fDischargeProfile,Vector3(0.0,0.0,z[1]))/loadMass) - 9.831]
end

function energyCalculator(loadMass, startHeight,endHeight,finalSpeed)
	return .5*loadMass*finalSpeed^2+loadMass*9.831*(endHeight-startHeight)
end