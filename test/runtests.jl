using ActivitySpace, Statistics, Test, DataFrames

@test ActivitySpace.negative_exponential(0.0) == 1.0
@test typeof(ActivitySpace.negative_exponential(0.0)) == Float64
@test ActivitySpace.negative_exponential(1.0) == exp(-1.0)
# @test_throws AssertionError ActivitySpace.negative_exponential(-1)

@test ActivitySpace.identity(100.0) == 100.0
@test typeof(ActivitySpace.identity(100.0)) == Float64
# @test_throws AssertionError ActivitySpace.identity(-1)

@test ActivitySpace.simple_distance_2d(x1 = 1.0, x2 = 1.0, y1 = 1.0, y2 = 1.0) == 0.0
@test ActivitySpace.simple_distance_2d(x1 = 1.0, x2 = 1.0, y1 = 1.0, y2 = 1.0, f = ActivitySpace.negative_exponential) == 1.0

# @test_throws AssertionError ActivitySpace.simple_distance(P1 = [1,2],  P2= [1,2,3])
# @test_throws AssertionError ActivitySpace.simple_distance(P1 = [1 2; 1 2], P2 = [1,2,3])
# @test_throws AssertionError ActivitySpace.simple_distance(P1 = [1,2,3], P2 = [1 2; 1 2])
@test ActivitySpace.simple_distance(P1 = [0, 0, 0], P2 = [4, 4, 4]) == sqrt(16*3)



thisA = convert(Matrix, DataFrame(X=[0.0, 3.0], Y=[0.0, 4.0], t=1, race="w",))
thisB = convert(Matrix, DataFrame(X=[3.0, 0.0], Y=[4.0, 0.0], t=1, race="b",))

@test ActivitySpace.simple_distance_2d(x1 = thisA[1,1], x2 = thisA[2,1], y1=thisA[1,2], y2=thisA[2,2]) == 5.0

# @test ActivitySpace.distance_sum(thisA[:, [:X, :Y]]) == exp(-5)
# @test ActivitySpace.distance_sum(thisA[:, [:X, :Y, :t]]) == exp(-5)
# @test ActivitySpace.distance_sum(thisA, f = ActivitySpace.identity) == 5
# @test ActivitySpace.distance_sum(thisA, thisB) == exp(-5) + exp(0) + exp(0) + exp(-5)
# @test ActivitySpace.distance_sum(thisA, thisB, f = ActivitySpace.identity) == 10

# TinyD = DataFrame(vcat(thisA, thisB))
# TinyD.time = 1

# testing_stp = ActivitySpace.stprox(thisA, thisB, f=ActivitySpace.identity)
# @test  testing_stp["Paa"] == 5
# @test  testing_stp["Pbb"] == 5
# @test  testing_stp["Ptt"] == (5 + 5 + 10)/6
# @test  testing_stp["a"] == 2*5 + 2*5
# @test  testing_stp["b"] == 4(5 + 5 + 10)/6

D = dataset("utica_sim0")
@test D isa DataFrame

D_small = vcat(D[ D[:race] .== "w", :][1:1000, :], D[ D[:race] .== "b", :][1:300, :] )

this_result = stprox(D_small, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)

@test this_result isa Dict{String,Float64}
@test this_result["Ptt"] == 0.0028392947626870195
@test this_result["Pbb"] == 0.003946521885079636
@test this_result["b"] == 3.6910831914931252
@test this_result["a"] == 5.2936674194953275
@test this_result["Paa"] == 0.004109710853971436

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



@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:doesnotexist, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)
@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="w", group_b="b", X_column=:doesnotexist, Y_column=:Y_UTM, time_column=:time)
@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:doesnotexist, time_column=:time)
@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="doesnotexist", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)
@test_throws AssertionError check_bias(D, pop_STP=1, group_column=:race, group_a="w", group_b="doesnotexist", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)
@test abs(check_bias(D, pop_STP=10, group_column=:race, group_a="w", group_b="b", X_column=:X_UTM, Y_column=:Y_UTM, time_column=:time)) > 0 


@test city_sim_data("doesnotexist") == nothing
@test size(city_sim_data("Utica"), 2) > 1


@test dataset("doesnotexist") == nothing

@test_throws AssertionError randomize_column(D; column_name=:doesnotexist, n=5)

D_shuff = randomize_column(D; column_name=:race, n=5)
@test size(D_shuff, 1) == size(D, 1)
@test ndims(D_shuff) == ndims(D)
@test size(D_shuff[ D_shuff.race.=="w", :], 1) == size(D[ D.race.=="w", :], 1)
D_shuff.race != D.race 
