module ActivitySpace

using DataFrames, Statistics, Random, TableReader, ProgressMeter

export negative_exponential
"""
	negative_exponential(x::Float64)::Float64

Returns ``e^{-x}``.
"""
function negative_exponential(x::Float64)::Float64
    exp(-x)
end

"""
	distance_sum(A::Array{Float64, 2},
	    f::Function=negative_exponential)::Float64

Internal function for summing distances between all points represented in a matrix with 2 columns containing the X and Y coordinates. The distances are transformed by whatever function is supplied in the call.
"""
function distance_sum(A::Array{Float64, 2}, f::Function=negative_exponential)::Float64
    this_distance_sum = Float64(0)
    nrowA::Int64 = size(A, 1)
    for i in 1:(nrowA-1), j in (i+1):nrowA
        this_distance_sum += f(sqrt((A[i, 1]-A[j, 1])^2 + (A[i, 2]-A[j, 2])^2))
    end
    return this_distance_sum
end

function distance_sum_kahan(A::Array{Float64, 2}, f::Function=negative_exponential)::Float64
    this_distance_sum = Float64(0)
	c = Float64(0)
    nrowA::Int64 = size(A, 1)
    for i in 1:(nrowA-1), j in (i+1):nrowA
        this_distance = f(sqrt((A[i, 1]-A[j, 1])^2 + (A[i, 2]-A[j, 2])^2))
		y = this_distance - c
		t = this_distance_sum + y
		c = (t - this_distance_sum) - y
		this_distance_sum = t
    end
    return this_distance_sum
end

function distance_sum_kbn(A::Array{Float64, 2}, f::Function=negative_exponential)::Float64
	s = Float64(0)
	c = Float64(0)
	nrowA::Int64 = size(A, 1)
	@showprogress 1 "Computing distance_sum_kbn A..." for i in 1:(nrowA-1), j in (i+1):nrowA
		this_distance = f(sqrt((A[i, 1]-A[j, 1])^2 + (A[i, 2]-A[j, 2])^2))
    	t = s + this_distance
        if ( abs(s) >= abs(this_distance) )
			c += ( (s-t) + this_distance )
        else
			c += ( (this_distance-t) + s )
		end
		s = t
	end
    return s + c
end

export distance_mean_kbn

function distance_mean_kbn(A::Array{Float64, 2}, f::Function=negative_exponential)::Float64
	return distance_sum_kbn(A, f)/((size(A, 1)^2 - size(A, 1))/2)
end

export distance_moments

# from Terriberry & Chan at https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
function distance_moments(D::DataFrame, X_column::Symbol, Y_column::Symbol, f::Function=negative_exponential)::Dict
	A = convert(Matrix, D[:, [X_column, Y_column] ])
	mean = Float64(0)
	M2 = Float64(0)
	M3 = Float64(0)
	M4 = Float64(0)
	n = Int64(0)
	nrowA::Int64 = size(A, 1)
	@showprogress 1 "Computing distance_moments..." for i in 1:(nrowA-1), j in (i+1):nrowA
		n1 = n
		n += 1
		x = f(sqrt((A[i, 1]-A[j, 1])^2 + (A[i, 2]-A[j, 2])^2))
		delta = x - mean
		delta_n = delta / n
		delta_n2 = delta_n * delta_n
		term1 = delta * delta_n * n1
		mean = mean + delta_n
		M4 = M4 + term1 * delta_n2 * (n*n - 3*n + 3) + 6 * delta_n2 * M2 - 4 * delta_n * M3
		M3 = M3 + term1 * delta_n * (n - 2) - 3 * delta_n * M2
		M2 = M2 + term1
	end
	return Dict("mean" => mean, "variance" => M2/n, "skewness" => (sqrt(n)*M3)/(M2^(3/2)), "kurtosis" => ((n*M4)/(M2^2) - 3))
end

export moments

# from Terriberry & Chan at https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
function moments(A::Array)::Dict
	mean = Float64(0)
	M2 = Float64(0)
	M3 = Float64(0)
	M4 = Float64(0)
	N = length(A)
	@showprogress 1 "Computing moments..." for n in 1:N
		x = A[n]
		delta = x - mean
		delta_n = delta / n
		delta_n2 = delta_n * delta_n
		term1 = delta * delta_n * (n-1)
		mean = mean + delta_n
		M4 = M4 + term1 * delta_n2 * (n*n - 3*n + 3) + 6 * delta_n2 * M2 - 4 * delta_n * M3
		M3 = M3 + term1 * delta_n * (n - 2) - 3 * delta_n * M2
		M2 = M2 + term1
	end
	return Dict("mean" => mean, "variance" => M2/N, "skewness" => (sqrt(N)*M3)/(M2^(3/2)), "kurtosis" => ((N*M4)/(M2^2) - 3))
end


"""
	distance_sum(A::Array{Float64, 2},
	    B::Array{Float64, 2},
	    f::Function=negative_exponential)::Float64

Internal function for summing distances between two sets of points, each represented in a matrix with 2 columns (X and Y coordinates). The distances are transformed by whatever function is supplied in the call.
"""
function distance_sum(A::Array{Float64, 2}, B::Array{Float64, 2}, f::Function=negative_exponential)::Float64
    this_distance_sum = Float64(0)
    nrowA::Int64 = size(A, 1)
    nrowB::Int64 = size(B, 1)
    @showprogress 1 "Computing distance_sum A B..." for i in 1:nrowA, j in 1:nrowB
        this_distance_sum += f(sqrt((A[i, 1]-B[j, 1])^2 + (A[i, 2]-B[j, 2])^2))
    end
    return this_distance_sum
end

function distance_sum_kahan(A::Array{Float64, 2}, B::Array{Float64, 2}, f::Function=negative_exponential)::Float64
    this_distance_sum = Float64(0)
	c = Float64(0)
    nrowA::Int64 = size(A, 1)
    nrowB::Int64 = size(B, 1)
    @showprogress 1 "Computing distance_sum_kahan A B..." for i in 1:nrowA, j in 1:nrowB
        this_distance = f(sqrt((A[i, 1]-B[j, 1])^2 + (A[i, 2]-B[j, 2])^2))
		y = this_distance - c
		t = this_distance_sum + y
		c = (t - this_distance_sum) - y
		this_distance_sum = t
    end
    return this_distance_sum
end

function distance_sum_kbn(A::Array{Float64, 2}, B::Array{Float64, 2}, f::Function=negative_exponential)::Float64
	s = Float64(0)
	c = Float64(0)
	nrowA::Int64 = size(A, 1)
	nrowB::Int64 = size(B, 1)
	@showprogress 1 "Computing distance_sum_kbn A B..." for i in 1:nrowA, j in 1:nrowB
        this_distance = f(sqrt((A[i, 1]-B[j, 1])^2 + (A[i, 2]-B[j, 2])^2))
    	t = s + this_distance
        if ( abs(s) >= abs(this_distance) )
			c += ( (s-t) + this_distance )
        else
			c += ( (this_distance-t) + s )
		end
		s = t
	end
    return s + c
end




"""
	distance_sum3d(A::Array{Float64, 2}, f::Function=negative_exponential)::Float64

Internal function for summing distances between all points represented in a matrix with 3 columns containing the X and Y coordinates, and time. The distances are transformed by whatever function is supplied in the call.
"""
function distance_sum3d(A::Array{Float64, 2}, f::Function=negative_exponential)::Float64
    this_distance_sum = Float64(0)
    nrowA::Int64 = size(A, 1)
    @showprogress 1 "Computing distance_sum3d A..." for i in 1:(nrowA-1), j in (i+1):nrowA
        this_distance_sum += f(sqrt((A[i, 1]-A[j, 1])^2 + (A[i, 2]-A[j, 2])^2 + (A[i, 3]-A[j, 3])^2))
    end
    return this_distance_sum
end

function distance_sum3d_kbn(A::Array{Float64, 2}, f::Function=negative_exponential)::Float64
	s = Float64(0)
	c = Float64(0)
    nrowA::Int64 = size(A, 1)
    @showprogress 1 "Computing distance_sum3d_kbn A..." for i in 1:(nrowA-1), j in (i+1):nrowA
        this_distance = f(sqrt((A[i, 1]-A[j, 1])^2 + (A[i, 2]-A[j, 2])^2 + (A[i, 3]-A[j, 3])^2))
		t = s + this_distance
        if ( abs(s) >= abs(this_distance) )
			c += ( (s-t) + this_distance )
        else
			c += ( (this_distance-t) + s )
		end
		s = t
	end
    return s + c
end


"""
	distance_sum3d(A::Array{Float64, 2}, B::Array{Float64, 2}, f::Function=negative_exponential)::Float64

Internal function for summing distances between two sets of points, each represented in a matrix with 3 columns (X and Y coordinates and time). The distances are transformed by whatever function is supplied in the call.
"""
function distance_sum3d(A::Array{Float64, 2}, B::Array{Float64, 2}, f::Function=negative_exponential)::Float64
    this_distance_sum = Float64(0)
    nrowA::Int64 = size(A, 1)
    nrowB::Int64 = size(B, 1)
    @showprogress 1 "Computing distance_sum3d A B..." for i in 1:nrowA, j in 1:nrowB
        this_distance_sum += f(sqrt((A[i, 1]-B[j, 1])^2 + (A[i, 2]-B[j, 2])^2 + (A[i, 3]-B[j, 3])^2))
    end
    return this_distance_sum
end

function distance_sum3d_kbn(A::Array{Float64, 2}, B::Array{Float64, 2}, f::Function=negative_exponential)::Float64
	s = Float64(0)
	c = Float64(0)
    nrowA::Int64 = size(A, 1)
    nrowB::Int64 = size(B, 1)
    @showprogress 1 "Computing distance_sum3d_kbn A B..." for i in 1:nrowA, j in 1:nrowB
        this_distance = f(sqrt((A[i, 1]-B[j, 1])^2 + (A[i, 2]-B[j, 2])^2 + (A[i, 3]-B[j, 3])^2))
		t = s + this_distance
        if ( abs(s) >= abs(this_distance) )
			c += ( (s-t) + this_distance )
        else
			c += ( (this_distance-t) + s )
		end
		s = t
	end
    return s + c
end


export stprox
"""
	stprox(D::DataFrame;
	    group_column::Symbol,
	    group_a, group_b,
	    X_column::Symbol,
	    Y_column::Symbol,
	    time_column::Symbol,
	    N_a::Union{Int, Nothing}=nothing,
	    N_b::Union{Int, Nothing}=nothing,
	    f::Function=negative_exponential,
	    time_approach=1)

Returns the Spatio-Temporal Proximity Index
"""
function stprox(D::DataFrame; group_column::Symbol, group_a, group_b, X_column::Symbol, Y_column::Symbol, time_column::Symbol, N_a::Union{Int, Nothing}=nothing, N_b::Union{Int, Nothing}=nothing, f::Function=negative_exponential, time_approach=1, summation="kbn")
	@assert group_column ∈ names(D)
	@assert X_column ∈ names(D)
	@assert Y_column ∈ names(D)
	@assert size(D[ D[group_column] .== group_a, :],1) > 0
	@assert size(D[ D[group_column] .== group_b, :],1) > 0

	times = unique(D[time_column])
	if N_a == nothing
		N_a = size(D[ (D[group_column].==group_a) .& (D[time_column] .== times[1]), : ], 1)
	end
	if N_b == nothing
		N_b = size(D[ (D[group_column].==group_b) .& (D[time_column] .== times[1]), : ], 1)
	end
	N_t = N_a + N_b
	Paa = Float64(0)
	Pbb = Float64(0)
	Ptt = Float64(0)
	if time_approach == 1
	    for t in times
	    	A = convert(Matrix, D[ (D[group_column].==group_a) .& (D[time_column] .== t), [X_column, Y_column] ])
	    	B = convert(Matrix, D[ (D[group_column].==group_b) .& (D[time_column] .== t), [X_column, Y_column]])
		    n_a = (size(A, 1)^2 - size(A, 1))/2
		    n_b = (size(B, 1)^2 - size(B, 1))/2
		    n_t = size(A, 1)*size(B, 1) + n_a + n_b
			if summation == "naive"
			    Saa = distance_sum(A, f)
			    Sbb = distance_sum(B, f)
			    Stt = distance_sum(A, B, f) + Saa + Sbb
			elseif summation == "kahan"
				Saa = distance_sum_kahan(A, f)
			    Sbb = distance_sum_kahan(B, f)
			    Stt = distance_sum_kahan(A, B, f) + Saa + Sbb
			elseif summation == "kbn"
				Saa = distance_sum_kbn(A, f)
			    Sbb = distance_sum_kbn(B, f)
			    Stt = distance_sum_kbn(A, B, f) + Saa + Sbb
			end
		    Paa += Saa/n_a
		    Pbb += Sbb/n_b
		    Ptt += Stt/n_t
		end
		Paa /= length(times)
		Pbb /= length(times)
		Ptt /= length(times)
	elseif time_approach == 2
	    A = convert(Matrix, D[ (D[group_column].==group_a), [X_column, Y_column, time_column] ])
	    B = convert(Matrix, D[ (D[group_column].==group_b), [X_column, Y_column, time_column]])
		n_a = (size(A, 1)^2 - size(A, 1))/2
		n_b = (size(B, 1)^2 - size(B, 1))/2
		n_t = size(A, 1)*size(B, 1) + n_a + n_b
		if summation == "naive"
			Saa = distance_sum3d(A, f)
			Sbb = distance_sum3d(B, f)
			Stt = distance_sum3d(A, B, f) + Saa + Sbb
		elseif summation == "kahan"
			Saa = distance_sum3d_kahan(A, f)
			Sbb = distance_sum3d_kahan(B, f)
			Stt = distance_sum3d_kahan(A, B, f) + Saa + Sbb
		elseif summation == "kbn"
			Saa = distance_sum3d_kbn(A, f)
			Sbb = distance_sum3d_kbn(B, f)
			Stt = distance_sum3d_kbn(A, B, f) + Saa + Sbb
		end
		Paa += Saa/n_a
		Pbb += Sbb/n_b
		Ptt += Stt/n_t
	end
    a = N_a * Paa + N_b * Pbb
    b = N_t * Ptt
    STP = a/b
    return Dict("STP" => STP, "Paa" => Paa, "Pbb" => Pbb, "Ptt" => Ptt, "a" => a, "b" => b)
end

export empirical_sampling_distribution
"""
	empirical_sampling_distribution(D::DataFrame;
	    group_column::Symbol,
	    group_a,
	    group_b,
	    X_column::Symbol,
	    Y_column::Symbol,
	    time_column::Symbol=:time,
	    ID_column::Symbol=:ID,
	    nreps::Int=500,
	    sample_size::Int=100,
	    f::Function=negative_exponential)::DataFrame

Returns a DataFrame containing the empirical sampling distribution for the Spatio-Temporal Proximity Index and its components.
"""
function empirical_sampling_distribution(D::DataFrame; group_column::Symbol, group_a, group_b, X_column::Symbol, Y_column::Symbol, time_column::Symbol=:time, ID_column::Symbol=:ID, nreps::Int=500, sample_size::Int=100, f::Function=negative_exponential, time_approach=1, sampling_type="simple", strata=nothing)::DataFrame
	@assert nreps > 0
	@assert sample_size > 0
	@assert group_column ∈ names(D)
	@assert X_column ∈ names(D)
	@assert Y_column ∈ names(D)
	@assert time_column ∈ names(D)
	@assert size(D[ D[group_column] .== group_a, :],1) > 0
	@assert size(D[ D[group_column] .== group_b, :],1) > 0
    STP_esd::Array{Float64} = []
    Paa_esd::Array{Float64} = []
    Pbb_esd::Array{Float64} = []
    Ptt_esd::Array{Float64} = []
    a_esd::Array{Float64} = []
    b_esd::Array{Float64} = []
 	times = unique(D[time_column])
	IDs = unique(D[ID_column])
	@assert sample_size <= length(IDs)
	N_a::Int64 = size(D[ (D[group_column].==group_a) .& (D[time_column] .== times[1]), :], 1)
	N_b::Int64 = size(D[ (D[group_column].==group_b) .& (D[time_column] .== times[1]), :], 1)
	for i in 1:nreps
		if sampling_type == "simple"
			these_IDs = rand(IDs, sample_size)
		elseif sampling_type == "stratefied"
			these_IDs = zeros(Int64, 0)
			for this_stratum in unique(D[ID_column])
			    this_stratum_IDs = D[D[ID_column].==this_stratum, :ID]
			    append!(these_IDs, rand(this_stratum_IDs, sample_size))
			end
		end
		Dsamp = D[ indexin(D[ID_column], these_IDs) .!= nothing, :]
        this_result = stprox(Dsamp, group_column=group_column, group_a=group_a, group_b=group_b, X_column=X_column, Y_column = Y_column, time_column=time_column, N_a=N_a, N_b=N_b, f=f, time_approach=time_approach)
        push!(STP_esd, this_result["STP"])
        push!(Paa_esd, this_result["Paa"])
        push!(Pbb_esd, this_result["Pbb"])
        push!(Ptt_esd, this_result["Ptt"])
        push!(a_esd, this_result["a"])
        push!(b_esd, this_result["b"])
    end
    return DataFrame(STP = STP_esd, Paa = Paa_esd, Pbb = Pbb_esd, Ptt = Ptt_esd, a = a_esd, b = b_esd, N_a = N_a, N_b = N_b)
end

export randomize_column
"""
	randomize_column(D::DataFrame;
	    column_name::Symbol,
	    n::Int)

Returns a DataFrame in which n elements of the indicated column have been shuffled.
"""
function randomize_column(D::DataFrame; column_name::Symbol, n::Int)
	@assert column_name ∈ names(D)
    D_shuffled = D[randperm(size(D,1)),:]
    column_shuffled = vcat(shuffle(D_shuffled[1:n, column_name]),  D_shuffled[(n+1):size(D_shuffled,1), column_name])
    D_shuffled[column_name] = column_shuffled
    return D_shuffled
end

export check_bias
"""
	check_bias(D;
	    group_column::Symbol,
	    group_a,
	    group_b,
	    X_column::Symbol,
	    Y_column::Symbol,
	    time_column::Symbol,
	    ID_column::Symbol=:ID,
	    nreps::Int=500,
	    sample_size::Int=100,
	    pop_STP::Union{Number, Nothing}=nothing,
	    f::Function=negative_exponential)

Convenience function that calculates the difference between the mean of the empirical sampling distribution and the population STP value. Returns this difference (the estimator bias), along with the STP value, the full empirical sampling distribution, and information about the data. If the STP value is supplied in the function call, then it will not be calculated (thus saving processing time).

## Parameters

* `group_column`
* `group_a`

## Examples

"""
function check_bias(D; group_column::Symbol, group_a, group_b, X_column::Symbol, Y_column::Symbol, time_column::Symbol, ID_column::Symbol=:ID, nreps::Int=500, sample_size::Int=100, pop_STP::Union{Number, Nothing}=nothing, f::Function=negative_exponential, time_approach=1, full_output::Bool=false, calculate_moments::Bool=true)
	@assert group_column ∈ names(D)
	@assert X_column ∈ names(D)
	@assert Y_column ∈ names(D)
	@assert size(D[ D[group_column] .== group_a, :],1) > 0
	@assert size(D[ D[group_column] .== group_b, :],1) > 0
	if pop_STP == nothing
		pop_STP = stprox(D, group_column=group_column, group_a=group_a, group_b=group_b, X_column=X_column, Y_column=Y_column, time_column=time_column, f=f, time_approach=time_approach)["STP"]
	end
	esd = empirical_sampling_distribution(D, group_column=group_column, group_a=group_a, group_b=group_b, X_column=X_column, Y_column=Y_column, time_column=time_column, ID_column=ID_column, f=f, time_approach=time_approach, nreps=nreps, sample_size=sample_size)
	this_bias = mean(esd.STP)-pop_STP
	N_a = esd.N_a[1]
	N_b=esd.N_b[1]
	min_prop = min(N_a, N_b)/(N_a+N_b)
	if full_output
		if calculate_moments
			these_moments = distance_moments(D, X_column, Y_column, f)
			return Dict("bias" => this_bias, "pop_STP" => pop_STP, "esd" => esd, "mean" => these_moments["mean"], "variance" => these_moments["variance"], "skewness" => these_moments["skewness"], "kurtosis" => these_moments["kurtosis"], "sample_size" => sample_size, "nreps" => nreps, "group_column" => string(group_column), "group_a" => group_a, "group_b" => group_b, "ID_column" => string(ID_column), "time_column" => string(time_column), "f" => string(f))
		else
	    	return Dict("bias" => this_bias, "pop_STP" => pop_STP, "esd" => esd, "sample_size" => sample_size, "nreps" => nreps, "group_column" => string(group_column), "group_a" => group_a, "group_b" => group_b, "ID_column" => string(ID_column), "time_column" => string(time_column), "f" => string(f))
		end
	else
		if calculate_moments
			these_moments = distance_moments(D, X_column, Y_column, f)
			return DataFrame(bias = this_bias, pop_STP = pop_STP, sample_size = sample_size, nreps = nreps, group_column = string(group_column), group_a = group_a, group_b = group_b, ID_column = string(ID_column), time_column = string(time_column), f = string(f), N_a = N_a, N_b=N_b, min_prop = min_prop, mean = these_moments["mean"], variance = these_moments["variance"], skewness = these_moments["skewness"], kurtosis = these_moments["kurtosis"])
		else
	    	return DataFrame(bias = this_bias, pop_STP = pop_STP, sample_size = sample_size, nreps = nreps, group_column = string(group_column), group_a = group_a, group_b = group_b, ID_column = string(ID_column), time_column = string(time_column), f = string(f), N_a = N_a, N_b=N_b, min_prop = min_prop)
		end
	end
end

export dataset
"""
	dataset(dataset_name::AbstractString)

Returns a dataset from the package's data directory.

## Parameters

* `dataset_name` - The name of the dataset (excluding file extension)

## Examples
Load the Utica simulation dataset:
```julia
julia> D  = dataset("utica_sim0")
```
"""
function dataset(dataset_name::AbstractString)
	basename = joinpath(dirname(@__FILE__), "..", "data")
	csvname = joinpath(basename, string(dataset_name, ".csv.gz"))
    if isfile(csvname)
        return readcsv(csvname)
    end
end


export city_sim_data
"""
	city_sim_data(city::AbstractString="")

Returns a dataset from a remote location.

## Parameters

* `city` - The name of the city for which you want simulated data. If left blank or if does not match an available city, the function will print a list of available city names.

## Examples
Check available datasets:
```julia
julia> D  = city_sim_data()
```
Load the Utica simulation dataset:
```julia
julia> D  = city_sim_data("Utica")
```
Load the Buffalo simulation dataset:
```julia
julia> D  = city_sim_data("Buffalo")
```
"""
function city_sim_data(city::AbstractString=""; testing=false)
	remote_data = Dict("Utica" => "https://zenodo.org/record/2865830/files/utica_sim_full.csv.gz", "Buffalo" => "https://zenodo.org/record/2865830/files/buffalo_sim_full.csv.gz")
	remote_data_alt1 = Dict("Utica" => "https://drive.google.com/uc?export=download&id=13VMKjAIloyEQHBz8LMQqHhgCnv7clFum", "Buffalo" => "https://drive.google.com/uc?export=download&id=13X01yDEt6y99pPbDJz_-hY3nYdCRYbrx")
	if !(city ∈ keys(remote_data))
		println("Available datasets:")
		for k in keys(remote_data)
			println(k)
		end
	else
		println("Fetching $city data from " * remote_data[city] * ". Please wait...")
		D = readcsv(remote_data[city])
		if size(D, 2) == 1 || testing
			println("Zenodo data archives appears to be down. Trying to fetch from Google Drive instead...")
			D = readcsv(remote_data_alt1[city])
		end
		return D
	end
end



#=
export calculate_bias
"""
	calculate_bias(D, randomns)

Returns a .
"""
function calculate_bias(D, randomns)
	bias_calcs = []
	for nrand in [10, 100, 1000, 10000, 50000]
	    D_new = randomize_race(D, nrand)
	    WB = data_prep(D_new)
	    W = WB[1]
	    B = WB[2]
	    pop_STP = stprox(W, B)[1]
	    push!(bias_calcs, check_bias(pop_STP, D_new, 1000, 300))
	end
end
=#

function ib(i, b)
    sigma = Float64(0)
    Eb = mean(b)
    for this_b in b
        sigma += (this_b - Eb)^i
    end
    return sigma/length(b)
end

function aib(a, i, b)
    if length(a) != length(b)
        return "error"
    else
        sigma = Float64(0)
        Eb = mean(b)
        Ea = mean(a)
        for this_index in 1:length(b)
            sigma += (a[this_index] - Ea)*(b[this_index] - Eb)^i
        end
        return sigma/length(b)
    end
end

export rice_correction

function rice_correction(a, b, n, h)
    Ea = mean(a)
    Eb = mean(b)
    result = Float64(0)
    for i in 1:n
        this_numerator = ((-1)^i) * (Ea*ib(i, b) + aib(a, i, b))
        this_denominator = Float64(1)
        for j in 0:i
            this_denominator *= Eb + j*h
        end
        result += this_numerator/this_denominator
    end
    return result
end

export dissimilarity

function dissimilarity(D::DataFrame; group_column::Symbol, group_a, group_b, areal_unit_column::Symbol)
	D_a = by(D[D[group_column].==group_a, :], areal_unit_column, N_a = areal_unit_column => length)
	D_b = by(D[D[group_column].==group_b, :], areal_unit_column, N_b = areal_unit_column => length)
	Dt = join(D_a, D_b, on=areal_unit_column, kind=:outer)
	Dt[ismissing.(Dt.N_a), :N_a] = 0
	Dt[ismissing.(Dt.N_b), :N_b] = 0
	Dt[:A] =size(D[D[group_column].==group_a, :])[1]
	Dt[:B] =size(D[D[group_column].==group_b, :])[1]
	Dt[:diff] = abs.((Dt.N_a ./ Dt.A) .- (Dt.N_b ./ Dt.B))
	return .5*sum(Dt.diff)
end

export sprox

function sprox(D::DataFrame; group_column::Symbol, group_a, group_b, areal_unit_column::Symbol, X_column::Symbol, Y_column::Symbol, f::Function=negative_exponential)
	@assert group_column ∈ names(D)
	@assert areal_unit_column ∈ names(D)
	@assert X_column ∈ names(D)
	@assert Y_column ∈ names(D)
	@assert size(D[ D[group_column] .== group_a, :],1) > 0
	@assert size(D[ D[group_column] .== group_b, :],1) > 0
	D_a = by(D[D[group_column].==group_a, :], areal_unit_column, N_a = areal_unit_column => length, centX = X_column => first, centY = Y_column => first)
	D_b = by(D[D[group_column].==group_b, :], areal_unit_column, N_b = areal_unit_column => length, centX = X_column => first, centY = Y_column => first)
	Dt = join(D_a, D_b, on=[areal_unit_column, :centX, :centY], kind=:outer)
	Dt[ismissing.(Dt.N_a), :N_a] = 0
	Dt[ismissing.(Dt.N_b), :N_b] = 0
	A = sum(Dt.N_a)
	B = sum(Dt.N_b)
	T = A + B
	s_a = Float64(0)
	c_a = Float64(0)
	s_b = Float64(0)
	c_b = Float64(0)
	s_t = Float64(0)
	c_t = Float64(0)
	@showprogress 1 "Computing SP..." for i in 1:size(Dt)[1], j in 1:size(Dt)[1]
		this_distance = f(sqrt((Dt[i, :centX]-Dt[j, :centX])^2 + (Dt[i, :centY]-Dt[j, :centY])^2))
		this_aa = (Dt[i, :N_a]^2) * this_distance/(A^2)
		this_bb = (Dt[i, :N_b]^2) * this_distance/(B^2)
		this_tt = ((Dt[i, :N_a] + Dt[i, :N_b])^2) * this_distance/(T^2)

		t_a = s_a + this_aa
	    if ( abs(s_a) >= abs(this_aa) )
	        c_a += ( (s_a-t_a) + this_aa )
	    else
	        c_a += ( (this_aa-t_a) + s_a )
	    end
	    s_a = t_a

		t_b = s_b + this_bb
	    if ( abs(s_b) >= abs(this_bb) )
	        c_b += ( (s_b-t_b) + this_bb )
	    else
	        c_b += ( (this_bb-t_b) + s_b )
	    end
	    s_b = t_b

		t_t = s_t + this_tt
	    if ( abs(s_t) >= abs(this_tt) )
	        c_t += ( (s_t-t_t) + this_tt )
	    else
	        c_t += ( (this_tt-t_t) + s_t )
	    end
	    s_t = t_t
	end

	Paa = s_a + c_a
	Pbb = s_b + c_b
	Ptt = s_t + c_t

	return (A*Paa + B*Pbb)/(T*Ptt)

end


end # module
