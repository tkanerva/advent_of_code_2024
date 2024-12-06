import gleam/dict.{type Dict}
import gleam/io
import gleam/list.{range}
import gleam/string
import simplifile

type Coord =
  #(Int, Int)

type Dungeon =
  Dict(Coord, String)

const sample = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

fn get_file() -> List(String) {
  let assert Ok(txt) = simplifile.read(from: "./input4.txt")
  txt
  |> string.split("\n")
}

fn makemap(lst, acc) {
  // convert rows to a dict
  let coord = fn(a, b) { a }
  case lst {
    [] -> acc
    [h, ..t] -> {
      let new = dict.insert(acc, coord(0, 0), h)
      makemap(t, acc)
    }
  }
}

fn mapper(lst) -> #(Dungeon, Coord) {
  let coord = fn(a, b) { #(a, b) }
  let tmp =
    list.index_map(lst, fn(sublist, y) {
      list.index_map(sublist, fn(item, x) { #(coord(x, y), item) })
    })
    |> list.flatten()
  let new = dict.from_list(tmp)
  let size = #(list.length(lst), list.length(lst))
  #(new, size)
}

fn getitem(m: Dungeon, coord: Coord) -> String {
  case dict.get(m, coord) {
    Ok(x) -> x
    _ -> " "
  }
}

// print the map. Side effects galore!
fn printmap(m: Dungeon, size: Coord) {
  let #(w, h) = size
  list.map(range(0, h - 1), fn(y) {
    io.println(" ")

    list.each(range(0, w - 1), fn(x) {
      let assert Ok(ch) = dict.get(m, #(x, y))
      io.print(ch)
    })
  })
  io.println(" ")
}

// all the different ways to catch xmas
fn kernels() {
  [
    [#(0, 0), #(1, 0), #(2, 0), #(3, 0)],
    // left to right, Western world style
    [#(0, 0), #(0, 1), #(0, 2), #(0, 3)],
    // from up to down
    [#(3, 0), #(2, 0), #(1, 0), #(0, 0)],
    // right-to-left, like arabic
    [#(0, 3), #(0, 2), #(0, 1), #(0, 0)],
    // from down to up
    [#(0, 0), #(1, 1), #(2, 2), #(3, 3)],
    // diagonal 1
    [#(3, 3), #(2, 2), #(1, 1), #(0, 0)],
    // diagonal 1r
    [#(0, 3), #(1, 2), #(2, 1), #(3, 0)],
    // diagonal 2
    [#(3, 0), #(2, 1), #(1, 2), #(0, 3)],
    // diagonal 2r
  ]
}

fn match_words(map, kernel, size: Coord) {
  let #(w, h) = size

  list.map(range(0, h + 3), fn(y) {
    list.map(range(0, w + 3), fn(x) {
      let matches =
        list.index_map(kernel, fn(delta, index) {
          let #(dx, dy) = delta
          let c: Coord = #(x + dx, y + dy)
          let item = getitem(map, c)
          matcher(item, index)
        })
      //io.debug(matches)
      let foo = case list.all(matches, fn(bool) { bool }) {
        True -> io.debug([x, y])
        False -> [-1, -1]
      }
    })
  })
}

// match against all four letters of the word
fn matcher(input, index) {
  let res = case index {
    0 -> "X"
    1 -> "M"
    2 -> "A"
    _ -> "S"
  }

  case res {
    x if x == input -> True
    _ -> False
  }
}

pub fn main() {
  io.println("Hello from day4!")

  let di: Dict(#(Int, Int), String) = dict.new()

  let lst1 =
    // sample
    // |> string.split("\n")
    get_file()
    |> list.filter(fn(l) { l != "" })
    |> list.map(fn(x) { string.to_graphemes(x) })

  let #(map, size) = mapper(lst1)
  // |> io.debug()
  io.debug(size)

  printmap(map, size)

  let resultlst =
    list.map(kernels(), fn(k) {
      io.debug(k)
      let result =
        match_words(map, k, size)
        |> list.flatten()
        |> list.filter(fn(x) { x != [-1, -1] })
    })

  io.debug(list.flatten(resultlst))

  io.debug(list.length(list.flatten(resultlst)))
}
