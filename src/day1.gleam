import gleam/int
import gleam/io
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let filename = "input/day1.txt"
  let lines =
    case simplifile.read(filename) {
      Ok(content) -> content
      Error(_) -> "FAILED TO LOAD"
    }
    |> string.split("\n")

  let result = part1(lines, 50, 0)
  io.println("part 1 result: " <> int.to_string(result))

  let result = part2(lines, 50, 0)
  io.println("part 2 result: " <> int.to_string(result))
}

fn part1(list: List(String), pos: Int, total: Int) -> Int {
  case list {
    [] -> total
    [first, ..rest] -> {
      let num_str = string.slice(first, 1, string.length(first))
      let num = int.parse(num_str) |> result.unwrap(-1)
      let new_pos = case string.slice(first, 0, 1) {
        "L" -> int.modulo(pos - num, 100) |> result.unwrap(-1)
        _ -> int.modulo(pos + num, 100) |> result.unwrap(-1)
      }
      let new_total = case new_pos {
        0 -> total + 1
        _ -> total
      }
      part1(rest, new_pos, new_total)
    }
  }
}

fn part2(list: List(String), pos: Int, total: Int) -> Int {
  case list {
    [] -> total
    [first, ..rest] -> {
      let num_str = string.slice(first, 1, string.length(first))
      let num = int.parse(num_str) |> result.unwrap(-1)
      let #(new_pos, temp_total) = case string.slice(first, 0, 1) {
        "L" -> {
          let next_pos = pos - num
          let count = case next_pos > 0 {
            True -> 0
            False ->
              case pos {
                0 -> 0
                _ -> 1
              }
              + {
                int.divide(-next_pos, 100)
                |> result.unwrap(0)
              }
          }
          #(int.modulo(pos - num, 100) |> result.unwrap(-1), count)
        }
        _ -> {
          let count = int.divide(pos + num, 100) |> result.unwrap(0)
          #(int.modulo(pos + num, 100) |> result.unwrap(-1), count)
        }
      }

      part2(rest, new_pos, temp_total + total)
    }
  }
}
