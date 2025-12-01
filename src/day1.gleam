import gleam/int
import gleam/io
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let filename = "input/day1.txt"
  let content = case simplifile.read(filename) {
    Ok(content) -> content
    Error(_) -> "FAILED TO LOAD"
  }
  // io.println(content)
  let lines = string.split(content, "\n")

  let result = rec(lines, 50, 0)

  io.println("result: " <> int.to_string(result))
}

fn rec(list: List(String), pos: Int, total: Int) -> Int {
  case list {
    [first, ..rest] -> {
      let num_str = string.slice(first, 1, 3)
      let num = int.parse(num_str) |> result.unwrap(-1)
      let new_pos = case string.slice(first, 0, 1) {
        "L" -> int.modulo(pos - num, 100) |> result.unwrap(-1)
        _ -> int.modulo(pos + num, 100) |> result.unwrap(-1)
      }
      let new_total = case new_pos {
        0 -> total + 1
        _ -> total
      }
      rec(rest, new_pos, new_total)
    }
    [] -> total
  }
}
