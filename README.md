[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://JohnPalmer.github.io/ActivitySpace.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://JohnPalmer.github.io/ActivitySpace.jl/dev)
[![Build Status](https://travis-ci.com/JohnPalmer/ActivitySpace.jl.svg?branch=master)](https://travis-ci.com/JohnPalmer/ActivitySpace.jl)
[![codecov](https://codecov.io/gh/JohnPalmer/ActivitySpace.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JohnPalmer/ActivitySpace.jl)

# ActivitySpace.jl
A Julia package for analyzing mobility, activity spaces, and segregation. This package is currently under development.

## Installation
```julia
(v1.1) pkg> add https://github.com/JohnPalmer/ActivitySpace.jl
```

## Usage

```julia
using ActivitySpace

D = dataset("utica_sim0")

utica_stp = stprox(D, 
	group_column=:race, 
	group_a="w", 
	group_b="b", 
	X_column=:X_UTM, 
	Y_column=:Y_UTM, 
	time_column=:time)

utica_stp_esd = empirical_sampling_distribution(D, 
	group_column=:race, 
	group_a="w", 
	group_b="b", 
	X_column=:X_UTM, 
	Y_column=:Y_UTM, 
	time_column=:time, 
	ID_column=:ID, 
	nreps=500, 
	sample_size=300)

utica_stp_bias = check_bias(D, 
	group_column=:race, 
	group_a="w", 
	group_b="b", 
	X_column=:X_UTM, 
	Y_column=:Y_UTM, 
	time_column=:time, 
	ID_column=:ID, 
	nreps=500, 
	sample_size=300)

```
## Performance

```julia
using ActivitySpace

julia> D = dataset("utica_sim0")
53971×7 DataFrames.DataFrame
│ Row   │ time  │ race   │ longitude │ latitute │ X_UTM     │ Y_UTM     │ ID    │
│       │ Int64 │ String │ Float64   │ Float64  │ Float64   │ Float64   │ Int64 │
├───────┼───────┼────────┼───────────┼──────────┼───────────┼───────────┼───────┤
│ 1     │ 0     │ w      │ -75.2303  │ 43.1221  │ 4.81265e5 │ 4.7744e6  │ 1     │
│ 2     │ 0     │ w      │ -75.2304  │ 43.1241  │ 481256.0  │ 4.77463e6 │ 2     │
│ 3     │ 0     │ w      │ -75.2234  │ 43.1194  │ 4.81826e5 │ 4.77409e6 │ 3     │
│ 4     │ 0     │ w      │ -75.2357  │ 43.1129  │ 4.80827e5 │ 4.77338e6 │ 4     │
│ 5     │ 0     │ w      │ -75.2243  │ 43.1308  │ 4.81754e5 │ 4.77537e6 │ 5     │
│ 6     │ 0     │ w      │ -75.214   │ 43.1164  │ 4.82588e5 │ 4.77376e6 │ 6     │
│ 7     │ 0     │ w      │ -75.2192  │ 43.1163  │ 4.82167e5 │ 4.77375e6 │ 7     │
│ 8     │ 0     │ w      │ -75.2276  │ 43.1253  │ 4.81484e5 │ 4.77475e6 │ 8     │
│ 9     │ 0     │ w      │ -75.2253  │ 43.1199  │ 4.81675e5 │ 4.77416e6 │ 9     │
│ 10    │ 0     │ w      │ -75.2163  │ 43.1166  │ 4.824e5   │ 4.77378e6 │ 10    │
│ 11    │ 0     │ w      │ -75.2178  │ 43.1127  │ 4.82276e5 │ 4.77336e6 │ 11    │
│ 12    │ 0     │ w      │ -75.2309  │ 43.1219  │ 481218.0  │ 4.77438e6 │ 12    │
⋮
│ 53959 │ 0     │ w      │ -75.2724  │ 43.0687  │ 4.77824e5 │ 4.76848e6 │ 53959 │
│ 53960 │ 0     │ w      │ -75.2768  │ 43.0722  │ 477463.0  │ 4.76887e6 │ 53960 │
│ 53961 │ 0     │ w      │ -75.2783  │ 43.073   │ 4.77345e5 │ 4.76896e6 │ 53961 │
│ 53962 │ 0     │ w      │ -75.2783  │ 43.073   │ 4.77345e5 │ 4.76896e6 │ 53962 │
│ 53963 │ 0     │ w      │ -75.2778  │ 43.0727  │ 4.77385e5 │ 4.76893e6 │ 53963 │
│ 53964 │ 0     │ w      │ -75.2743  │ 43.0708  │ 477671.0  │ 4.76872e6 │ 53964 │
│ 53965 │ 0     │ w      │ -75.2789  │ 43.0704  │ 4.77291e5 │ 4.76867e6 │ 53965 │
│ 53966 │ 0     │ w      │ -75.275   │ 43.0701  │ 4.77613e5 │ 4.76863e6 │ 53966 │
│ 53967 │ 0     │ w      │ -75.2816  │ 43.0739  │ 4.77074e5 │ 4.76906e6 │ 53967 │
│ 53968 │ 0     │ w      │ -75.2791  │ 43.0718  │ 477277.0  │ 4.76883e6 │ 53968 │
│ 53969 │ 0     │ b      │ -75.2753  │ 43.0696  │ 4.77587e5 │ 4.76858e6 │ 53969 │
│ 53970 │ 0     │ b      │ -75.2822  │ 43.0744  │ 4.77029e5 │ 4.76912e6 │ 53970 │
│ 53971 │ 0     │ b      │ -75.2789  │ 43.0704  │ 4.77291e5 │ 4.76867e6 │ 53971 │

julia> @time this_result = stprox(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)
 12.843548 seconds (421.58 k allocations: 27.865 MiB, 0.08% gc time)
Dict{String,Float64} with 6 entries:
  "STP" => 1.24563
  "Ptt" => 0.000784334
  "Pbb" => 0.00231697
  "b"   => 42.3313
  "a"   => 52.729
  "Paa" => 0.000758546
```

## About

Copyright 2019 John R.B. Palmer

ActivitySpace.jl is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

ActivitySpace.jl is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses.
