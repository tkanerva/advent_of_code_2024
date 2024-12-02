import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

const sample = "
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"

fn get_file() -> List(String) {
  let assert Ok(txt) = simplifile.read(from: "./input.txt")
  txt |> string.split("\n")
}

fn decode_lines(lines: List(String)) -> List(List(Int)) {
  let do_line = fn(line) { string.split(line, " ") }
  let to_ints = fn(lst) {
    list.map(lst, fn(item) {
      let assert Ok(x) = int.parse(item)
      x
    })
  }

  lines
  |> list.filter(fn(x) { x != "" })
  |> list.map(do_line)
  |> list.map(to_ints)
}

fn monotonous(data) {
  let n_positives = list.filter(data, fn(x) { x >= 0 }) |> list.length()
  let n_negatives = list.filter(data, fn(x) { x < 0 }) |> list.length()
  case n_positives, n_negatives {
    0, _ -> True
    _, 0 -> True
    _, _ -> False
  }
}

pub fn part1(data) {
  list.map(data, fn(row) {
    // calculate the deltas
    let deltas =
      row
      |> list.window(2)
      |> list.map(fn(l) {
        let assert [a, b] = l
        b - a
      })

    // reject lists which have both positive and negative values
    let rejected = case monotonous(deltas) {
      False -> []
      x -> deltas
    }
    let orig_len = list.length(deltas)

    let filtered =
      rejected
      |> list.filter(fn(x) {
        let a = int.absolute_value(x)
        a >= 1 && a <= 3
      })

    // reject all which have too few items
    case list.length(filtered) {
      x if x == orig_len -> True
      _ -> False
    }
  })
  |> list.count(fn(x) { x == True })
}

pub fn main() {
  let data =
    //sample
    //|> string.split("\n")
    get_file()
    |> list.filter(fn(l) { l != "" })
    |> decode_lines()

  let res = part1(data)
  io.debug(res)
}
