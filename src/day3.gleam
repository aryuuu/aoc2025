import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let banks =
    simplifile.read("input/day3.txt")
    |> result.unwrap("")
    |> string.trim()
    |> string.split("\n")
    |> list.map(fn(s) {
      string.trim(s)
      |> string.to_graphemes()
      |> list.map(fn(s) { int.parse(s) |> result.unwrap(-99) })
    })

  io.print("part 1: ")
  list.fold(banks, 0, fn(acc, bank) {
    let temp = helper(bank, 2, 0)
    acc + temp
  })
  |> int.to_string()
  |> io.println()

  io.print("part 2: ")
  list.fold(banks, 0, fn(acc, bank) {
    let temp = helper(bank, 12, 0)
    acc + temp
  })
  |> int.to_string()
  |> io.println()
}

fn helper(bank: List(Int), size: Int, acc: Int) -> Int {
  case size {
    0 -> acc
    _ -> {
      let #(max, max_idx) =
        list.take(bank, list.length(bank) - size + 1)
        |> list.index_fold(#(0, 0), fn(acc, b, idx) {
          let #(val, _) = acc
          case b > val {
            True -> #(b, idx)
            False -> acc
          }
        })
      helper(list.drop(bank, max_idx + 1), size - 1, acc * 10 + max)
    }
  }
}
