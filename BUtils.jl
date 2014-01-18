#BUtils.jl
#This is where the magnetic calculation models and utlities reside
export biotSavart,B,lorentzForce

#mu0=mu/(4pi), mu is the magnetic permitivity
mu0=(1/10^7)
#The biotSavart function is the function that implements the Integrand of the Biot-Savart Law from E&M. This law yields the magnetic field at a point r in 3D space given a point current of magnitude I.
#Parameters:
#coil: Coil type object (located in CSIM.jl)
#theta: Parameter of coil, IE where along the coil we should place the point current
#r: Field Point at which we are measuring the magnetic field generated, it is given as a vector
#A few things to note about this method
#1. This biotSavart law does not include the dTheta term in dl because that is supplied by quadgk in the B Calculator below, since it does not make any sense to compute the magnetic field due to a point current
#2. This integrand also does not include the magnetic permitivity, this is because the integrand does not need it.
function biotSavart(coil::Coil,theta::Number,r)
  dl=coil.df(theta)
  dr=r-coil.f(theta)
  ldr=sqrt(dr[1]^2+dr[2]^2+dr[3]^2)
  f=coil.I*cross(dl,dr)/ldr^3
  return f
end

#Calculates the magnetic field due a coil with constant current I flowing through it, at field point r
#Parameters:
#Coil, the geometry of the coil involved
#r, vector (list with 3 elements) representing the field point at which the magnetic field generated by current flowing through are coil is measured
#NOTE: This B lacks the scaling of mu, this means that it is B*10^7, this was done because this B is used later and that coeff can add a great deal of error to the calculation
function B(coil::Coil,r)
  BF=quadgk(theta -> biotSavart(coil,theta,r),coil.xMin,coil.xMax)
  return BF[1]
end

#Calculates the magnetic field due an assembly, but not including the magnetic field from the mobile coil since we wish to compute forces on the mobile coil
#Coil, the geometry of the coil involved
#r, vector (list with 3 elements) representing the field point at which the magnetic field generated by current flowing through are coil is measured
function B(asb::Assembly,r)
  netB=B(asb.coils[1],r)
  for tcoils=asb.coils[2:]
  	netB=netB+B(tcoils,r)
  end
  return netB
end

#Base implementation of the lorentz force law. In this case the B fields from the assembly acting on the mobile coil returns the force on the mobile coil
#Parameters:
#mCoil, coil that we want to calculate the force on given the magnetic field from the assembly
#asb, Assembly that we use to compute the magnetic field acting on the mCoil
#Note: The B used is missing the mu scaling so the force involved here is multiplied by 10^7
function lorentzForce(mCoil::Coil,asb::Assembly)
  return quadgk(theta->mCoil.I*cross(mCoil.df(theta),B(asb,mCoil.f(theta))),mCoil.xMin,mCoil.xMax)[1]
end

#Implementation of lorentz force law between a single mobile Coil and a list of various assemblies, used to calculate the effect of multiple assemblies on one coil which we want to move.
#Parameters:
#mCoil, coil that we want to calculate the force on, given the magnetic field from a list of assemblies asbs
#asbs, list of assemblies that we use to compute the magnetic field acting on the mCoil
#Note: The B used is missing the mu scaling so the force involved here is multiplied by 10^7
function lorentzForce(mCoil::Coil, asbs)
    netF=lorentzForce(mCoil,asbs[1])
    for tasb=asbs[2:]
      netF=netF+lorentzForce(mCoil,tasb)
    end
    return netF
end

#Implementation of the lorentz force law between an assembly designated the mobile assembly(mAsb) and a list of assemblies. This is because usually there is a fixed assembly and the assembly we want to calculate the force given.
#Parameters:
#mAsb, assembly that represents the assembly we want to calculate the force generated by the magnetic field generated by the other assemblies asbs
#asbs, list of assemblies that we use to compute the magnetic field acting on the mAsb
#Note: The B used is missing the mu scaling so the force involved her is multipled by 10^7
function lorentzForce(mAsb::Assembly, asbs)
  netF=lorentzForce(mAsb.coils[1],asbs)
  for tcoils=mAsb.coils[2:]
    netF=netF+lorentzForce(tcoils,asbs)
  end
  return netF
end

#Implementation of the lorentz force law between a set of assemblies designated as mobile(mAsbs) and a list of stationary assemblies(asbs). This was created because multiple coils may fire together to yield the force on a rigidly attached object. In this case all of the mAsbs assemblies are assumed to be rigidly attached and as such the magnetic field generate by the coils does not generate a force since this is cancelled out by the frame holding them together, thus we may lump them together and consider only the force generated by the other asbs
#Parameters:
#mAsbs, list of rigidly attached assemblies on which we want to find the net force
#asbs, list of assemblies that we use to compute the magnetic field acting on the mAsbs
#Note: The B used is missing the mu scaling so the force involved here is multiplied by 10^7
function lorentzForce(mAsbs,asbs)
  netF=lorentzForce(mAsbs[1],asbs)
  for mAsb=mAsbs[2:]
    netF=netF+lorentzForce(mAsb,asbs)
  end
  return netF
end