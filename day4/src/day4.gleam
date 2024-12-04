import gleam/io
import gleam/list.{range}
import gleam/string
import gleam/dict.{type Dict}


type Coord = #(Int, Int)
type Dungeon = Dict( Coord, String )


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

fn makemap(lst, acc) {
// convert rows to a dict
  let coord = fn(a,b) { a }
  case lst {
    [] -> acc
    [h, ..t] -> {
      
      let new = dict.insert(acc, coord(0, 0), h)
      makemap(t, acc)
      }
    }
}

fn mapper(lst) -> Dungeon {
  let coord = fn(a,b) { #(a,b) }
  let tmp =
  list.index_map(lst, fn(sublist, y) {
    list.index_map(sublist, fn(item, x) {
      #( coord(x, y), item)
    })
  })
  |> list.flatten()
  let new = dict.from_list(tmp)
  new
}

fn getitem(m: Dungeon, coord: Coord) -> String {
  case dict.get(m, coord) {
    Ok(x) -> x
    _ -> " "
  }
}

// print the map. Side effects galore!
fn printmap(m: Dungeon) {
  list.map(range(0, 2), fn(y) {
    io.println(" ")

    list.each(range(0, 2), fn(x) {
      let assert Ok(ch) = dict.get(m, #(x,y))
      io.print(ch)
    })
  })
  io.println(" ")
}

// all the different ways to catch xmas
fn kernels() {
  [
    [ #(0, 0), #(1, 0), #(2, 0), #(3, 0)],  // left to right, Western world style
    [ #(0, 0), #(0, 1), #(0, 2), #(0, 3)],  // from up to down
    [ #(3, 0), #(2, 0), #(1, 0), #(0, 0)],  // right-to-left, like arabic
    [ #(0, 3), #(0, 2), #(0, 1), #(0, 0)],  // from down to up
    [ #(0, 0), #(1, 1), #(2, 2), #(3, 3)],  // diagonal 1
    [ #(3, 3), #(2, 2), #(1, 1), #(0, 0)],  // diagonal 2
  ]
}

fn match_words(map, kernel) {
  let tmp = list.first(kernels())
  let kernel = case tmp {
    Ok(kernel) -> kernel
    _ -> []
  } 

  list.map(range(0, 2), fn(y) {
    list.map(range(0, 2), fn(x) {
      list.index_map(kernel, fn(delta, index) {
	let #(dx, dy) = delta
	let c: Coord = #(x+dx, y+dy)
	let item = getitem(map, c)
	let result = matcher(item, index)
	
})
})
})
 }

// match against all four letters of the word
fn matcher(input, index) {
  let lst =
    string.to_graphemes("XMAS")
    |> list.drop(index)
    |> list.first()
  case lst {
    x if x == input -> True
    _ -> False
    }
}

pub fn main() {
  io.println("Hello from day4!")

  let di: Dict(#(Int, Int), String) = dict.new()

  let lst1 =
   sample
   |> string.split("\n")
   |> list.map(fn(x) { string.to_graphemes(x) })

  io.debug(lst1)
  let map = mapper(lst1) |> io.debug()

  printmap(map)

  let result = match_words(map, kernels())
  
  //let assert Ok(item) = new |> dict.get( #(1,2))
  
  
}
