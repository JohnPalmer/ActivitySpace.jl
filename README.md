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

utica_stp = stprox(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)

utica_stp_esd = empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time, ID_column=:ID, nreps=500, sample_size=300)

utica_stp_bias = check_bias(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time, ID_column=:ID, nreps=500, sample_size=300)

```

## About

Copyright 2019 John R.B. Palmer

ActivitySpace.jl is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

ActivitySpace.jl is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses.