ExUnit.start()

defmodule MainTests do
  use ExUnit.Case, async: true

  test "position_multiplied" do
    input = ['forward 5', 'down 5', 'forward 8', 'up 3', 'down 8', 'forward 2']
    assert Part1.position_multiplied(input) == 150
    assert Part2.position_multiplied(input) == 900
  end
end
