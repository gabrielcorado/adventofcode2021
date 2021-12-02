use std::fs::File;
use std::io::{BufReader, BufRead};

fn read_input(path: &str) -> Vec<i64> {
    let file = File::open(path).expect("failed to open file");
    let reader = BufReader::new(file);

    reader
        .lines()
        .map(|line| line.unwrap().parse::<i64>().unwrap())
        .collect()
}

fn main() {
    let lines = read_input("data/input.txt");
    println!("PART 1: {}", count_increments(lines.to_owned()));
    println!("PART 2: {}", count_sliding_windows_increase(lines.to_owned()));
}

// PART 1
fn count_increments(lines: Vec<i64>) -> i64 {
    let mut iter = lines.iter();
    let mut count: i64 = 0;
    let mut prev = iter.next().expect("should have at least one line");

    for depth in iter {
        if depth > &prev {
            count += 1;
        }

        prev = depth;
    }

    count
}

// PART 2
fn count_sliding_windows_increase(lines: Vec<i64>) -> i64 {
    let mut iter = lines.iter();
    let mut count: i64 = 0;

    // grab first sliding window.
    let mut a = iter.next().expect("missing number from first sliding window");
    let mut b = iter.next().expect("missing number from first sliding window");
    let mut c = iter.next().expect("missing number from first sliding window");

    // first sliding window sum
    let mut prev_window_sum = a + b + c;

    for depth in iter {
        // move b -> a, c -> b, and assign depth to c. this is our current
        // sliding window.
        a = b;
        b = c;
        c = depth;

        // current sliding window sum.
        let window_sum = a + b + c;

        // did it increase?
        if window_sum > prev_window_sum {
            count += 1;
        }

        // current slide window is not the prev, which is going to be used in
        // the next iteration.
        prev_window_sum = window_sum;
    }

    count
}

#[cfg(test)]
mod tests {
    use super::*;


    #[test]
    fn test_increments() {
        let lines = vec![199, 200, 208, 210, 200, 207, 240, 269, 260, 263];
        assert_eq!(count_increments(lines.to_owned()), 7);
        assert_eq!(count_sliding_windows_increase(lines.to_owned()), 5);
    }
}
