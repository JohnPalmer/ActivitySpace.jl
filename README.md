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

julia> D = city_sim_data("Buffalo")
Fetching Buffalo data from https://zenodo.org/record/2865830/files/buffalo_sim_full.csv.gz. Please wait...
4396047×7 DataFrames.DataFrame
│ Row     │ time    │ race   │ ID     │ longitude │ latitute │ X_UTM     │ Y_UTM     │
│         │ Float64 │ String │ Int64  │ Float64   │ Float64  │ Float64   │ Float64   │
├─────────┼─────────┼────────┼────────┼───────────┼──────────┼───────────┼───────────┤
│ 1       │ 0.0     │ w      │ 1      │ -78.9069  │ 42.958   │ 670725.0  │ 4.75827e6 │
│ 2       │ 0.5     │ w      │ 1      │ -78.9009  │ 42.962   │ 6.71205e5 │ 4.75873e6 │
│ 3       │ 1.0     │ w      │ 1      │ -78.893   │ 42.9613  │ 671846.0  │ 4.75867e6 │
│ 4       │ 1.5     │ w      │ 1      │ -78.8844  │ 42.9593  │ 6.72552e5 │ 4.75847e6 │
│ 5       │ 2.0     │ w      │ 1      │ -78.8736  │ 42.9577  │ 6.73445e5 │ 4.75832e6 │
│ 6       │ 2.5     │ w      │ 1      │ -78.8679  │ 42.9566  │ 6.73906e5 │ 4.7582e6  │
│ 7       │ 3.0     │ w      │ 1      │ -78.8561  │ 42.9579  │ 6.74869e5 │ 4.75837e6 │
│ 8       │ 3.5     │ w      │ 1      │ -78.8549  │ 42.9579  │ 6.74968e5 │ 4.75837e6 │
│ 9       │ 4.0     │ w      │ 1      │ -78.8642  │ 42.9571  │ 6.74211e5 │ 4.75826e6 │
│ 10      │ 4.5     │ w      │ 1      │ -78.8644  │ 42.957   │ 6.74192e5 │ 4.75825e6 │
│ 11      │ 5.0     │ w      │ 1      │ -78.8644  │ 42.9563  │ 6.74192e5 │ 4.75818e6 │
│ 12      │ 5.5     │ w      │ 1      │ -78.8663  │ 42.9579  │ 6.74034e5 │ 4.75835e6 │
⋮
│ 4396035 │ 2.0     │ b      │ 258591 │ -78.7969  │ 42.8262  │ 6.80079e5 │ 4.74387e6 │
│ 4396036 │ 2.5     │ b      │ 258591 │ -78.8     │ 42.8256  │ 6.79826e5 │ 4.7438e6  │
│ 4396037 │ 3.0     │ b      │ 258591 │ -78.7998  │ 42.8252  │ 679845.0  │ 4.74375e6 │
│ 4396038 │ 3.5     │ b      │ 258591 │ -78.8065  │ 42.8266  │ 6.79294e5 │ 4.74389e6 │
│ 4396039 │ 4.0     │ b      │ 258591 │ -78.81    │ 42.8258  │ 6.79012e5 │ 4.7438e6  │
│ 4396040 │ 4.5     │ b      │ 258591 │ -78.8073  │ 42.8329  │ 6.79208e5 │ 4.74459e6 │
│ 4396041 │ 5.0     │ b      │ 258591 │ -78.8135  │ 42.8283  │ 6.78717e5 │ 4.74406e6 │
│ 4396042 │ 5.5     │ b      │ 258591 │ -78.8126  │ 42.8221  │ 6.78812e5 │ 4.74338e6 │
│ 4396043 │ 6.0     │ b      │ 258591 │ -78.8099  │ 42.8239  │ 6.79021e5 │ 4.74358e6 │
│ 4396044 │ 6.5     │ b      │ 258591 │ -78.8198  │ 42.8273  │ 6.78205e5 │ 4.74394e6 │
│ 4396045 │ 7.0     │ b      │ 258591 │ -78.8126  │ 42.8272  │ 6.78792e5 │ 4.74395e6 │
│ 4396046 │ 7.5     │ b      │ 258591 │ -78.8166  │ 42.8294  │ 6.78464e5 │ 4.74418e6 │
│ 4396047 │ 8.0     │ b      │ 258591 │ -78.8238  │ 42.8329  │ 6.7786e5  │ 4.74456e6 │

julia> B_home = D[ D.time.==0, :]
258591×7 DataFrames.DataFrame
│ Row    │ time    │ race   │ ID     │ longitude │ latitute │ X_UTM     │ Y_UTM     │
│        │ Float64 │ String │ Int64  │ Float64   │ Float64  │ Float64   │ Float64   │
├────────┼─────────┼────────┼────────┼───────────┼──────────┼───────────┼───────────┤
│ 1      │ 0.0     │ w      │ 1      │ -78.9069  │ 42.958   │ 670725.0  │ 4.75827e6 │
│ 2      │ 0.0     │ w      │ 2      │ -78.9033  │ 42.9503  │ 6.71041e5 │ 4.75742e6 │
│ 3      │ 0.0     │ w      │ 3      │ -78.9075  │ 42.9452  │ 6.70707e5 │ 4.75685e6 │
│ 4      │ 0.0     │ w      │ 4      │ -78.8961  │ 42.958   │ 6.71607e5 │ 4.7583e6  │
│ 5      │ 0.0     │ w      │ 5      │ -78.9095  │ 42.9521  │ 6.7053e5  │ 4.75762e6 │
│ 6      │ 0.0     │ w      │ 6      │ -78.9094  │ 42.9532  │ 6.70532e5 │ 4.75773e6 │
│ 7      │ 0.0     │ w      │ 7      │ -78.8935  │ 42.9621  │ 6.71804e5 │ 4.75876e6 │
│ 8      │ 0.0     │ w      │ 8      │ -78.9095  │ 42.9521  │ 6.7053e5  │ 4.75762e6 │
│ 9      │ 0.0     │ w      │ 9      │ -78.8988  │ 42.9551  │ 6.71396e5 │ 4.75797e6 │
│ 10     │ 0.0     │ w      │ 10     │ -78.9078  │ 42.9575  │ 6.70649e5 │ 4.75822e6 │
│ 11     │ 0.0     │ w      │ 11     │ -78.9002  │ 42.9602  │ 6.71265e5 │ 4.75853e6 │
│ 12     │ 0.0     │ w      │ 12     │ -78.9075  │ 42.9452  │ 6.70707e5 │ 4.75685e6 │
⋮
│ 258579 │ 0.0     │ b      │ 258579 │ -78.8067  │ 42.8422  │ 6.7923e5  │ 4.74562e6 │
│ 258580 │ 0.0     │ b      │ 258580 │ -78.8124  │ 42.8381  │ 6.78778e5 │ 4.74516e6 │
│ 258581 │ 0.0     │ b      │ 258581 │ -78.8123  │ 42.8423  │ 6.78773e5 │ 4.74563e6 │
│ 258582 │ 0.0     │ b      │ 258582 │ -78.807   │ 42.8366  │ 6.79221e5 │ 4.745e6   │
│ 258583 │ 0.0     │ b      │ 258583 │ -78.805   │ 42.8399  │ 6.79378e5 │ 4.74538e6 │
│ 258584 │ 0.0     │ b      │ 258584 │ -78.8075  │ 42.8382  │ 6.79175e5 │ 4.74518e6 │
│ 258585 │ 0.0     │ b      │ 258585 │ -78.807   │ 42.8366  │ 6.79221e5 │ 4.745e6   │
│ 258586 │ 0.0     │ b      │ 258586 │ -78.8084  │ 42.8409  │ 6.79095e5 │ 4.74548e6 │
│ 258587 │ 0.0     │ b      │ 258587 │ -78.801   │ 42.8328  │ 6.79722e5 │ 4.74459e6 │
│ 258588 │ 0.0     │ b      │ 258588 │ -78.8124  │ 42.8381  │ 6.78778e5 │ 4.74516e6 │
│ 258589 │ 0.0     │ b      │ 258589 │ -78.8124  │ 42.84    │ 6.78776e5 │ 4.74537e6 │
│ 258590 │ 0.0     │ b      │ 258590 │ -78.8084  │ 42.8409  │ 6.79095e5 │ 4.74548e6 │
│ 258591 │ 0.0     │ b      │ 258591 │ -78.8064  │ 42.8346  │ 6.79278e5 │ 4.74478e6 │

julia> @time stp = stprox(B_home, group_column=:race, group_a = "w", group_b = "b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)
349.284447 seconds (419 allocations: 35.740 MiB)
Dict{String,Float64} with 6 entries:
  "STP" => 1.53455
  "Ptt" => 0.000283177
  "Pbb" => 0.000478212
  "b"   => 73.227
  "a"   => 112.371
  "Paa" => 0.000403679

```

## About

Copyright 2019 John R.B. Palmer

ActivitySpace.jl is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

ActivitySpace.jl is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses.
