include("solution.jl")

lines = readlines("./data/input.txt")

rows = length(lines)
cols = length(lines[1])
input = zeros(Int, rows, cols)

for row in 1:rows
  for col in 1:cols
    input[row, col] = parse(Int, lines[row][col])
  end
end

print("PART 1: ")
println(power_consumption(input))

print("PART 2: ")
println(life_support_rating(input))
