import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

const sample = "3   4
4   3
2   5
1   3
3   9
3   3"

fn get_file() -> List(String) {
  let assert Ok(txt) = simplifile.read(from: "./input.txt")
  txt |> string.split("\n")
}

fn decode_lines(lines: List(String)) -> List(#(Int, Int)) {
  let do_line = fn(line) {
    let assert Ok(#(a, b)) = string.split_once(line, " ")
    #(a, string.trim(b))
  }
  let to_ints = fn(tup) {
    let #(a, b) = tup
    let assert Ok(x) = int.parse(a)
    let assert Ok(y) = int.parse(b)
    #(x, y)
  }

  lines
  |> list.filter(fn(x) { x != "" })
  |> list.map(do_line)
  |> list.map(to_ints)
}

pub fn main() {
  //let #(a, b) = sample |> string.split(" ") |> decode_lines() |> list.unzip()
  let #(a, b) = get_file() |> decode_lines() |> list.unzip()

  let sorter = fn(l) { list.sort(l, int.compare) }
  let assert [sorted_a, sorted_b] = [a, b] |> list.map(sorter)

  // calculate differences
  let diffs =
    list.zip(sorted_a, sorted_b)
    |> list.map(fn(x) { x.1 - x.0 })
    |> list.map(int.absolute_value)

  // sum them all up
  let assert Ok(s) = diffs |> list.reduce(fn(x, acc) { x + acc })
  s |> int.to_string() |> io.println()
}