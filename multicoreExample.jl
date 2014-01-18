# examples from here:
# http://docs.julialang.org/en/latest/manual/parallel-computing/
# run the file by typing: julia -p 2 multicoreExample.jl
# this will set the number of processes = 2

# run function rand with arguments (2, 2) on process 2
r = remotecall(2, rand, 2, 2)
# retrieve the result from r
println(fetch(r))

# @spawnat is a simple macro to help calling processes easier
# this line runs rand(3, 3) on process 1
s = @spawnat 1 rand(3, 3)
println(fetch(s))

# we can do this too
s = @spawnat 1 1+fetch(r)
println(fetch(s))

# if we do not care which process is allocated, we can even do this
r = @spawn rand(2, 2)
println(fetch(r))
s = @spawn rand(2, 2)
println(fetch(s))

# now, not all processes are loaded with custom functions such as this one
function add(a, b)
	a + b
end

# suppose we want to run function add_lots_numbers defined in add_lots_numbers.jl
# we need to load it to all processes
require("add_lots_numbers")
a = @spawn add_lots_numbers(1000000)
b = @spawn add_lots_numbers(1000000)
println(fetch(a) + fetch(b))
# for your needs, something such as this might suffice

# we can do this too
nheads = @parallel (+) for i=1:200000000
  int(randbool())
end
println(nheads)


# tips:
# - limit data transfer; it's an overhead
# - if you need to distribute large amount of data over processes, consider distributed arrays
# - let me know if you have specific needs on this - i would look into it tmr