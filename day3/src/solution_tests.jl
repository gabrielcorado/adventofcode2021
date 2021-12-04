using Test
include("solution.jl")

input = [
  0 0 1 0 0;
  1 1 1 1 0;
  1 0 1 1 0;
  1 0 1 1 1;
  1 0 1 0 1;
  0 1 1 1 1;
  0 0 1 1 1;
  1 1 1 0 0;
  1 0 0 0 0;
  1 1 0 0 1;
  0 0 0 1 0;
  0 1 0 1 0;
]

@test power_consumption(input) == 198
@test life_support_rating(input) == 230
