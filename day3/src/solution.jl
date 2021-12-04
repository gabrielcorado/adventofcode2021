# converts BitVector to an integer.
function bitarr_to_int(arr, s = 0)
    v = 1
    for i in view(arr,length(arr):-1:1)
        s += v*i
        v <<= 1
    end
    s
end

# PART 1
function power_consumption(input)
  input_number_size = size(input, 2)
  num = falses(input_number_size)

  for i in 1:input_number_size
    col = input[:, i]
    bit = count(i->i==1, col) > length(col) / 2
    num[i] = bit
  end

  bitarr_to_int(num) * bitarr_to_int(.!num)
end

# PART 2
function life_support_rating(input)
  oxygen = filter_numbers(input, (col, numbers) -> count(i->i==1, col) >= size(numbers, 1) / 2)
  co2 = filter_numbers(input, (col, numbers) -> count(i->i==1, col) < size(numbers, 1) / 2)

  oxygen * co2
end


function filter_numbers(input, common_bit_fn)
  numbers = input

  for i in 1:size(input, 2)
    col = numbers[:, i]
    common_bit = common_bit_fn(col, numbers)
    numbers = numbers[(numbers[:, i] .== common_bit), :]
    if size(numbers, 1) == 1; break; end
  end

  bitarr_to_int(numbers[1, :])
end
