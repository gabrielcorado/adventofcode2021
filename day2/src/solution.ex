defmodule Common do
  def parse(command) do
    cond do
      Enum.take(command, 7) == 'forward' ->
        {:forward, Enum.slice(command, 8..-1//1) |> to_string |> String.to_integer}
      Enum.take(command, 2) == 'up' ->
        {:up, Enum.slice(command, 3..-1//1) |> to_string |> String.to_integer}
      Enum.take(command, 4) == 'down' ->
        {:down, Enum.slice(command, 5..-1//1) |> to_string |> String.to_integer}
      true ->
        :unknown
    end
  end
end

defmodule Part1 do
  def position_multiplied(list) do
    list
    |> Enum.reduce({0, 0}, &move(&2, Common.parse(&1)))
    |> Tuple.product
  end

  defp move({depth, horizontal}, {:forward, n}) do
    {depth, horizontal + n}
  end

  defp move({depth, horizontal}, {:up, n}) do
    {depth - n, horizontal}
  end

  defp move({depth, horizontal}, {:down, n}) do
    {depth + n, horizontal}
  end

  defp move(state, :unknown), do: state
end

defmodule Part2 do
  def position_multiplied(list) do
    list
    |> Enum.reduce({0, 0, 0}, &move(&2, Common.parse(&1)))
    |> Tuple.to_list |> Enum.take(2) |> Enum.product
  end

  defp move({depth, horizontal, aim}, {:forward, n}) do
    {depth + (aim * n), horizontal + n, aim}
  end

  defp move({depth, horizontal, aim}, {:up, n}) do
    {depth, horizontal, aim - n}
  end

  defp move({depth, horizontal, aim}, {:down, n}) do
    {depth, horizontal, aim + n}
  end

  defp move(state, :unknown), do: state
end
