#BUtils.jl
#This is where the magnetic calculation models and utlities will reside
#

#This is the calculation of the biot-Savart law without the magnetic permitivity constant included
#The constant was not included since it is of the order 10^-7 and is a constant multiplicitive factor, which can
#Be added in at the very end for proper scaling. 
#Finally this biotSavart law does not include the dTheta term in dl because that is supplied by quadgk in the B 
#Calculator Below

export biotSavart,B,lorentzForce

mu=(1/10^7)
#The biotSavart function is the function that implements the Biot-Savart Law from E&M. This law yields the magnetic field at a point r in 3D space given a point current of magnitude I.
#Parameters, coil
function biotSavart(coil::Coil,theta::Number,I::Number,r::Array{Number,1})
  dl=coil.df(theta)
  dr=r-coil.f(theta)
  ldr=sqrt(dr[1]^2+dr[2]^2+dr[3]^2)
  f=I*cross(dl,dr)/ldr^3
  return f
end

#Calculates the magnetic field due to the wire given by function f.
function B(I,coil::Coil,r)
  BF=quadgk(theta -> biotSavart(coil,theta,I,r),coil.xMin,coil.xMax)
  return BF
end

#This calculates the force between two wires each arranged as f1 and f2, with df1 and df2 respectively.
#Once again I have dropped the mu in the front since all it contributes is a 10^-7 multiplicitive factor
#Both f1 and f2 are 
function lorentzForce(I1,I2,coil1::Coil,coil2::Coil)
  return quadgk(theta->cross(I1*coil.df2(theta),B(coil1,f2(theta))[1]),coil2.xMin,coil2.xMax)
end