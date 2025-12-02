import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  simplifile.read("input/day2.txt")
  |> result.unwrap("")
  |> string.trim()
  |> string.split(",")
  |> list.map(fn(s) {
    string.split(s, "-")
    |> list.map(fn(s) { int.parse(s) |> result.unwrap(-99) })
    |> list_to_tuple()
    |> result.unwrap(#(-99, -99))
  })
  |> list.fold(0, fn(acc, pair) {
    let #(start, end) = pair
    part1_helper(start, end, acc)
  })
  |> int.to_string()
  |> io.println()
}

fn part1_helper(a: Int, b: Int, acc: Int) -> Int {
  case a <= b {
    True -> {
      let str_val = int.to_string(a)
      let temp_acc = case string.length(str_val) % 2 == 0 {
        True -> {
          let mid_point =
            int.divide(string.length(str_val), 2) |> result.unwrap(-99)
          case
            string.slice(str_val, 0, mid_point)
            == string.slice(str_val, mid_point, string.length(str_val))
          {
            True -> a
            False -> 0
          }
        }
        False -> 0
      }
      part1_helper(a + 1, b, acc + temp_acc)
    }
    False -> acc
  }
}

fn list_to_tuple(l: List(a)) -> Result(#(a, a), Nil) {
  case l {
    [a, b] -> Ok(#(a, b))
    _ -> Error(Nil)
  }
}
