import gleam/io
import gleam/list
import gleam/string

import simplifile

type Block =
  #(String, List(String))

type Item =
  #(String, List(Int))

const sample = "#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####"

fn get_file() -> List(String) {
  let assert Ok(txt) = simplifile.read(from: "./input25.txt")
  txt |> string.split("\n\n")
}

fn decode_blocks(blocks: List(String)) -> List(Block) {
  list.map(blocks, fn(b) {
    // determine if a lock or a key
    let lines = string.split(b, "\n")
    let assert Ok(firstline) = list.first(lines)
    let l = string.length(firstline)
    let generated = list.repeat("#", l) |> string.join("")
    let itemtype = case firstline {
      x if x == generated -> "lock"
      _ -> "key"
    }
    #(itemtype, lines)
  })
}

fn calc_heights(block: Block) -> Item {
  let #(itemtype, lines) = block
  // transpose the lines.
  let tmp: List(List(String)) =
    list.map(lines, fn(line) { string.to_graphemes(line) })
    |> list.transpose()

  // calculate the heights.
  let heights = list.map(tmp, fn(x) { list.count(x, fn(a) { a == "#" }) - 1 })
  #(itemtype, heights)
}

fn try_fit(lock_columns, key_columns) {
  list.zip(lock_columns, key_columns)
  |> list.map(fn(x) {
    let #(l, k) = x
    l + k < 6
  })
}

fn try_keys_with_locks(locks: List(Item), keys: List(Item)) {
  let assert Ok(#("lock", lock)) = list.first(locks)
  list.map(locks, fn(l) {
    let assert #("lock", lock) = l
    list.map(keys, fn(k) {
      let assert #("key", key) = k
      try_fit(lock, key)
    })
  })
}

pub fn main() {
  io.println("Hello from day25!")

  //let foo = string.split(sample, "\n\n") |> decode_blocks()
  let blks = get_file() |> decode_blocks()

  let items = list.map(blks, fn(blk) { calc_heights(blk) })

  let locks =
    list.filter(items, fn(x) {
      let #(itemtype, lst) = x
      itemtype == "lock"
    })
  let keys =
    list.filter(items, fn(x) {
      let #(itemtype, lst) = x
      itemtype == "key"
    })

  let res = try_keys_with_locks(locks, keys)

  // calculate how many fit
  res
  |> list.flatten
  |> list.count(fn(x) { list.all(x, fn(b) { b == True }) })
  |> io.debug
}
