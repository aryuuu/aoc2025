import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let grid =
    simplifile.read("input/day4.txt")
    |> result.unwrap("")
    |> string.trim()
    |> string.split("\n")
    |> list.map(fn(s) {
      string.trim(s)
      |> string.to_graphemes()
      |> list.map(fn(c) {
        case c {
          "@" -> True
          _ -> False
        }
      })
    })

  let row_count = list.length(grid)
  let col_count = case grid {
    [row, ..] -> list.length(row)
    _ -> 0
  }
  io.print("part 1: ")
  part1(grid, row_count, col_count, 0, 0, 0) |> int.to_string() |> io.println()
}

fn part1(
  grid: List(List(Bool)),
  row: Int,
  col: Int,
  i: Int,
  j: Int,
  acc: Int,
) -> Int {
  let neighbors = [
    #(i - 1, j - 1),
    #(i - 1, j),
    #(i - 1, j + 1),
    #(i, j - 1),
    #(i, j + 1),
    #(i + 1, j - 1),
    #(i + 1, j),
    #(i + 1, j + 1),
  ]
  case i < row {
    True -> {
      case j < col {
        True -> {
          case is_paper_roll(grid, i, j) {
            False -> part1(grid, row, col, i, j + 1, acc)
            True -> {
              let count =
                list.fold(neighbors, 0, fn(acc, pos) {
                  case is_paper_roll(grid, pos.0, pos.1) {
                    True -> acc + 1
                    False -> acc
                  }
                })
              let score = case count < 4 {
                True -> 1
                False -> 0
              }
              part1(grid, row, col, i, j + 1, acc + score)
            }
          }
        }
        False -> {
          part1(grid, row, col, i + 1, 0, acc)
        }
      }
    }
    False -> {
      acc
    }
  }
}

fn is_paper_roll(grid: List(List(Bool)), i: Int, j: Int) -> Bool {
  case i < 0 {
    True -> False
    False -> {
      case list.drop(grid, i) {
        [row, ..] ->
          case j < 0 {
            True -> False
            False -> {
              case list.drop(row, j) {
                [col, ..] -> col
                [] -> False
              }
            }
          }
        [] -> False
      }
    }
  }
}
