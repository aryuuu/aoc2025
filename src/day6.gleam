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

  io.print("part 1: ")
  list.drop(rows, list.length(rows) - 1)
  |> list.flatten()
  |> list.map(fn(s) {
    case s {
      "+" -> #(int.add, 0)
      "*" -> #(int.multiply, 1)
      _ -> #(int.subtract, 0)
    }
  })
  |> list.fold(#([], 0), fn(acc, op) {
    let temp =
      list.fold(nums, op.1, fn(acc_in, row) {
        case list.drop(row, acc.1) {
          [head, ..] -> op.0(acc_in, head)
          _ -> acc_in
        }
      })
    #(list.append(acc.0, [temp]), acc.1 + 1)
  })
  |> pair.first()
  |> list.fold(0, fn(acc, a) { int.add(acc, a) })
  |> string.inspect()
  |> io.println()
}
