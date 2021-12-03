input = File.stream!("data/input.txt")
        |> Stream.map(&(&1 |> String.trim |> String.to_charlist))
        |> Enum.to_list

IO.puts "PART 1: #{Part1.position_multiplied(input)}"
IO.puts "PART 2: #{Part2.position_multiplied(input)}"
