using ActivitySpace, Statistics, Test, DataFrames

@test ActivitySpace.negative_exponential(0) == 1
@test typeof(ActivitySpace.negative_exponential(0)) == Float64
@test ActivitySpace.negative_exponential(1) == exp(-1)
@test_throws AssertionError ActivitySpace.negative_exponential(-1)

@test ActivitySpace.identity(100) == 100
@test typeof(ActivitySpace.identity(100)) == Float64
@test_throws AssertionError ActivitySpace.identity(-1)

@test ActivitySpace.simple_distance(x1 = 1, x2 = 1, y1 = 1, y2 = 1) == 0
@test ActivitySpace.simple_distance(x1 = 1, x2 = 1, y1 = 1, y2 = 1, f = ActivitySpace.negative_exponential) == 1


thisA = hcat([0, 3], [0, 4])
thisB = hcat([3, 0], [4, 0])

@test ActivitySpace.simple_distance(x1 = thisA[1,1], x2 = thisA[2,1], y1=thisA[1,2], y2=thisA[2,2]) == 5

@test ActivitySpace.distance_sum(thisA) == exp(-5)
@test ActivitySpace.distance_sum(thisA, f = ActivitySpace.identity) == 5
@test ActivitySpace.distance_sum(thisA, thisB) == exp(-5) + exp(0) + exp(0) + exp(-5)
@test ActivitySpace.distance_sum(thisA, thisB, f = ActivitySpace.identity) == 10

testing_stp = ActivitySpace.stprox(thisA, thisB, f=ActivitySpace.identity)
@test  testing_stp["Paa"] == 5
@test  testing_stp["Pbb"] == 5
@test  testing_stp["Ptt"] == (5 + 5 + 10)/6
@test  testing_stp["a"] == 2*5 + 2*5
@test  testing_stp["b"] == 4(5 + 5 + 10)/6

D = dataset("utica_sim0")
@test D isa DataFrame

@test_throws AssertionError data_prep(D, group_column=:doesnotexist, group_a="w", group_b="b", X_column=:X_UTM18N, Y_column=:Y_UTM18N)
@test_throws AssertionError data_prep(D, group_column=:race, group_a="w", group_b="b", X_column=:doesnotexist, Y_column=:Y_UTM18N)
@test_throws AssertionError data_prep(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM18N, Y_column=:doesnotexist)
@test_throws AssertionError data_prep(D, group_column=:race, group_a="doesnotexist", group_b="b", X_column=:X_UTM18N, Y_column=:Y_UTM18N)
@test_throws AssertionError data_prep(D, group_column=:race, group_a="w", group_b="doesnotexist", X_column=:X_UTM18N, Y_column=:Y_UTM18N)

DP = data_prep(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM18N, Y_column=:Y_UTM18N)
@test DP isa Dict{String,Array{Float64,2}}

this_result = stprox(DP["A"][1:1000,:], DP["B"][1:300,:])

D_small = vcat(D[ D[:race] .== "w", :][1:1000, :], D[ D[:race] .== "b", :][1:300, :] )

this_result2 = stprox(D_small, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM18N, Y_column=:Y_UTM18N)

@test this_result == this_result2

@test this_result isa Dict{String,Float64}
@test this_result["Saa"] == 2052.8005715587324
@test this_result["Sbb"] == 177.00150654582168
@test this_result["STP"] == 1.434177217055333
@test this_result["Stt"] == 2397.358532874785
@test this_result["Ptt"] == 0.0028392947626870195
@test this_result["Pbb"] == 0.003946521885079636
@test this_result["b"] == 3.6910831914931252
@test this_result["a"] == 5.2936674194953275
@test this_result["Paa"] == 0.004109710853971436

@test_throws AssertionError empirical_sampling_distribution(D, group_column=:doesnotexist, group_a="w", group_b="b", X_column=:X_UTM18N, Y_column=:Y_UTM18N)
@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="b", X_column=:doesnotexist, Y_column=:Y_UTM18N)
@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM18N, Y_column=:doesnotexist)
@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="doesnotexist", group_b="b", X_column=:X_UTM18N, Y_column=:Y_UTM18N)
@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="doesnotexist", X_column=:X_UTM18N, Y_column=:Y_UTM18N)
@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM18N, Y_column=:Y_UTM18N, nreps=0)
@test_throws AssertionError empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM18N, Y_column=:Y_UTM18N, sample_size=0)

this_esd = empirical_sampling_distribution(D, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM18N, Y_column=:Y_UTM18N)
@test this_esd isa DataFrame
@test size(this_esd) == (500, 6)



@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:doesnotexist, group_a="w", group_b="b", X_column=:X_UTM18N, Y_column=:Y_UTM18N)
@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="w", group_b="b", X_column=:doesnotexist, Y_column=:Y_UTM18N)
@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM18N, Y_column=:doesnotexist)
@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="doesnotexist", group_b="b", X_column=:X_UTM18N, Y_column=:Y_UTM18N)
@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="w", group_b="doesnotexist", X_column=:X_UTM18N, Y_column=:Y_UTM18N)

@test city_sim_data("doesnotexist") == nothing

@test dataset("doesnotexist") == nothing

