import gleam/dict
import gleam/io
import gleam/list
import gleam/pair
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
    |> draw(row_count, col_count, 0, 0, [], [])

  new_cells
  |> list.index_fold(0, fn(acc, line, i) {
    list.index_fold(line, 0, fn(acc_in, cell, j) {
      case cell == "^" {
        False -> {
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

  io.print("part 2: ")
  let memo = dict.new()
  let first_splitter = get_first_splitter(new_cells, row_count, col_count, 0, 0)
  get_timeline_count(
    new_cells,
    row_count,
    col_count,
    first_splitter.0,
    first_splitter.1,
    memo,
  )
  |> pair.second()
  |> string.inspect()
  |> io.println()
}

fn get_first_splitter(
  cells: List(List(String)),
  row: Int,
  col: Int,
  i: Int,
  j: Int,
) -> #(Int, Int) {
  case i > row {
    True -> #(-1, -1)
    False ->
      case j > col {
        True -> get_first_splitter(cells, row, col, i + 1, 0)
        False ->
          case list.drop(cells, i) {
            [] -> #(-1, -1)
            [head, ..] ->
              case list.drop(head, j) {
                [] -> get_first_splitter(cells, row, col, i + 1, 0)
                [first, ..] ->
                  case first == "^" {
                    True -> #(i, j)
                    False -> get_first_splitter(cells, row, col, i, j + 1)
                  }
              }
          }
      }
  }
}

fn draw(
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
          draw(cells, row, col, i + 1, 0, [], list.append(acc, [row_acc]))
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

          draw(cells, row, col, i, j + 1, list.append(row_acc, [new_cell]), acc)
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

fn get_timeline_count(
  cells: List(List(String)),
  row: Int,
  col: Int,
  i: Int,
  j: Int,
  memo: dict.Dict(#(Int, Int), Int),
) -> #(dict.Dict(#(Int, Int), Int), Int) {
  let key = #(i, j)
  case dict.get(memo, key) {
    Ok(cached) -> #(memo, cached)
    Error(_) -> {
      let left_count = case j - 1 >= 0 {
        False -> #(memo, 0)
        True ->
          case get_next_splitter_index(cells, row, col, i, j - 1) {
            Error(_) -> #(memo, 1)
            Ok(posl) ->
              get_timeline_count(cells, row, col, posl.0, posl.1, memo)
          }
      }

      let right_count = case j + 1 < col {
        False -> #(left_count.0, 0)
        True ->
          case get_next_splitter_index(cells, row, col, i, j + 1) {
            Error(_) -> #(left_count.0, 1)
            Ok(posr) ->
              get_timeline_count(cells, row, col, posr.0, posr.1, left_count.0)
          }
      }

      let total = left_count.1 + right_count.1
      #(dict.insert(right_count.0, key, total), total)
    }
  }
}

fn get_next_splitter_index(
  cells: List(List(String)),
  row: Int,
  col: Int,
  i: Int,
  j: Int,
) -> Result(#(Int, Int), Nil) {
  case i > row {
    True -> Error(Nil)
    False -> {
      case j > col || j < 0 {
        True -> Error(Nil)
        False ->
          case get_cell(cells, i, j) {
            "^" -> Ok(#(i, j))
            "|" -> get_next_splitter_index(cells, row, col, i + 1, j)
            _ -> Error(Nil)
          }
      }
    }
  }
}
