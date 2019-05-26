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
julia> using ActivitySpace

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

julia> D = city_sim_data("Utica")
Fetching Utica data from https://zenodo.org/record/2865830/files/utica_sim_full.csv.gz. Please wait...
917507×7 DataFrames.DataFrame
│ Row    │ time    │ race   │ ID    │ longitude │ latitute │ X_UTM     │ Y_UTM     │
│        │ Float64 │ String │ Int64 │ Float64   │ Float64  │ Float64   │ Float64   │
├────────┼─────────┼────────┼───────┼───────────┼──────────┼───────────┼───────────┤
│ 1      │ 0.0     │ w      │ 1     │ -75.2303  │ 43.1221  │ 4.81265e5 │ 4.7744e6  │
│ 2      │ 0.5     │ w      │ 1     │ -75.2318  │ 43.1226  │ 481146.0  │ 4.77446e6 │
│ 3      │ 1.0     │ w      │ 1     │ -75.2285  │ 43.1212  │ 4.81414e5 │ 4.7743e6  │
│ 4      │ 1.5     │ w      │ 1     │ -75.2155  │ 43.1164  │ 4.82465e5 │ 4.77376e6 │
│ 5      │ 2.0     │ w      │ 1     │ -75.2291  │ 43.1215  │ 4.81359e5 │ 4.77433e6 │
│ 6      │ 2.5     │ w      │ 1     │ -75.2307  │ 43.1202  │ 4.81236e5 │ 4.77419e6 │
│ 7      │ 3.0     │ w      │ 1     │ -75.2358  │ 43.1132  │ 4.80816e5 │ 4.77341e6 │
│ 8      │ 3.5     │ w      │ 1     │ -75.234   │ 43.1167  │ 4.80963e5 │ 4.7738e6  │
│ 9      │ 4.0     │ w      │ 1     │ -75.2343  │ 43.1156  │ 4.80941e5 │ 4.77368e6 │
│ 10     │ 4.5     │ w      │ 1     │ -75.2344  │ 43.1154  │ 4.80934e5 │ 4.77366e6 │
│ 11     │ 5.0     │ w      │ 1     │ -75.2369  │ 43.1105  │ 4.80725e5 │ 4.77312e6 │
│ 12     │ 5.5     │ w      │ 1     │ -75.2337  │ 43.1044  │ 4.80985e5 │ 4.77244e6 │
⋮
│ 917495 │ 2.0     │ b      │ 53971 │ -75.2794  │ 43.0728  │ 477250.0  │ 4.76894e6 │
│ 917496 │ 2.5     │ b      │ 53971 │ -75.2813  │ 43.0708  │ 4.77101e5 │ 4.76872e6 │
│ 917497 │ 3.0     │ b      │ 53971 │ -75.2745  │ 43.0706  │ 4.77655e5 │ 4.76869e6 │
│ 917498 │ 3.5     │ b      │ 53971 │ -75.2724  │ 43.0668  │ 4.77822e5 │ 4.76827e6 │
│ 917499 │ 4.0     │ b      │ 53971 │ -75.2762  │ 43.073   │ 4.77517e5 │ 4.76896e6 │
│ 917500 │ 4.5     │ b      │ 53971 │ -75.2746  │ 43.0722  │ 4.77646e5 │ 4.76887e6 │
│ 917501 │ 5.0     │ b      │ 53971 │ -75.2716  │ 43.0764  │ 4.77887e5 │ 4.76933e6 │
│ 917502 │ 5.5     │ b      │ 53971 │ -75.2691  │ 43.078   │ 4.78097e5 │ 4.76951e6 │
│ 917503 │ 6.0     │ b      │ 53971 │ -75.2711  │ 43.0803  │ 4.77934e5 │ 4.76976e6 │
│ 917504 │ 6.5     │ b      │ 53971 │ -75.2738  │ 43.0839  │ 4.77716e5 │ 4.77016e6 │
│ 917505 │ 7.0     │ b      │ 53971 │ -75.2635  │ 43.0838  │ 4.78554e5 │ 4.77015e6 │
│ 917506 │ 7.5     │ b      │ 53971 │ -75.2631  │ 43.0836  │ 4.78581e5 │ 4.77014e6 │
│ 917507 │ 8.0     │ b      │ 53971 │ -75.2612  │ 43.0793  │ 4.7874e5  │ 4.76965e6 │


julia> @time this_result = stprox(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)
225.767357 seconds (2.74 k allocations: 84.322 MiB, 0.17% gc time)
Dict{String,Float64} with 6 entries:
  "STP" => 1.22425
  "Ptt" => 5.17421e-5
  "Pbb" => 0.00014441
  "b"   => 2.79257
  "a"   => 3.41882
  "Paa" => 5.01304e-5

```

## About

Copyright 2019 John R.B. Palmer

ActivitySpace.jl is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

ActivitySpace.jl is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses.
