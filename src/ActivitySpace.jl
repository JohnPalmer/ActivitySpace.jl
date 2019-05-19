module ActivitySpace

using DataFrames, Statistics, Random, TableReader

"""
	negative_exponential(x::Number)::Float64

Internal method for calculating negative exponential function. Since this is intended for use in distance calculations, ``x`` must be a positive, single value. The function returns ``e^{-x}``.
"""
function negative_exponential(x::Float64)::Float64
    exp(-x)
end

"""
	identity(x::Number)::Float64

Internal method for calculating identity function. Since this is intended for use in distance calculations, ``x`` must be a positive, single value. The function simply returns ``x``.
"""
function identity(x::Float64)::Float64
    x
end

"""
	simple_distance_2d(x1::Number, x2::Number, y1::Number, y2::Number, f::Function)::Float64

Internal method for calculating Euclidean distance between two points defined by ``x1``, ``y1``, and ``x2``, ``y2``. An optional function ``f`` can be added to transform the distance result.
"""
function simple_distance_2d(; x1::Float64, x2::Float64, y1::Float64, y2::Float64, f::Function=identity)::Float64
    f(sqrt((x1-x2)^2 + (y1-y2)^2))
end

# rethinking this one given time issues
function simple_distance(; P1::Array{<:Number, 1}, P2::Array{<:Number, 1}, f::Function=identity)::Float64
    f(sqrt(sum((P1 .- P2).^2)))
end


"""
	distance_sum(A::Array{<:Number, 2}, B::Union{Array{<:Number, 2}, Nothing}=nothing; f::Function=negative_exponential)::Float64


"""
function distance_sum(A::Array{Float64, 2}; f::Function=negative_exponential)::Float64
    this_distance_sum = Float64(0)
    nrowA::Int64 = size(A, 1)
    for i in 1:(nrowA-1), j in (i+1):nrowA
        this_distance_sum += simple_distance_2d(x1 = A[i, 1], x2 = A[j, 1], y1 = A[i, 2], y2 = A[j, 2], f = f)
    end
    return this_distance_sum
end

function distance_sum(A::Array{Float64, 2}, B::Array{Float64, 2}; f::Function=negative_exponential)::Float64
    this_distance_sum = Float64(0)
    nrowA::Int64 = size(A, 1)
    nrowB::Int64 = size(B, 1)
    for i in 1:nrowA, j in 1:nrowB
        this_distance_sum += simple_distance_2d(x1 = A[i, 1], x2 = B[j, 1], y1 = A[i, 2], y2 = B[j, 2], f = f)
    end
    return this_distance_sum
end


export stprox
"""
	stprox(D::DataFrame; group_column::Symbol, group_a, group_b, X_column::Symbol, Y_column::Symbol, N_a::Int=size(A, 1), N_b::Int=size(B, 1), f::Function=negative_exponential)

Returns the Spatio-Temporal Proximity Index
"""
function stprox(D::DataFrame; group_column::Symbol, group_a, group_b, X_column::Symbol, Y_column::Symbol, time_column::Symbol, N_a::Union{Int, Nothing}=nothing, N_b::Union{Int, Nothing}=nothing, f::Function=negative_exponential, time_approach=1)
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
	    for t in unique(times)
	    	A = convert(Matrix, D[ (D[group_column].==group_a) .& (D[time_column] .== t), [X_column, Y_column] ])	
	    	B = convert(Matrix, D[ (D[group_column].==group_b) .& (D[time_column] .== t), [X_column, Y_column]])	
		    n_a = (size(A, 1)^2 - size(A, 1))/2
		    n_b = (size(B, 1)^2 - size(B, 1))/2
		    n_t = size(A, 1)*size(B, 1) + n_a + n_b
		    Saa = distance_sum(A, f=f)
		    Sbb = distance_sum(B, f=f)
		    Stt = distance_sum(A, B, f=f) + Saa + Sbb
		    Paa += Saa/n_a
		    Pbb += Sbb/n_b
		    Ptt += Stt/n_t
		end
	end
	Paa /= length(times)
	Pbb /= length(times)
	Ptt /= length(times)
    a = N_a * Paa + N_b * Pbb
    b = N_t * Ptt
    STP = a/b
    return Dict("STP" => STP, "Paa" => Paa, "Pbb" => Pbb, "Ptt" => Ptt, "a" => a, "b" => b)
end

export empirical_sampling_distribution
"""
	empirical_sampling_distribution(D, nreps, sample_size)

Returns a DataFrame containing the empirical sampling distribution for the Spatio-Temporal Proximity Index and its components.
"""
function empirical_sampling_distribution(D::DataFrame; group_column::Symbol, group_a, group_b, X_column::Symbol, Y_column::Symbol, time_column::Symbol=:time, ID_column::Symbol=:ID, nreps::Int=500, sample_size::Int=100, f::Function=negative_exponential)::DataFrame
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
		these_IDs = rand(IDs, sample_size)
        Dsamp = D[ indexin(D[ID_column], these_IDs) .!= nothing, :]
        this_result = stprox(Dsamp, group_column=group_column, group_a=group_a, group_b=group_b, X_column=X_column, Y_column = Y_column, time_column=time_column, N_a=N_a, N_b=N_b, f=f)
        push!(STP_esd, this_result["STP"])
        push!(Paa_esd, this_result["Paa"])
        push!(Pbb_esd, this_result["Pbb"])
        push!(Ptt_esd, this_result["Ptt"])
        push!(a_esd, this_result["a"])
        push!(b_esd, this_result["b"])
    end
    return DataFrame(STP = STP_esd, Paa = Paa_esd, Pbb = Pbb_esd, Ptt = Ptt_esd, a = a_esd, b = b_esd)
end

export randomize_column
"""
	randomize_column(D::DataFrame; column_name::Symbol, n::Int)

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
	check_bias(D; group_column::Symbol, group_a, group_b, X_column::Symbol, Y_column::Symbol, nreps::Int=500, sample_size::Int=100, pop_STP::Union{Number, Nothing}=nothing, f::Function=negative_exponential)

Returns a Float containing the difference between the population STP and the mean of the empirical sampling distribution for the given sample size.
"""
function check_bias(D; group_column::Symbol, group_a, group_b, X_column::Symbol, Y_column::Symbol, time_column::Symbol, nreps::Int=500, sample_size::Int=100, pop_STP::Union{Number, Nothing}=nothing, f::Function=negative_exponential)
	@assert group_column ∈ names(D)
	@assert X_column ∈ names(D)
	@assert Y_column ∈ names(D) 
	@assert size(D[ D[group_column] .== group_a, :],1) > 0
	@assert size(D[ D[group_column] .== group_b, :],1) > 0
	if pop_STP == nothing
		pop_STP = stprox(D, group_column=group_column, group_a==group_a, group_b=group_b, X_column=X_column, Y_column=Y_column, time_column=time_column, f=f)
	end
    return pop_STP - mean(empirical_sampling_distribution(D, group_column=group_column, group_a=group_a, group_b=group_b, X_column=X_column, Y_column=Y_column, time_column=time_column, f=f, nreps=nreps, sample_size=sample_size)[1])
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
function city_sim_data(city::AbstractString="")	
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
		if size(D, 2) == 1
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

Returns a XXX.
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
    a = shuffle(a)
    b = shuffle(b)
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
=#

end # module
