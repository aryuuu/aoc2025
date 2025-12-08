import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let cells =
    simplifile.read("input/day7.txt")
    |> result.unwrap("")
    |> string.trim()
    |> string.split("\n")
    |> list.map(fn(line) { string.trim(line) |> string.to_graphemes() })

  let row_count = list.length(cells)
  let col_count = case cells {
    [head, ..] -> list.length(head)
    [] -> 0
  }

  io.print("part 1: ")
  let new_cells =
    cells
    |> draw_1(row_count, col_count, 0, 0, [], [])

  new_cells
  |> list.index_fold(0, fn(acc, line, i) {
    list.index_fold(line, 0, fn(acc_in, cell, j) {
      case cell == "^" {
        False -> {
          // io.println("cell: " <> cell)
          acc_in
        }
        True ->
          case get_cell(new_cells, i - 1, j) == "|" {
            False -> {
              acc_in
            }
            True -> {
              acc_in + 1
            }
          }
      }
    })
    + acc
  })
  |> string.inspect()
  |> io.println()
}

fn draw_1(
  cells: List(List(String)),
  row: Int,
  col: Int,
  i: Int,
  j: Int,
  row_acc: List(String),
  acc: List(List(String)),
) -> List(List(String)) {
  case i > row {
    True -> acc
    False -> {
      case j > col {
        True -> {
          draw_1(cells, row, col, i + 1, 0, [], list.append(acc, [row_acc]))
        }
        False -> {
          let new_cell = case get_cell(cells, i, j) {
            "S" -> "S"
            "^" -> "^"
            "|" -> "|"
            "." -> {
              case
                get_cell(acc, i - 1, j) == "|" || get_cell(acc, i - 1, j) == "S"
              {
                True -> "|"
                False -> {
                  case
                    {
                      get_cell(cells, i, j - 1) == "^"
                      && get_cell(acc, i - 1, j - 1) == "|"
                    }
                    || {
                      get_cell(cells, i, j + 1) == "^"
                      && get_cell(acc, i - 1, j + 1) == "|"
                    }
                  {
                    True -> "|"
                    False -> "."
                  }
                }
              }
            }
            _ -> ""
          }

          draw_1(
            cells,
            row,
            col,
            i,
            j + 1,
            list.append(row_acc, [new_cell]),
            acc,
          )
        }
      }
    }
  }
}

fn get_cell(cells: List(List(String)), i: Int, j: Int) -> String {
  case i < 0 {
    True -> ""
    False -> {
      case j < 0 {
        True -> ""
        False -> {
          case list.drop(cells, i) {
            [] -> ""
            [head, ..] ->
              case list.drop(head, j) {
                [] -> ""
                [head, ..] -> head
              }
          }
        }
      }
    }
  }
}
