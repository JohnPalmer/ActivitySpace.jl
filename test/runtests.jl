using ActivitySpace, Statistics, Test, DataFrames

@testset "distance calculations" begin
	@test ActivitySpace.negative_exponential(0.0) == 1.0
	@test typeof(ActivitySpace.negative_exponential(0.0)) == Float64
	@test ActivitySpace.negative_exponential(1.0) == exp(-1.0)
	thisA = convert(Matrix, DataFrame(X=[0.0, 3.0], Y=[0.0, 4.0], time=[0.0, 0.0]))
	thisB = convert(Matrix, DataFrame(X=[3.0, 0.0], Y=[4.0, 0.0], time=[0.0, 0.0]))
	@test ActivitySpace.distance_sum(thisA) == exp(-5)
	@test ActivitySpace.distance_sum(thisA, ActivitySpace.identity) == 5
	@test ActivitySpace.distance_sum(thisA, thisB) == exp(-5) + exp(0) + exp(0) + exp(-5)
	@test ActivitySpace.distance_sum(thisA, thisB, ActivitySpace.identity) == 10
	@test ActivitySpace.distance_sum3d(thisA) == exp(-5)
	@test ActivitySpace.distance_sum3d(thisA, ActivitySpace.identity) == 5
	@test ActivitySpace.distance_sum3d(thisA, thisB) == exp(-5) + exp(0) + exp(0) + exp(-5)
	@test ActivitySpace.distance_sum3d(thisA, thisB, ActivitySpace.identity) == 10


end

D = dataset("utica_sim0")

@testset "Spatio-Temporal Proximity Function" begin
	
	@test D isa DataFrame

	D_small = vcat(D[ D[:race] .== "w", :][1:1000, :], D[ D[:race] .== "b", :][1:300, :] )

	this_result = stprox(D_small, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time, time_approach=1)

	@test this_result isa Dict{String,Float64}
	@test this_result["Ptt"] == 0.0028392947626870195
	@test this_result["Pbb"] == 0.003946521885079636
	@test this_result["b"] == 3.6910831914931252
	@test this_result["a"] == 5.2936674194953275
	@test this_result["Paa"] == 0.004109710853971436

	this_result3d = stprox(D_small, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time, time_approach=2)

	@test this_result3d isa Dict{String,Float64}
	@test this_result3d["Ptt"] == 0.0028392947626870195
	@test this_result3d["Pbb"] == 0.003946521885079636
	@test this_result3d["b"] == 3.6910831914931252
	@test this_result3d["a"] == 5.2936674194953275
	@test this_result3d["Paa"] == 0.004109710853971436


end

@testset "Empirical Sampling Distribution" begin

	@test_throws AssertionError empirical_sampling_distribution(D, group_column=:doesnotexist, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM,  time_column=:time, ID_column=:ID)
	@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="b", X_column=:doesnotexist, Y_column=:Y_UTM,  time_column=:time)
	@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:doesnotexist,  time_column=:time)
	@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="doesnotexist", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM,  time_column=:time)
	@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="doesnotexist", X_column=:X_UTM, Y_column=:Y_UTM,  time_column=:time)
	@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time, nreps=0)
	@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM,  time_column=:doesnotexist, sample_size=0)

	this_esd = empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)
	@test this_esd isa DataFrame
	@test size(this_esd) == (500, 6)

end

@testset "Bias Check" begin

	@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:doesnotexist, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)
	@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="w", group_b="b", X_column=:doesnotexist, Y_column=:Y_UTM, time_column=:time)
	@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:doesnotexist, time_column=:time)
	@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="doesnotexist", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)
	@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="w", group_b="doesnotexist", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)
	this_bias = check_bias(D, pop_STP=10, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time, ID_column=:ID, full_output=false)
	@test abs(this_bias.bias[1]) > 0 

end

@testset "Column Randomization" begin
	@test_throws AssertionError randomize_column(D; column_name=:doesnotexist, n=5)
	D_shuff = randomize_column(D; column_name=:race, n=5)
	@test size(D_shuff, 1) == size(D, 1)
	@test ndims(D_shuff) == ndims(D)
	@test size(D_shuff[ D_shuff.race.=="w", :], 1) == size(D[ D.race.=="w", :], 1)
	D_shuff.race != D.race 
end

@testset "Data operations" begin


	@test city_sim_data("doesnotexist") == nothing
	@test size(city_sim_data("Utica"), 2) > 1


	@test dataset("doesnotexist") == nothing

end
