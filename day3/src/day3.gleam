import gleam/result
import gleam/option.{Some}
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import gleam/regexp
import simplifile

const sample = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
"

fn get_file() -> String {
  let assert Ok(txt) = simplifile.read(from: "./input.txt")
  txt
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

pub fn part1(lst) {
  list.map(lst, fn(x) {
    let assert Ok( #(a, b) ) = string.split_once(x, ",") |> io.debug()
    let assert Ok(n1) = int.parse(a)
    let assert Ok(n2) = int.parse(b)
    n1 * n2
  })
  |> list.fold(from: 0, with: fn(x,acc) {x+acc})
}

pub fn main() {

  let data = get_file()
  
let assert Ok(re) = regexp.from_string(".*?mul[(]([0-9]+,[0-9]+)[)].*?")
// let r = regexp.scan(with: re, content: sample)
let r = regexp.scan(with: re, content: data)

let lst =
  list.map(r, fn(x) {
    let assert regexp.Match(content: co, submatches: su) = x
    case su {
      [Some(cmd), ..rest] -> io.debug(cmd)
      _ -> io.debug("-")
      }
}) |> io.debug()

  let res = part1(lst)
  io.debug(res)
}
