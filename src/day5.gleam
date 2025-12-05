import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let inputs =
    simplifile.read("input/day5.txt")
    |> result.unwrap("")
    |> string.split("\n\n")

  let ranges = case inputs {
    [first, ..] -> {
      string.trim(first)
      |> string.split("\n")
      |> list.map(fn(line) {
        string.split(line, "-")
        |> list.map(fn(e) { int.parse(e) |> result.unwrap(-99) })
      })
      |> list.map(fn(pair_list) {
        let lower = case pair_list {
          [h, ..] -> h
          _ -> -99
        }
        let upper = case pair_list {
          [_, rest] -> rest
          _ -> -99
        }
        #(lower, upper)
      })
    }
    _ -> []
  }

  let ids = case inputs {
    [_, last] -> {
      string.trim(last)
      |> string.split("\n")
      |> list.map(fn(line) {
        string.trim(line) |> int.parse() |> result.unwrap(-99)
      })
    }
    _ -> []
  }

  io.print("part 1: ")
  ids
  |> list.fold(0, fn(acc, id) {
    case is_in_any_range(ranges, id) {
      True -> acc + 1
      False -> acc
    }
  })
  |> string.inspect()
  |> io.println()
}

fn is_in_any_range(ranges: List(#(Int, Int)), id: Int) -> Bool {
  case ranges {
    [] -> False
    [range, ..rest] -> {
      case range.0 <= id && range.1 >= id {
        True -> True
        False -> is_in_any_range(rest, id)
      }
    }
  }
}
