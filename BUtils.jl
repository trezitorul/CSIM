#BUtils.jl
#This is where the magnetic calculation models and utlities will reside
#

#This is the calculation of the biot-Savart law without the magnetic permitivity constant included
#The constant was not included since it is of the order 10^-7 and is a constant multiplicitive factor, which can
#Be added in at the very end for proper scaling. 
#Finally this biotSavart law does not include the dTheta term in dl because that is supplied by quadgk in the B 
#Calculator Below

export biotSavart,B,lorentzForce

#mu0=mu/(4pi), mu is the magnetic permitivity
mu0=(1/10^7)
#The biotSavart function is the function that implements the Integrand of the Biot-Savart Law from E&M. This law yields the magnetic field at a point r in 3D space given a point current of magnitude I.
#Parameters:
#coil: Coil type object (located in CSIM.jl)
#I: Current through coil 
#theta: Parameter of coil, IE where along the coil we should place the point current
#r: Field Point at which we are measuring the magnetic field generated, it is given as a vector
#A few things to note about this method
#1. This biotSavart law does not include the dTheta term in dl because that is supplied by quadgk in the B Calculator below, since it does not make any sense to compute the magnetic field due to a point current
#2. This integrand also does not include the magnetic permitivity, this is because the integrand does not need it.
function biotSavart(coil::Coil,theta::Number,I::Number,r)
  dl=coil.df(theta)
  dr=r-coil.f(theta)
  ldr=sqrt(dr[1]^2+dr[2]^2+dr[3]^2)
  f=I*cross(dl,dr)/ldr^3
  return f
end

#Calculates the magnetic field due a coil with constant current I flowing through it, at field point r
#Parameters:
#Coil, the geometry of the coil involved
#I, Number representing the magnitude of the current being passed through the coil
#r, vector (list with 3 elements) representing the field point at which the magnetic field generated by current flowing through are coil is measured
function B(I::Number,coil::Coil,r)
  BF=quadgk(theta -> biotSavart(coil,theta,I,r),coil.xMin,coil.xMax)
  return BF
end

#Implemented the lorentzForce law where each of the coils coil1 and coil2 are both energized with currents I1 and I2 respectively.
#Parameters:
#coil1,coil2: Coils which are correctly translated into position in 3D space
#I1,I2, the magnitude of the current going through both of our coils
function lorentzForce(I1::Number,I2::Number,coil1::Coil,coil2::Coil)
  return quadgk(theta->cross(I1*coil.df2(theta),B(coil1,f2(theta))[1]),coil2.xMin,coil2.xMax)
end