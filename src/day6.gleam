import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let rows =
    simplifile.read("input/day6.txt")
    |> result.unwrap("-99")
    |> string.trim()
    |> string.split("\n")
    |> list.map(fn(line) {
      string.trim(line) |> string.split(" ") |> list.filter(fn(s) { s != "" })
    })
  let nums =
    list.take(rows, list.length(rows) - 1)
    |> list.map(fn(row) {
      list.map(row, fn(val) { int.parse(val) |> result.unwrap(-99) })
    })

  let ops =
    list.drop(rows, list.length(rows) - 1)
    |> list.flatten()
    |> list.map(fn(s) {
      case s {
        "+" -> #(int.add, 0)
        "*" -> #(int.multiply, 1)
        _ -> #(int.subtract, 0)
      }
    })

  io.print("part 1: ")
  ops
  |> list.fold(#([], 0), fn(acc, op) {
    let temp =
      list.fold(nums, op.1, fn(acc_in, row) {
        case list.drop(row, acc.1) {
          [head, ..] -> op.0(acc_in, head)
          [] -> acc_in
        }
      })
    #(list.append(acc.0, [temp]), acc.1 + 1)
  })
  |> pair.first()
  |> list.fold(0, fn(acc, a) { int.add(acc, a) })
  |> string.inspect()
  |> io.println()

  io.print("part 2: ")
  let rows =
    simplifile.read("input/day6.txt")
    |> result.unwrap("-99")
    |> string.trim()
    |> string.split("\n")
    |> list.map(fn(line) { string.to_graphemes(line) })
  let nums =
    list.take(rows, list.length(rows) - 1)
    |> list.map(fn(row) {
      list.map(row, fn(val) { int.parse(val) |> result.unwrap(0) })
    })

  let transposed =
    case nums {
      [head, ..] -> {
        list.map(head, fn(_) { 0 })
      }
      [] -> []
    }
    |> list.fold(#([], 0), fn(acc, _) {
      let temp =
        list.fold(nums, [], fn(acc_in, row) {
          case list.drop(row, acc.1) {
            [first, ..] -> list.append(acc_in, [first])
            [] -> acc_in
          }
        })
      #(list.append(acc.0, [temp]), acc.1 + 1)
    })
    |> pair.first()

  let combined =
    transposed
    |> list.map(fn(e) {
      list.fold(e, 0, fn(acc, a) {
        case a > 0 {
          False -> acc
          True -> acc * 10 + a
        }
      })
    })

  let grouped = group(combined, [], [])

  ops
  |> list.index_fold(0, fn(acc, op, idx) {
    case list.drop(grouped, idx) {
      [head, ..] -> list.fold(head, op.1, fn(acc, a) { op.0(acc, a) })
      _ -> acc
    }
    + acc
  })
  |> string.inspect()
  |> io.println()
}

fn group(
  nums: List(Int),
  acc: List(List(Int)),
  acc_in: List(Int),
) -> List(List(Int)) {
  case nums {
    [head] -> {
      case head > 0 {
        True -> list.append(acc, [list.append(acc_in, [head])])
        False -> acc
      }
    }
    [head, ..rest] -> {
      case head > 0 {
        True -> group(rest, acc, list.append(acc_in, [head]))
        False -> group(rest, list.append(acc, [acc_in]), [])
      }
    }
    [] -> acc
  }
}
