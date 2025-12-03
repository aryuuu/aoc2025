import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let id_pairs =
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

  io.print("part 1: ")
  list.fold(id_pairs, 0, fn(acc, pair) {
    let #(start, end) = pair
    part1_helper(start, end, acc)
  })
  |> int.to_string()
  |> io.println()

  io.print("part 2: ")
  list.fold(id_pairs, 0, fn(acc, pair) {
    let #(start, end) = pair
    part2_helper(start, end, acc)
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

fn part2_helper(a: Int, b: Int, acc: Int) -> Int {
  case a <= b {
    True -> {
      let str_val = int.to_string(a)
      let end =
        string.length(str_val)
        |> int.divide(2)
        |> result.unwrap(string.length(str_val))

      case match_part2_rule(1, end, str_val) {
        True -> part2_helper(a + 1, b, acc + a)
        False -> part2_helper(a + 1, b, acc)
      }
    }
    False -> acc
  }
}

fn chunk_string(str: String, size: Int, acc: List(String)) -> List(String) {
  case str {
    "" -> acc
    _ ->
      chunk_string(string.slice(str, size, string.length(str)), size, [
        string.slice(str, 0, size),
        ..acc
      ])
  }
}

fn match_part2_rule(start: Int, end: Int, str: String) -> Bool {
  case start <= end {
    False -> False
    True -> {
      let chunks = chunk_string(str, start, [])
      let res = case chunks {
        [] -> False
        [_] -> False
        [first, ..rest] -> list.all(rest, fn(x) { x == first })
      }
      case res {
        True -> True
        False -> match_part2_rule(start + 1, end, str)
      }
    }
  }
}

fn list_to_tuple(l: List(a)) -> Result(#(a, a), Nil) {
  case l {
    [a, b] -> Ok(#(a, b))
    _ -> Error(Nil)
  }
}
